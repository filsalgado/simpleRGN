import { NextRequest, NextResponse } from 'next/server';
import prisma from '@/lib/prisma';
import { getServerSession } from "next-auth";
import { authOptions } from "@/app/api/auth/[...nextauth]/route";

export async function GET(req: NextRequest) {
  try {
    const session = await getServerSession(authOptions);
    console.log('[DEBUG] Session:', session?.user?.email, 'Role:', (session?.user as any)?.role);
    
    if (!session) {
      console.error('[ERROR] No session found');
      return NextResponse.json({}, { status: 401 });
    }
    
    // @ts-ignore
    const userId = parseInt(session.user?.id || '0');
    console.log('[DEBUG] User ID from session:', userId);
    
    if (isNaN(userId) || userId === 0) {
      console.error('[ERROR] Invalid user ID:', userId);
      return NextResponse.json({}, { status: 401 });
    }

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { currentParishId: true, currentEventType: true }
    });

    console.log('[DEBUG] User found:', user?.currentParishId, user?.currentEventType);

    if (!user) {
      console.error('[ERROR] User not found in database:', userId);
      return NextResponse.json({}, { status: 404 });
    }

    return NextResponse.json({ 
      parishId: user.currentParishId,
      eventType: user.currentEventType
    });
  } catch (error) {
    console.error('[ERROR] Exception in user context:', error);
    return NextResponse.json({ error: String(error) }, { status: 500 });
  }
}
