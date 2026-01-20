import { PrismaClient } from '@prisma/client';
import fs from 'fs';
import path from 'path';

const prisma = new PrismaClient();

interface CSVRow {
  [key: string]: string;
}

function parseCSV(filePath: string): CSVRow[] {
  const content = fs.readFileSync(filePath, 'utf-8');
  const lines = content.trim().split('\n');
  
  if (lines.length === 0) return [];

  const headers = lines[0].split(';').map(h => h.trim());
  const rows: CSVRow[] = [];

  for (let i = 1; i < lines.length; i++) {
    const line = lines[i].trim();
    if (!line) continue;

    const values = line.split(';').map(v => v.trim().replace(/^"|"$/g, ''));
    const row: CSVRow = {};

    headers.forEach((header, index) => {
      row[header] = values[index] || '';
    });

    rows.push(row);
  }

  return rows;
}

async function seedDatabase() {
  try {
    console.log('Starting database reset and seeding...');

    // 1. Delete all existing data (in correct order due to foreign keys)
    console.log('Clearing existing data...');
    
    // Delete Events first (has foreign keys)
    await prisma.event.deleteMany({});
    
    // Delete Participations
    await prisma.participation.deleteMany({});
    
    // Delete Individuals
    await prisma.individual.deleteMany({});
    
    // Delete Families
    await prisma.family.deleteMany({});
    
    // Delete reference tables
    await prisma.place.deleteMany({});
    await prisma.profession.deleteMany({});
    await prisma.title.deleteMany({});
    await prisma.kinship.deleteMany({});
    await prisma.participationRole.deleteMany({});
    
    // Keep User and Parish data (don't delete them)
    // Just clear Parish data if needed
    const parishes = await prisma.parish.findMany({});
    if (parishes.length > 0) {
      console.log(`Found ${parishes.length} existing parishes, clearing them...`);
      await prisma.parish.deleteMany({});
    }

    console.log('Data cleared successfully.');

    // 2. Load and insert CSV data
    const csvDir = path.join(process.cwd(), 'prisma', '..', '..', 'aux_data');
    
    // Load Kinship
    console.log('Loading Kinship...');
    const kinshipData = parseCSV(path.join(csvDir, 'Kinship.csv'));
    const kinshipNames = new Set<string>();
    for (const row of kinshipData) {
      const id = parseInt(row.id);
      const name = row.name?.trim() || '';
      if (name && !kinshipNames.has(name)) {
        kinshipNames.add(name);
        try {
          await prisma.kinship.create({
            data: {
              id,
              name,
              isOriginal: true
            }
          });
        } catch (e) {
          // Skip duplicates
        }
      }
    }
    console.log(`✓ Loaded ${kinshipNames.size} kinships`);

    // Load Profession
    console.log('Loading Professions...');
    const professionData = parseCSV(path.join(csvDir, 'Profession.csv'));
    for (const row of professionData) {
      const id = parseInt(row.id);
      const name = row.name?.trim() || '';
      if (name) {
        try {
          await prisma.profession.create({
            data: {
              id,
              name,
              isOriginal: true
            }
          });
        } catch (e) {
          // Skip duplicates
        }
      }
    }
    console.log(`✓ Loaded ${professionData.length} professions`);

    // Load Title
    console.log('Loading Titles...');
    const titleData = parseCSV(path.join(csvDir, 'Title.csv'));
    for (const row of titleData) {
      const id = parseInt(row.id);
      const name = row.name?.trim() || '';
      if (name) {
        try {
          await prisma.title.create({
            data: {
              id,
              name,
              isOriginal: true
            }
          });
        } catch (e) {
          // Skip duplicates
        }
      }
    }
    console.log(`✓ Loaded ${titleData.length} titles`);

    // Load ParticipationRole
    console.log('Loading ParticipationRoles...');
    const participationRoleData = parseCSV(path.join(csvDir, 'ParticipationRole.csv'));
    for (const row of participationRoleData) {
      const id = parseInt(row.id);
      const name = row.name?.trim() || '';
      if (name) {
        try {
          await prisma.participationRole.create({
            data: {
              id,
              name,
              isOriginal: true
            }
          });
        } catch (e) {
          // Skip duplicates
        }
      }
    }
    console.log(`✓ Loaded ${participationRoleData.length} participation roles`);

    // Load Parish
    console.log('Loading Parishes...');
    const parishData = parseCSV(path.join(csvDir, 'Parish.csv'));
    for (const row of parishData) {
      const id = parseInt(row.id);
      const name = row.name?.trim() || '';
      const municipality = row.municipality?.trim() || null;
      
      if (name && id > 0) {
        try {
          await prisma.parish.create({
            data: {
              id,
              name,
              municipality,
              district: null,
              isOriginal: true
            }
          });
        } catch (e) {
          // Skip duplicates
        }
      }
    }
    console.log(`✓ Loaded ${parishData.length} parishes`);

    // Load Place (depends on Parish existing)
    console.log('Loading Places...');
    const placeData = parseCSV(path.join(csvDir, 'Place.csv'));
    let placesSkipped = 0;
    for (const row of placeData) {
      const id = parseInt(row.id);
      const parishId = parseInt(row.parishId);
      const name = row.name?.trim() || '';
      
      if (id > 0 && parishId > 0 && name) {
        try {
          // Check if parish exists
          const parish = await prisma.parish.findUnique({
            where: { id: parishId }
          });
          
          if (parish) {
            await prisma.place.create({
              data: {
                id,
                parishId,
                name,
                isOriginal: true
              }
            });
          } else {
            placesSkipped++;
          }
        } catch (e) {
          // Skip duplicates or errors
        }
      }
    }
    console.log(`✓ Loaded ${placeData.length - placesSkipped} places (${placesSkipped} skipped due to missing parishes)`);

    console.log('\n✅ Database seeding completed successfully!');
    console.log('\nSummary:');
    console.log(`- Kinship: ${kinshipData.length}`);
    console.log(`- Professions: ${professionData.length}`);
    console.log(`- Titles: ${titleData.length}`);
    console.log(`- ParticipationRoles: ${participationRoleData.length}`);
    console.log(`- Parishes: ${parishData.length}`);
    console.log(`- Places: ${placeData.length - placesSkipped}`);

  } catch (e) {
    console.error('Error seeding database:', e);
    throw e;
  } finally {
    await prisma.$disconnect();
  }
}

seedDatabase();
