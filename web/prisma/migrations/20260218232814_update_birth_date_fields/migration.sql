/*
  Warnings:

  - You are about to drop the column `birthDate` on the `Individual` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Individual" DROP COLUMN "birthDate",
ADD COLUMN     "birthDay" INTEGER,
ADD COLUMN     "birthMonth" INTEGER,
ADD COLUMN     "birthYear" INTEGER;
