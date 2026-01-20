-- AlterTable
ALTER TABLE "Kinship" ADD COLUMN     "isOriginal" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "Parish" ADD COLUMN     "isOriginal" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "ParticipationRole" ADD COLUMN     "isOriginal" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "Place" ADD COLUMN     "isOriginal" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "Profession" ADD COLUMN     "isOriginal" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "Title" ADD COLUMN     "isOriginal" BOOLEAN NOT NULL DEFAULT false;
