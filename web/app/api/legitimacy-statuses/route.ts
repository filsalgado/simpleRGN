import { NextResponse } from 'next/server';
import prisma from '@/lib/prisma';

export async function GET() {
    try {
        let statuses = await prisma.legitimacyStatus.findMany();
        
        if (statuses.length === 0) {
            // Seed initial values
            const defaults = ["Legítimo", "Natural", "Exposto"];
            for (const name of defaults) {
                await prisma.legitimacyStatus.create({ data: { name } });
            }
            statuses = await prisma.legitimacyStatus.findMany();
        }

        return NextResponse.json(statuses);
    } catch (error) {
        console.error("Error fetching legitimacy statuses:", error);
        return NextResponse.json({ error: "Failed to load" }, { status: 500 });
    }
}
