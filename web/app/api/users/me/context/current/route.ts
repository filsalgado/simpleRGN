import { NextRequest, NextResponse } from 'next/server';
import prisma from '@/lib/prisma';
import { getServerSession } from "next-auth";
import { authOptions } from "@/app/api/auth/[...nextauth]/route";

export async function GET(req: NextRequest) {
  try {
    const session = await getServerSession(authOptions);
    if (!session) return NextResponse.json({}, { status: 401 });
    
    // @ts-ignore
    const userId = parseInt(session.user?.id || '0');
    if (isNaN(userId) || userId === 0) {
      return NextResponse.json({}, { status: 401 });
    }

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { currentParishId: true, currentEventType: true }
    });

    if (!user) {
      return NextResponse.json({}, { status: 404 });
    }

    return NextResponse.json({ 
      parishId: user.currentParishId,
      eventType: user.currentEventType
    });
  } catch (error) {
    console.error('Error fetching user context:', error);
    return NextResponse.json({}, { status: 500 });
  }
}
