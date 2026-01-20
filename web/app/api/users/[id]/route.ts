import { NextRequest, NextResponse } from 'next/server';
import { getServerSession } from "next-auth";
import { authOptions } from "../../auth/[...nextauth]/route";
import prisma from "@/lib/prisma";
import bcrypt from 'bcryptjs';

export async function GET(req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  const session = await getServerSession(authOptions);
  if (!session || !session.user?.email) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  try {
    const user = await prisma.user.findUnique({
      where: { email: session.user.email },
      select: { role: true, id: true }
    });

    // Allow users to view their own profile, admins can view any
    const { id } = await params;
    const requestedUserId = parseInt(id);

    if (user?.role !== 'ADMIN' && user?.id !== requestedUserId) {
      return NextResponse.json({ error: 'Access denied' }, { status: 403 });
    }

    const userData = await prisma.user.findUnique({
      where: { id: requestedUserId },
      select: { 
        id: true, 
        name: true, 
        email: true, 
        role: true,
        currentParishId: true, 
        currentEventType: true,
        createdAt: true,
        updatedAt: true,
        currentParish: {
          select: {
            id: true,
            name: true
          }
        }
      }
    });

    if (!userData) return NextResponse.json({ error: 'User not found' }, { status: 404 });
    return NextResponse.json(userData);
  } catch (error) {
    console.error(error);
    return NextResponse.json({ error: 'Error fetching user' }, { status: 500 });
  }
}

export async function PATCH(req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  const session = await getServerSession(authOptions);
  if (!session || !session.user?.email) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  try {
    const sessionUser = await prisma.user.findUnique({
      where: { email: session.user.email },
      select: { role: true, id: true }
    });

    const { id } = await params;
    const requestedUserId = parseInt(id);

    // Only admin can change role, users can only change their own profile
    const isAdmin = sessionUser?.role === 'ADMIN';
    if (!isAdmin && sessionUser?.id !== requestedUserId) {
      return NextResponse.json({ error: 'Access denied' }, { status: 403 });
    }

    const { name, email, password, role, currentParishId, currentEventType } = await req.json();
    const updateData: any = {};

    if (name) updateData.name = name;
    if (email) updateData.email = email;
    if (password) updateData.password = await bcrypt.hash(password, 10);
    if (currentParishId !== undefined) updateData.currentParishId = currentParishId ? parseInt(currentParishId) : null;
    if (currentEventType !== undefined) updateData.currentEventType = currentEventType;
    
    // Only admin can change role
    if (role && isAdmin) {
      updateData.role = role;
    }

    const updatedUser = await prisma.user.update({
      where: { id: requestedUserId },
      data: updateData,
      select: {
        id: true,
        name: true,
        email: true,
        role: true,
        currentParishId: true,
        currentEventType: true,
        createdAt: true,
        updatedAt: true,
        currentParish: {
          select: {
            id: true,
            name: true
          }
        }
      }
    });

    return NextResponse.json(updatedUser);
  } catch (error) {
    console.error(error);
    return NextResponse.json({ error: 'Error updating user' }, { status: 500 });
  }
}

export async function DELETE(req: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  const session = await getServerSession(authOptions);
  if (!session || !session.user?.email) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  try {
    const adminUser = await prisma.user.findUnique({
      where: { email: session.user.email },
      select: { role: true, id: true }
    });

    if (adminUser?.role !== 'ADMIN') {
      return NextResponse.json({ error: 'Access denied' }, { status: 403 });
    }

    const { id } = await params;
    const userId = parseInt(id);

    // Prevent deleting self
    if (adminUser.id === userId) {
      return NextResponse.json({ error: 'Cannot delete your own account' }, { status: 400 });
    }

    await prisma.user.delete({
      where: { id: userId }
    });

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error(error);
    return NextResponse.json({ error: 'Error deleting user' }, { status: 500 });
  }
}
