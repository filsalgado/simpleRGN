import { NextResponse, NextRequest } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '../auth/[...nextauth]/route';
import prisma from '@/lib/prisma';

export async function GET(request: NextRequest) {
  const professions = await prisma.profession.findMany({
    orderBy: { name: 'asc' }
  });
  return NextResponse.json(professions);
}

export async function POST(request: NextRequest) {
  const session = await getServerSession(authOptions);
  if (!session || !session.user?.email) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  try {
    const user = await prisma.user.findUnique({
      where: { email: session.user.email },
      select: { role: true }
    });

    if (user?.role !== 'ADMIN') {
      return NextResponse.json({ error: 'Access denied' }, { status: 403 });
    }

    const { name } = await request.json();

    if (!name) {
      return NextResponse.json({ error: 'Name is required' }, { status: 400 });
    }

    const profession = await prisma.profession.create({
      data: { name }
    });

    return NextResponse.json(profession, { status: 201 });
  } catch (e) {
    console.error(e);
    return NextResponse.json({ error: 'Error creating profession' }, { status: 500 });
  }
}
