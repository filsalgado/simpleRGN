import { NextRequest, NextResponse } from 'next/server';
import prisma from '@/lib/prisma';
import { getServerSession } from "next-auth";
import { authOptions } from "@/app/api/auth/[...nextauth]/route";

export async function PATCH(req: NextRequest) {
  const session = await getServerSession(authOptions);
  if (!session) return new NextResponse("Unauthorized", { status: 401 });
  
  // @ts-ignore
  const userId = parseInt(session.user.id);

  try {
    const body = await req.json();
    const { parishId, eventType } = body;
    
    const updateData: any = {};
    if (parishId !== undefined) {
      updateData.currentParishId = parseInt(parishId);
    }
    if (eventType !== undefined) {
      updateData.currentEventType = eventType;
    }

    await prisma.user.update({
      where: { id: userId },
      data: updateData
    });

    return NextResponse.json({ success: true, parishId, eventType });
  } catch (error) {
    console.error(error);
    return new NextResponse("Error updating context", { status: 500 });
  }
}
