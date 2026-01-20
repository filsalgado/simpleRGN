import { NextResponse, NextRequest } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '../auth/[...nextauth]/route';
import prisma from '@/lib/prisma';

export async function GET(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams;
  const parishId = searchParams.get('parishId');
  const query = searchParams.get('query');

  const whereClause: any = {};
  if (parishId) whereClause.parishId = parseInt(parishId);
  if (query) {
      whereClause.name = {
          contains: query,
          mode: 'insensitive'
      };
  }

  // When fetching all places (no parishId), increase the limit
  const limit = parishId ? 50 : 1000;

  const places = await prisma.place.findMany({
    where: whereClause,
    orderBy: { name: 'asc' },
    include: {
        parish: true
    },
    take: limit
  });

  // Add parishId to each place for easier processing in the frontend
  const placesWithParishId = places.map(p => ({
    ...p,
    parishId: p.parishId.toString()
  }));

  return NextResponse.json(placesWithParishId);
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

    const body = await request.json();
    const { name, parishId } = body;

    if (!name || !parishId) {
      return NextResponse.json({ error: 'Name and Parish ID are required' }, { status: 400 });
    }

    const place = await prisma.place.create({
      data: {
        name,
        parishId: parseInt(parishId)
      },
      include: {
        parish: true
      }
    });

    return NextResponse.json(place);
  } catch (error) {
    console.error('Error creating place:', error);
    return NextResponse.json({ error: 'Failed to create place' }, { status: 500 });
  }
}
