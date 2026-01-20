import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/app/api/auth/[...nextauth]/route';
import prisma from '@/lib/prisma';
import { Role } from '@prisma/client';

function getRoleFromPath(path: string[]): Role {
    if (path.length === 1) {
        if (['SUBJECT', 'GROOM', 'BRIDE'].includes(path[0])) return path[0] as Role;
        if (path[0] === 'OTHER') return Role.OTHER;
        return Role.SUBJECT; // Default for unmapped single paths
    }
    
    const parent1 = path[1];
    
    if (path.length === 2) {
        // Technically this FATHER is relative to the root person.
        // In a Baptism: Father of Subject = FATHER.
        // In a Marriage: Father of Groom = FATHER? 
        // Prisma Enum is simple. We use general terms.
        if (parent1 === 'FATHER') return Role.FATHER;
        if (parent1 === 'MOTHER') return Role.MOTHER;
    }
    
    if (path.length === 3) {
        const parent2 = path[2];
        if (parent1 === 'FATHER' && parent2 === 'FATHER') return Role.GRANDFATHER_PATERNAL;
        if (parent1 === 'FATHER' && parent2 === 'MOTHER') return Role.GRANDMOTHER_PATERNAL;
        if (parent1 === 'MOTHER' && parent2 === 'FATHER') return Role.GRANDFATHER_MATERNAL;
        if (parent1 === 'MOTHER' && parent2 === 'MOTHER') return Role.GRANDMOTHER_MATERNAL;
    }
    
    return Role.OTHER;
}



export async function GET(req: Request) {
    const session = await getServerSession(authOptions);
    if (!session || !session.user || !session.user.email) {
        return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { searchParams } = new URL(req.url);
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '20');
    const offset = (page - 1) * limit;
    
    // Filtros
    const filterType = searchParams.get('type');
    const filterParish = searchParams.get('parish');
    const allParishes = searchParams.get('allParishes') === 'true';
    
    // Ordenação
    const sortBy = searchParams.get('sortBy') || 'date';
    const sortOrder = (searchParams.get('sortOrder') || 'desc').toUpperCase() as 'ASC' | 'DESC';

    // Get User Context
    const user = await prisma.user.findUnique({
        where: { email: session.user.email },
        select: { id: true, currentParishId: true, role: true }
    });

    if (!user) {
        return NextResponse.json({ error: 'User not found' }, { status: 404 });
    }

    const whereClause: any = {};
    
    // Controle de paróquias
    if (!allParishes || user.role !== 'ADMIN') {
        if (user.currentParishId) {
            whereClause.parishId = user.currentParishId;
        }
    }
    
    // Filtro por tipo de evento
    if (filterType) {
        whereClause.type = filterType;
    }
    
    // Filtro por paróquia ID (quando filterParish é um ID numérico)
    if (filterParish && !isNaN(parseInt(filterParish))) {
        whereClause.parishId = parseInt(filterParish);
    }

    // Definir ordenação
    let orderByArray: any[] = [];
    switch (sortBy) {
        case 'type':
            orderByArray = [{ type: sortOrder === 'ASC' ? 'asc' : 'desc' }];
            break;
        case 'parish':
            orderByArray = [{ parish: { name: sortOrder === 'ASC' ? 'asc' : 'desc' } }];
            break;
        case 'name':
            // Ordenar por nome principal (requer processamento post-query)
            orderByArray = [{ createdAt: 'desc' }];
            break;
        case 'date':
        default:
            orderByArray = [
                { year: sortOrder === 'ASC' ? 'asc' : 'desc' },
                { month: sortOrder === 'ASC' ? 'asc' : 'desc' },
                { day: sortOrder === 'ASC' ? 'asc' : 'desc' }
            ];
            break;
    }

    try {
        const [total, events] = await prisma.$transaction([
            prisma.event.count({ where: whereClause }),
            prisma.event.findMany({
                where: whereClause,
                skip: offset,
                take: limit,
                orderBy: orderByArray,
                include: {
                    parish: true,
                    createdBy: {
                        select: { id: true, name: true }
                    },
                    updatedBy: {
                        select: { id: true, name: true }
                    },
                    participations: {
                        where: {
                            role: { in: ['SUBJECT', 'GROOM', 'BRIDE'] }
                        },
                        include: {
                            individual: true
                        }
                    }
                }
            })
        ]);

        const formattedEvents = events.map(e => {
            const subjects = e.participations.map(p => ({
                role: p.role,
                name: p.individual.name,
                id: p.individual.id
            }));
            
            // Determine display title
            let mainName = "Desconhecido";
            
            if (e.type === 'MARRIAGE') {
                const groom = subjects.find(s => s.role === 'GROOM');
                const bride = subjects.find(s => s.role === 'BRIDE');
                mainName = `${groom?.name || '?'} & ${bride?.name || '?'}`;
            } else {
                const subj = subjects.find(s => s.role === 'SUBJECT');
                mainName = subj?.name || "Sem Nome";
            }

            return {
                id: e.id,
                type: e.type,
                date: `${e.year || '?'}-${String(e.month || '?').padStart(2, '0')}-${String(e.day || '?').padStart(2, '0')}`,
                parish: e.parish.name,
                mainName,
                createdAt: e.createdAt,
                createdBy: e.createdBy,
                updatedBy: e.updatedBy,
                updatedAt: e.updatedAt
            };
        });

        // Ordenar por nome se necessário
        if (sortBy === 'name') {
            formattedEvents.sort((a, b) => {
                const comparison = a.mainName.localeCompare(b.mainName);
                return sortOrder === 'ASC' ? comparison : -comparison;
            });
        }

        return NextResponse.json({
            data: formattedEvents,
            meta: {
                total,
                page,
                limit,
                totalPages: Math.ceil(total / limit)
            }
        });

    } catch (e) {
        console.error(e);
        return NextResponse.json({ error: 'Error fetching records' }, { status: 500 });
    }
}

export async function POST(req: Request) {
    const session = await getServerSession(authOptions);
    if (!session || !session.user || !session.user.email) {
        return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    let payload;
    try {
        payload = await req.json();
    } catch {
        return NextResponse.json({ error: 'Invalid JSON' }, { status: 400 });
    }
    
    const { event, subjects, participants } = payload;

    // Get User Context
    const user = await prisma.user.findUnique({
        where: { email: session.user.email },
        select: { id: true, currentParishId: true }
    });

    if (!user) {
        return NextResponse.json({ error: 'User not found' }, { status: 404 });
    }

    const userId = user.id;
    const contextParishId = user.currentParishId;

    try {
        await prisma.$transaction(async (tx) => {
            // 1. Create Event
            const newEvent = await tx.event.create({
                data: {
                    type: event.type,
                    year: event.year ? parseInt(event.year) : null,
                    month: event.month ? parseInt(event.month) : null,
                    day: event.day ? parseInt(event.day) : null,
                    sourceUrl: event.sourceUrl,
                    notes: event.notes,
                    parishId: parseInt(event.parishId),
                    createdById: userId,
                    updatedById: userId
                }
            });

            // Helper to process a person tree
            const processPerson = async (person: any, path: string[], lineageIndex: string | null = '1') => {
                if (!person || !person.name) return null;

                // Determine Role
                const roleEnum = getRoleFromPath(path);
                
                // Infer Sex
                let sex = 'U';
                if (['FATHER', 'GRANDFATHER_PATERNAL', 'GRANDFATHER_MATERNAL', 'GROOM', 'PRIEST', 'GODFATHER'].includes(roleEnum)) sex = 'M';
                else if (['MOTHER', 'GRANDMOTHER_PATERNAL', 'GRANDMOTHER_MATERNAL', 'BRIDE', 'GODMOTHER'].includes(roleEnum)) sex = 'F';


                // Create Individual
                const individual = await tx.individual.create({
                    data: {
                        name: person.name,
                        sex: person.sex || sex, // Use explicit sex if provided, else inferred
                        legitimacyStatusId: person.legitimacyStatusId ? parseInt(person.legitimacyStatusId) : null,
                        createdById: userId,
                        updatedById: userId,
                        contextParishId: contextParishId
                    }
                });

                // Participation
                await tx.participation.create({
                    data: {
                        eventId: newEvent.id,
                        individualId: individual.id,
                        role: roleEnum,
                        lineageIndex: lineageIndex,
                        
                        nickname: person.nickname || null,
                        professionOriginal: person.professionOriginal || null,
                        professionId: person.professionId ? parseInt(person.professionId) : null,
                        titleId: person.titleId ? parseInt(person.titleId) : null,
                        originId: person.origin ? parseInt(person.origin) : null,
                        residenceId: person.residence ? parseInt(person.residence) : null,
                        deathPlaceId: person.deathPlace ? parseInt(person.deathPlace) : null,
                        
                        // Custom Role (from UI) overriding if provided? 
                        // For generic participants, we use the one from UI.
                        // For Tree, we use roleEnum.
                        // Ideally if roleEnum is OTHER, we might check dynamic role?
                        participationRoleId: person.participationRoleId ? parseInt(person.participationRoleId) : null,
                        kinshipId: person.kinshipId ? parseInt(person.kinshipId) : null,

                        createdById: userId,
                        updatedById: userId,
                        contextParishId: contextParishId,
                    }
                });

                // Process Parents
                let fatherId = null;
                let motherId = null;

                if (person.father && person.father.name) {
                    fatherId = await processPerson(person.father, [...path, 'FATHER'], lineageIndex + '.1');
                }
                if (person.mother && person.mother.name) {
                    motherId = await processPerson(person.mother, [...path, 'MOTHER'], lineageIndex + '.2');
                }

                // Create Family of Origin if parents exist
                if (fatherId || motherId) {
                    const family = await tx.family.create({
                        data: {
                            fatherId: fatherId,
                            motherId: motherId,
                            createdById: userId,
                            updatedById: userId,
                            contextParishId: contextParishId
                        }
                    });
                    
                    await tx.individual.update({
                        where: { id: individual.id },
                        data: { familyOfOriginId: family.id }
                    });
                }
                
                return individual.id;
            };

            // Main Subjects
            const pSubject = subjects.primary;
            // Determine root role
            let rootRole = 'SUBJECT';
            if (event.type === 'MARRIAGE') rootRole = 'GROOM';
            else if (event.type === 'BAPTISM') rootRole = 'SUBJECT';
            else if (event.type === 'DEATH') rootRole = 'SUBJECT';

            const pId = await processPerson(pSubject, [rootRole], '1');
            
            let sId = null;
            if (event.type === 'MARRIAGE' && subjects.secondary) {
                sId = await processPerson(subjects.secondary, ['BRIDE'], '2');
                
                if (pId && sId) {
                     // Create Family for Marriage
                     await tx.family.create({
                        data: {
                            fatherId: pId, 
                            motherId: sId,
                            marriageEventId: newEvent.id,
                            createdById: userId,
                            updatedById: userId,
                            contextParishId: contextParishId
                        }
                    });
                }
            }

            // Other Participants
            if (Array.isArray(participants)) {
                for (const part of participants) {
                    // For generic participants, path is just ['OTHER']
                    // Or we assume the UI handles the "Role" via participationRoleId
                    await processPerson(part, ['OTHER'], null);
                }
            }

        }); // End Transaction

        return NextResponse.json({ success: true });

    } catch (e: any) {
        console.error("Transaction failed", e);
        return NextResponse.json({ error: e.message || 'Error processing request' }, { status: 500 });
    }
}
