import { NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function GET() {
  const parishes = await prisma.parish.findMany({
    orderBy: { name: 'asc' }
  });
  return NextResponse.json(parishes);
}
