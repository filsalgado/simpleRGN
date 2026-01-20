import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/app/api/auth/[...nextauth]/route';
import prisma from '@/lib/prisma';

export async function GET(req: Request, { params }: { params: Promise<{ id: string }> }) {
    const session = await getServerSession(authOptions);
    if (!session || !session.user || !session.user.email) {
        return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { id } = await params;

    try {
        const event = await prisma.event.findUnique({
            where: { id: parseInt(id) },
            include: {
                parish: true,
                participations: {
                    include: {
                        individual: {
                            include: {
                                familyOfOrigin: {
                                    include: {
                                        father: {
                                            include: {
                                                familyOfOrigin: {
                                                    include: {
                                                        father: true,
                                                        mother: true
                                                    }
                                                }
                                            }
                                        },
                                        mother: {
                                            include: {
                                                familyOfOrigin: {
                                                    include: {
                                                        father: true,
                                                        mother: true
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        },
                        profession: true,
                        title: true,
                        origin: true,
                        residence: true,
                        deathPlace: true,
                        participationRole: true,
                        kinship: true
                    }
                }
            }
        });

        if (!event) {
            return NextResponse.json({ error: 'Event not found' }, { status: 404 });
        }

        // Check if user has access to this parish
        const user = await prisma.user.findUnique({
            where: { email: session.user.email },
            select: { currentParishId: true }
        });

        if (user && user.currentParishId && event.parishId !== user.currentParishId) {
            // Optionally restrict access, or allow viewing all - comment out if you want public access
            // return NextResponse.json({ error: 'Access denied' }, { status: 403 });
        }

        return NextResponse.json(event);

    } catch (e) {
        console.error(e);
        return NextResponse.json({ error: 'Error fetching event' }, { status: 500 });
    }
}

export async function PATCH(req: Request, { params }: { params: Promise<{ id: string }> }) {
    console.log('=== PATCH handler called ===');
    const session = await getServerSession(authOptions);
    if (!session || !session.user || !session.user.email) {
        return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { id } = await params;

    let payload;
    try {
        payload = await req.json();
    } catch {
        return NextResponse.json({ error: 'Invalid JSON' }, { status: 400 });
    }

    const { event: eventData, subjects, participants } = payload;
    console.log('Received payload with subjects:', {
        primaryName: subjects?.primary?.name,
        primaryMother: subjects?.primary?.mother?.name,
        secondaryName: subjects?.secondary?.name,
        secondaryMother: subjects?.secondary?.mother?.name,
        participantsCount: participants?.length
    });

    if (!eventData) {
        return NextResponse.json({ error: 'Event data is required' }, { status: 400 });
    }

    // Get user
    const user = await prisma.user.findUnique({
        where: { email: session.user.email },
        select: { id: true, currentParishId: true }
    });

    if (!user) {
        return NextResponse.json({ error: 'User not found' }, { status: 404 });
    }

    try {
        const eventId = parseInt(id);

        await prisma.$transaction(async (tx) => {
            // 1. Update event basic data
            // Helper to convert empty strings and invalid values to null
            const toIntOrNull = (value: any) => {
                if (!value || value === '' || isNaN(parseInt(value))) return null;
                return parseInt(value);
            };

            await tx.event.update({
                where: { id: eventId },
                data: {
                    type: eventData.type || undefined,
                    year: toIntOrNull(eventData.year),
                    month: toIntOrNull(eventData.month),
                    day: toIntOrNull(eventData.day),
                    sourceUrl: eventData.sourceUrl || null,
                    notes: eventData.notes || null,
                    parishId: eventData.parishId ? parseInt(eventData.parishId) : undefined,
                    updatedById: user.id
                }
            });

            // 2. Helper function to update/create a person and their ancestors recursively
            const saveOrUpdatePerson = async (person: any, role: string, lineageIndex: string = '1') => {
                if (!person || !person.name) {
                    console.log('Skipping person: no name or person is null', { person, role, lineageIndex });
                    return null;
                }

                const isNewPerson = person.id.toString().startsWith('temp_');
                console.log('saveOrUpdatePerson:', { name: person.name, role, lineageIndex, isNewPerson, id: person.id });
                let individualId: number;

                if (isNewPerson) {
                    // Create new individual
                    const newIndividual = await tx.individual.create({
                        data: {
                            name: person.name,
                            sex: person.sex || 'U',
                            legitimacyStatusId: person.legitimacyStatusId ? parseInt(person.legitimacyStatusId) : null,
                            createdById: user.id,
                            updatedById: user.id,
                            contextParishId: user.currentParishId
                        }
                    });

                    individualId = newIndividual.id;
                    console.log(`Created Individual ${individualId}: ${person.name}, role=${role}, lineageIndex=${lineageIndex}`);

                    // Create participation
                    try {
                        await tx.participation.create({
                            data: {
                                eventId: eventId,
                                individualId: newIndividual.id,
                                role: role as any,
                                lineageIndex: lineageIndex,
                                nickname: person.nickname || null,
                                professionOriginal: person.professionOriginal || null,
                                professionId: person.professionId ? parseInt(person.professionId) : null,
                                titleId: person.titleId ? parseInt(person.titleId) : null,
                                originId: person.origin ? parseInt(person.origin) : null,
                                residenceId: person.residence ? parseInt(person.residence) : null,
                                deathPlaceId: person.deathPlace ? parseInt(person.deathPlace) : null,
                                participationRoleId: person.participationRoleId ? parseInt(person.participationRoleId) : null,
                                kinshipId: person.kinshipId ? parseInt(person.kinshipId) : null,
                                createdById: user.id,
                                updatedById: user.id,
                                contextParishId: user.currentParishId
                            }
                        });
                        console.log(`Created Participation for Individual ${individualId}, role=${role}, lineageIndex=${lineageIndex}`);
                    } catch (e: any) {
                        console.error(`ERROR creating Participation for Individual ${individualId}:`, e.message);
                        throw e;
                    }
                } else {
                    individualId = parseInt(person.id);
                    
                    // Update existing individual
                    await tx.individual.update({
                        where: { id: individualId },
                        data: {
                            name: person.name,
                            sex: person.sex || 'U',
                            legitimacyStatusId: person.legitimacyStatusId ? parseInt(person.legitimacyStatusId) : null,
                            updatedById: user.id
                        }
                    });

                    // Update or create participation with the specific role
                    const participation = await tx.participation.findFirst({
                        where: { 
                            eventId: eventId,
                            individualId: individualId,
                            role: role as any
                        }
                    });

                    if (participation) {
                        await tx.participation.update({
                            where: { id: participation.id },
                            data: {
                                lineageIndex: lineageIndex,
                                nickname: person.nickname || null,
                                professionOriginal: person.professionOriginal || null,
                                professionId: person.professionId ? parseInt(person.professionId) : null,
                                titleId: person.titleId ? parseInt(person.titleId) : null,
                                originId: person.origin ? parseInt(person.origin) : null,
                                residenceId: person.residence ? parseInt(person.residence) : null,
                                deathPlaceId: person.deathPlace ? parseInt(person.deathPlace) : null,
                                participationRoleId: person.participationRoleId ? parseInt(person.participationRoleId) : null,
                                kinshipId: person.kinshipId ? parseInt(person.kinshipId) : null,
                                updatedById: user.id
                            }
                        });
                    } else {
                        // Create new participation if it doesn't exist
                        await tx.participation.create({
                            data: {
                                eventId: eventId,
                                individualId: individualId,
                                role: role as any,
                                lineageIndex: lineageIndex,
                                nickname: person.nickname || null,
                                professionOriginal: person.professionOriginal || null,
                                professionId: person.professionId ? parseInt(person.professionId) : null,
                                titleId: person.titleId ? parseInt(person.titleId) : null,
                                originId: person.origin ? parseInt(person.origin) : null,
                                residenceId: person.residence ? parseInt(person.residence) : null,
                                deathPlaceId: person.deathPlace ? parseInt(person.deathPlace) : null,
                                participationRoleId: person.participationRoleId ? parseInt(person.participationRoleId) : null,
                                kinshipId: person.kinshipId ? parseInt(person.kinshipId) : null,
                                createdById: user.id,
                                updatedById: user.id,
                                contextParishId: user.currentParishId
                            }
                        });
                    }
                }

                // Process ancestors recursively (father and mother)
                try {
                    if (person.father && person.father.name) {
                        await saveOrUpdatePerson(person.father, 'FATHER', lineageIndex + '.1');
                    }
                } catch (e: any) {
                    console.error(`Error processing father of ${person.name}:`, e.message);
                    throw e;
                }
                
                try {
                    if (person.mother && person.mother.name) {
                        await saveOrUpdatePerson(person.mother, 'MOTHER', lineageIndex + '.2');
                    }
                } catch (e: any) {
                    console.error(`Error processing mother of ${person.name}:`, e.message);
                    throw e;
                }

                return individualId;
            };

            // 3. Update subjects
            if (subjects?.primary && subjects.primary.name) {
                await saveOrUpdatePerson(subjects.primary, 'SUBJECT', subjects.primary.lineageIndex || '1');
            }

            if (subjects?.secondary && subjects.secondary.name) {
                await saveOrUpdatePerson(subjects.secondary, subjects.secondary.role === 'BRIDE' ? 'BRIDE' : 'GROOM', subjects.secondary.lineageIndex || '2');
            }

            // 4. Update participants
            if (Array.isArray(participants)) {
                // Get existing participants (exclude subject, spouse, and ancestor roles)
                const ancestorRoles = ['FATHER', 'MOTHER', 'GRANDFATHER_PATERNAL', 'GRANDMOTHER_PATERNAL', 'GRANDFATHER_MATERNAL', 'GRANDMOTHER_MATERNAL'] as const;
                const existingParticipations = await tx.participation.findMany({
                    where: {
                        eventId: eventId,
                        role: { notIn: ['SUBJECT', 'GROOM', 'BRIDE', ...ancestorRoles] as any }
                    }
                });

                // Delete participants that are not in the new list (but keep ancestors)
                const newParticipantIds = participants
                    .filter((p: any) => !p.id.toString().startsWith('temp_'))
                    .map((p: any) => parseInt(p.id));

                for (const existing of existingParticipations) {
                    if (!newParticipantIds.includes(existing.individualId)) {
                        await tx.participation.delete({
                            where: { id: existing.id }
                        });
                    }
                }

                // Save/update participants with their specific roles
                for (const participant of participants) {
                    // Use the participant's role if provided, otherwise default to 'OTHER'
                    const participantRole = participant.role && participant.role !== 'SUBJECT' ? participant.role : 'OTHER';
                    // Use the participant's lineageIndex if provided, otherwise use default
                    const participantLineageIndex = participant.lineageIndex || '1';
                    await saveOrUpdatePerson(participant, participantRole, participantLineageIndex);
                }
            }
        });

        return NextResponse.json({ success: true });

    } catch (e: any) {
        console.error("Error updating event", e);
        return NextResponse.json({ error: e.message || 'Error updating event' }, { status: 500 });
    }
}

export async function DELETE(req: Request, { params }: { params: Promise<{ id: string }> }) {
    const session = await getServerSession(authOptions);
    if (!session || !session.user || !session.user.email) {
        return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { id } = await params;

    try {
        await prisma.event.delete({
            where: { id: parseInt(id) }
        });

        return NextResponse.json({ success: true });

    } catch (e: any) {
        console.error("Error deleting event", e);
        return NextResponse.json({ error: e.message || 'Error deleting event' }, { status: 500 });
    }
}
