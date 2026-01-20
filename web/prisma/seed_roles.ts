import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const roles = ['Padre', 'Padrinho', 'Madrinha', 'Testemunha'];
  for (const r of roles) {
    await prisma.participationRole.upsert({
      where: { name: r },
      update: {},
      create: { name: r },
    });
  }

  const kinships = [
      'Pai', 'Mãe', 'Avô', 'Avó', 'Tio', 'Tia', 
      'Irmão', 'Irmã', 'Primo', 'Prima', 
      'Sobrinho', 'Sobrinha', 'Marido', 'Mulher',
      'Compadre', 'Comadre'
  ];
  for (const k of kinships) {
    await prisma.kinship.upsert({
      where: { name: k },
      update: {},
      create: { name: k },
    });
  }
}

main()
  .then(async () => {
    await prisma.$disconnect();
    console.log('Seeding completed.');
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
