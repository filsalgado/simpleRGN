/*
  Warnings:

  - The primary key for the `Event` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Event` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `updatedById` column on the `Event` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `Family` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Family` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `fatherId` column on the `Family` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `motherId` column on the `Family` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `marriageEventId` column on the `Family` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `Individual` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Individual` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `familyOfOriginId` column on the `Individual` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `Parish` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Parish` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `Participation` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Participation` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `professionId` column on the `Participation` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `residenceId` column on the `Participation` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `originId` column on the `Participation` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `Place` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Place` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `Profession` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Profession` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `User` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - Changed the type of `parishId` on the `Event` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `createdById` on the `Event` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Added the required column `updatedAt` to the `Participation` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `eventId` on the `Participation` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `individualId` on the `Participation` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `parishId` on the `Place` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- DropForeignKey
ALTER TABLE "Event" DROP CONSTRAINT "Event_createdById_fkey";

-- DropForeignKey
ALTER TABLE "Event" DROP CONSTRAINT "Event_parishId_fkey";

-- DropForeignKey
ALTER TABLE "Event" DROP CONSTRAINT "Event_updatedById_fkey";

-- DropForeignKey
ALTER TABLE "Family" DROP CONSTRAINT "Family_fatherId_fkey";

-- DropForeignKey
ALTER TABLE "Family" DROP CONSTRAINT "Family_marriageEventId_fkey";

-- DropForeignKey
ALTER TABLE "Family" DROP CONSTRAINT "Family_motherId_fkey";

-- DropForeignKey
ALTER TABLE "Individual" DROP CONSTRAINT "Individual_familyOfOriginId_fkey";

-- DropForeignKey
ALTER TABLE "Participation" DROP CONSTRAINT "Participation_eventId_fkey";

-- DropForeignKey
ALTER TABLE "Participation" DROP CONSTRAINT "Participation_individualId_fkey";

-- DropForeignKey
ALTER TABLE "Participation" DROP CONSTRAINT "Participation_originId_fkey";

-- DropForeignKey
ALTER TABLE "Participation" DROP CONSTRAINT "Participation_professionId_fkey";

-- DropForeignKey
ALTER TABLE "Participation" DROP CONSTRAINT "Participation_residenceId_fkey";

-- DropForeignKey
ALTER TABLE "Place" DROP CONSTRAINT "Place_parishId_fkey";

-- AlterTable
ALTER TABLE "Event" DROP CONSTRAINT "Event_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "parishId",
ADD COLUMN     "parishId" INTEGER NOT NULL,
DROP COLUMN "createdById",
ADD COLUMN     "createdById" INTEGER NOT NULL,
DROP COLUMN "updatedById",
ADD COLUMN     "updatedById" INTEGER,
ADD CONSTRAINT "Event_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "Family" DROP CONSTRAINT "Family_pkey",
ADD COLUMN     "contextParishId" INTEGER,
ADD COLUMN     "createdById" INTEGER,
ADD COLUMN     "updatedById" INTEGER,
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "fatherId",
ADD COLUMN     "fatherId" INTEGER,
DROP COLUMN "motherId",
ADD COLUMN     "motherId" INTEGER,
DROP COLUMN "marriageEventId",
ADD COLUMN     "marriageEventId" INTEGER,
ADD CONSTRAINT "Family_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "Individual" DROP CONSTRAINT "Individual_pkey",
ADD COLUMN     "contextParishId" INTEGER,
ADD COLUMN     "createdById" INTEGER,
ADD COLUMN     "legitimacyStatusId" INTEGER,
ADD COLUMN     "updatedById" INTEGER,
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "familyOfOriginId",
ADD COLUMN     "familyOfOriginId" INTEGER,
ADD CONSTRAINT "Individual_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "Parish" DROP CONSTRAINT "Parish_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "Parish_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "Participation" DROP CONSTRAINT "Participation_pkey",
ADD COLUMN     "contextParishId" INTEGER,
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "createdById" INTEGER,
ADD COLUMN     "deathPlaceId" INTEGER,
ADD COLUMN     "kinshipId" INTEGER,
ADD COLUMN     "participationRoleId" INTEGER,
ADD COLUMN     "professionOriginal" TEXT,
ADD COLUMN     "titleId" INTEGER,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "updatedById" INTEGER,
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "eventId",
ADD COLUMN     "eventId" INTEGER NOT NULL,
DROP COLUMN "individualId",
ADD COLUMN     "individualId" INTEGER NOT NULL,
DROP COLUMN "professionId",
ADD COLUMN     "professionId" INTEGER,
DROP COLUMN "residenceId",
ADD COLUMN     "residenceId" INTEGER,
DROP COLUMN "originId",
ADD COLUMN     "originId" INTEGER,
ADD CONSTRAINT "Participation_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "Place" DROP CONSTRAINT "Place_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "parishId",
ADD COLUMN     "parishId" INTEGER NOT NULL,
ADD CONSTRAINT "Place_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "Profession" DROP CONSTRAINT "Profession_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "Profession_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "User" DROP CONSTRAINT "User_pkey",
ADD COLUMN     "currentParishId" INTEGER,
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("id");

-- CreateTable
CREATE TABLE "Title" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Title_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LegitimacyStatus" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "LegitimacyStatus_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ParticipationRole" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "ParticipationRole_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Kinship" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Kinship_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Title_name_key" ON "Title"("name");

-- CreateIndex
CREATE UNIQUE INDEX "LegitimacyStatus_name_key" ON "LegitimacyStatus"("name");

-- CreateIndex
CREATE UNIQUE INDEX "ParticipationRole_name_key" ON "ParticipationRole"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Kinship_name_key" ON "Kinship"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Family_marriageEventId_key" ON "Family"("marriageEventId");

-- CreateIndex
CREATE UNIQUE INDEX "Participation_eventId_individualId_role_key" ON "Participation"("eventId", "individualId", "role");

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_currentParishId_fkey" FOREIGN KEY ("currentParishId") REFERENCES "Parish"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Place" ADD CONSTRAINT "Place_parishId_fkey" FOREIGN KEY ("parishId") REFERENCES "Parish"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Individual" ADD CONSTRAINT "Individual_legitimacyStatusId_fkey" FOREIGN KEY ("legitimacyStatusId") REFERENCES "LegitimacyStatus"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Individual" ADD CONSTRAINT "Individual_familyOfOriginId_fkey" FOREIGN KEY ("familyOfOriginId") REFERENCES "Family"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Individual" ADD CONSTRAINT "Individual_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Individual" ADD CONSTRAINT "Individual_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Individual" ADD CONSTRAINT "Individual_contextParishId_fkey" FOREIGN KEY ("contextParishId") REFERENCES "Parish"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Family" ADD CONSTRAINT "Family_fatherId_fkey" FOREIGN KEY ("fatherId") REFERENCES "Individual"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Family" ADD CONSTRAINT "Family_motherId_fkey" FOREIGN KEY ("motherId") REFERENCES "Individual"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Family" ADD CONSTRAINT "Family_marriageEventId_fkey" FOREIGN KEY ("marriageEventId") REFERENCES "Event"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Family" ADD CONSTRAINT "Family_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Family" ADD CONSTRAINT "Family_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Family" ADD CONSTRAINT "Family_contextParishId_fkey" FOREIGN KEY ("contextParishId") REFERENCES "Parish"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Event" ADD CONSTRAINT "Event_parishId_fkey" FOREIGN KEY ("parishId") REFERENCES "Parish"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Event" ADD CONSTRAINT "Event_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Event" ADD CONSTRAINT "Event_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Participation" ADD CONSTRAINT "Participation_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "Event"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Participation" ADD CONSTRAINT "Participation_individualId_fkey" FOREIGN KEY ("individualId") REFERENCES "Individual"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Participation" ADD CONSTRAINT "Participation_professionId_fkey" FOREIGN KEY ("professionId") REFERENCES "Profession"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Participation" ADD CONSTRAINT "Participation_originId_fkey" FOREIGN KEY ("originId") REFERENCES "Place"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Participation" ADD CONSTRAINT "Participation_residenceId_fkey" FOREIGN KEY ("residenceId") REFERENCES "Place"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Participation" ADD CONSTRAINT "Participation_deathPlaceId_fkey" FOREIGN KEY ("deathPlaceId") REFERENCES "Place"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Participation" ADD CONSTRAINT "Participation_titleId_fkey" FOREIGN KEY ("titleId") REFERENCES "Title"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Participation" ADD CONSTRAINT "Participation_participationRoleId_fkey" FOREIGN KEY ("participationRoleId") REFERENCES "ParticipationRole"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Participation" ADD CONSTRAINT "Participation_kinshipId_fkey" FOREIGN KEY ("kinshipId") REFERENCES "Kinship"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Participation" ADD CONSTRAINT "Participation_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Participation" ADD CONSTRAINT "Participation_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Participation" ADD CONSTRAINT "Participation_contextParishId_fkey" FOREIGN KEY ("contextParishId") REFERENCES "Parish"("id") ON DELETE SET NULL ON UPDATE CASCADE;
