-- CreateTable
CREATE TABLE "MaritalStatus" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "isOriginal" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "MaritalStatus_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "MaritalStatus_name_key" ON "MaritalStatus"("name");

-- AlterTable
ALTER TABLE "Participation" ADD COLUMN     "maritalStatusId" INTEGER;

-- AddForeignKey
ALTER TABLE "Participation" ADD CONSTRAINT "Participation_maritalStatusId_fkey" FOREIGN KEY ("maritalStatusId") REFERENCES "MaritalStatus"("id") ON DELETE SET NULL ON UPDATE CASCADE;
