import { getServerSession } from 'next-auth';
import { authOptions } from '../auth/[...nextauth]/route';
import { NextResponse, NextRequest } from 'next/server';
import prisma from '@/lib/prisma';

export async function GET() {
  const roles = await prisma.participationRole.findMany({
    orderBy: { name: 'asc' }
  });
  return NextResponse.json(roles);
}

export async function POST(req: NextRequest) {
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

    const { name } = await req.json();

    if (!name) {
      return NextResponse.json({ error: 'Name is required' }, { status: 400 });
    }

    const role = await prisma.participationRole.create({
      data: { name }
    });

    return NextResponse.json(role, { status: 201 });
  } catch (e) {
    console.error(e);
    return NextResponse.json({ error: 'Error creating participation role' }, { status: 500 });
  }
}
