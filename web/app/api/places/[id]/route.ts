import { NextResponse, NextRequest } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/app/api/auth/[...nextauth]/route';
import prisma from '@/lib/prisma';

export async function GET(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    
    const place = await prisma.place.findUnique({
      where: { id: parseInt(id) },
      include: {
        parish: true
      }
    });

    if (!place) {
      return NextResponse.json({ error: 'Place not found' }, { status: 404 });
    }

    return NextResponse.json(place);
  } catch (e) {
    console.error(e);
    return NextResponse.json({ error: 'Error fetching place' }, { status: 500 });
  }
}

export async function PATCH(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
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

    const { id } = await params;
    const { name, parishId } = await request.json();

    if (!name || !parishId) {
      return NextResponse.json({ error: 'Name and Parish ID are required' }, { status: 400 });
    }

    const place = await prisma.place.update({
      where: { id: parseInt(id) },
      data: {
        name,
        parishId: parseInt(parishId)
      },
      include: {
        parish: true
      }
    });

    return NextResponse.json(place);
  } catch (e) {
    console.error(e);
    return NextResponse.json({ error: 'Error updating place' }, { status: 500 });
  }
}

export async function DELETE(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
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

    const { id } = await params;

    await prisma.place.delete({
      where: { id: parseInt(id) }
    });

    return NextResponse.json({ success: true });
  } catch (e) {
    console.error(e);
    return NextResponse.json({ error: 'Error deleting place' }, { status: 500 });
  }
}
