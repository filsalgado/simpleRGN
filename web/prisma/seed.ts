import { PrismaClient } from '@prisma/client'
import { hash } from 'bcryptjs'
import * as fs from 'fs'
import * as path from 'path'
import * as csv from 'csv-parse/sync'

const prisma = new PrismaClient()

function parseCsvFile(filePath: string) {
  let content = fs.readFileSync(filePath, 'utf-8')
  // Remove BOM if present
  if (content.charCodeAt(0) === 0xfeff) {
    content = content.slice(1)
  }
  return csv.parse(content, {
    columns: true,
    skip_empty_lines: true,
    delimiter: ';',
  })
}

async function main() {
  // Try to load from aux_data CSVs
  // Try multiple paths: docker mount first, then local
  let auxDataPath = '/aux_data'
  
  if (!fs.existsSync(auxDataPath)) {
    auxDataPath = path.join(__dirname, '..', '..', 'aux_data')
  }
  
  if (!fs.existsSync(auxDataPath)) {
    auxDataPath = path.join(__dirname, '..', '..', '..', 'aux_data')
  }
  
  console.log(`Using aux_data from: ${auxDataPath}`)
  
  // 1. Seed Parishes
  let parishes: any[] = []

  const parishCsvPath = path.join(auxDataPath, 'Parish.csv')
  if (fs.existsSync(parishCsvPath)) {
    console.log(`Loading Parishes from CSV... (${parishCsvPath})`)
    const csvData = parseCsvFile(parishCsvPath)
    console.log(`CSV loaded with ${csvData.length} rows`)
    console.log(`First row:`, csvData[0])
    parishes = csvData.map((row: any, idx: number) => {
      const id = parseInt(row.id?.toString().trim() || '0')
      const name = (row.name || '')?.trim()
      // Extract municipality and district from name if in format "Name - Municipality - District"
      const parts = name.split(' - ')
      if (idx === 0) {
        console.log(`Parsed first parish: id=${id}, name=${name}`)
      }
      return {
        id,
        name: parts[0]?.trim() || name,
        municipality: parts[1]?.trim() || (row.municipality || '').trim() || null,
        district: parts[2]?.trim() || null,
      }
    })
  } else {
    // Fallback to hardcoded if no CSV
    parishes = [
      { id: 10101, name: 'Agadão', municipality: 'Águeda', district: 'Aveiro' },
      { id: 10102, name: 'Aguada de Baixo', municipality: 'Águeda', district: 'Aveiro' },
      { id: 10103, name: 'Aguada de Cima', municipality: 'Águeda', district: 'Aveiro' },
      { id: 10104, name: 'Águeda', municipality: 'Águeda', district: 'Aveiro' },
      { id: 10105, name: 'Barrô', municipality: 'Águeda', district: 'Aveiro' },
      { id: 10106, name: 'Belazaima do Chão', municipality: 'Águeda', district: 'Aveiro' },
      { id: 10107, name: 'Castanheira do Vouga', municipality: 'Águeda', district: 'Aveiro' },
      { id: 10108, name: 'Espinhel', municipality: 'Águeda', district: 'Aveiro' },
      { id: 10109, name: 'Fermentelos', municipality: 'Águeda', district: 'Aveiro' },
      { id: 10110, name: 'Lamas do Vouga', municipality: 'Águeda', district: 'Aveiro' },
    ]
  }

  console.log('Seeding Parishes...')
  let parishCount = 0
  let parishErrors = 0
  for (const parish of parishes) {
    try {
      await prisma.parish.upsert({
        where: { id: parish.id },
        update: {},
        create: parish,
      })
      parishCount++
      if (parishCount % 500 === 0) console.log(`  Seeded ${parishCount} parishes...`)
    } catch (e: any) {
      parishErrors++
      if (parishErrors <= 5) {
        console.error(`Error seeding parish ${parish.id}: ${e.message}`)
      }
    }
  }
  console.log(`Seeded ${parishCount} parishes (${parishErrors} errors)`)

  // 2. Seed Places
  let places: any[] = []

  const placeCsvPath = path.join(auxDataPath, 'Place.csv')
  if (fs.existsSync(placeCsvPath)) {
    console.log('Loading Places from CSV...')
    const csvData = parseCsvFile(placeCsvPath)
    places = csvData.map((row: any) => ({
      id: parseInt(row.id?.toString().trim() || '0'),
      parishId: parseInt(row.parishId?.toString().trim() || '0'),
      name: row.name?.trim() || '',
    }))
  } else {
    places = [
      { id: 1, parishId: 40911, name: 'Lousa' },
      { id: 2, parishId: 91317, name: 'Trancoso' },
      { id: 3, parishId: 40111, name: 'Sambade' },
    ]
  }

  console.log('Seeding Places...')
  let placesSkipped = 0
  let placesCount = 0
  for (const place of places) {
    try {
      await prisma.place.upsert({
        where: { id: place.id },
        update: {},
        create: place,
      })
      placesCount++
    } catch (e: any) {
      // Skip places with invalid parishId
      if (e.code === 'P2003') {
        placesSkipped++
      } else {
        console.error(`Error seeding place ${place.id}:`, e.message)
        throw e
      }
    }
  }
  console.log(`Seeded ${placesCount} places. Skipped ${placesSkipped} places with invalid parishId`)

  // 3. Seed Titles
  let titles: any[] = []

  const titleCsvPath = path.join(auxDataPath, 'Title.csv')
  if (fs.existsSync(titleCsvPath)) {
    console.log('Loading Titles from CSV...')
    const csvData = parseCsvFile(titleCsvPath)
    titles = csvData.map((row: any) => ({
      id: parseInt(row.id?.toString().trim() || '0'),
      name: row.name?.trim() || '',
      isOriginal: row.isOriginal === 'true' || row.isOriginal === true,
    }))
  } else {
    titles = [
      { id: 1, name: 'Frei' },
      { id: 2, name: 'Ilustríssimo' },
    ]
  }

  console.log('Seeding Titles...')
  let titleCount = 0
  for (const title of titles) {
    try {
      await prisma.title.upsert({
        where: { id: title.id },
        update: { name: title.name },
        create: title,
      })
      titleCount++
    } catch (e) {
      // Skip duplicates
      console.log(`Skipping duplicate title: ${title.name}`)
    }
  }
  console.log(`Seeded ${titleCount} titles`)

  // 4. Seed Professions
  let professions: any[] = []

  const professionCsvPath = path.join(auxDataPath, 'Profession.csv')
  if (fs.existsSync(professionCsvPath)) {
    console.log('Loading Professions from CSV...')
    const csvData = parseCsvFile(professionCsvPath)
    professions = csvData.map((row: any) => ({
      id: parseInt(row.id?.toString().trim() || '0'),
      name: row.name?.trim() || '',
      isOriginal: row.isOriginal === 'true' || row.isOriginal === true,
    }))
  } else {
    professions = [
      { id: 1, name: 'Ator' },
      { id: 3, name: 'Advogado (a)' },
    ]
  }

  console.log('Seeding Professions...')
  let profCount = 0
  for (const prof of professions) {
    try {
      await prisma.profession.upsert({
        where: { id: prof.id },
        update: { name: prof.name },
        create: prof,
      })
      profCount++
    } catch (e) {
      // Skip duplicates
      console.log(`Skipping duplicate profession: ${prof.name}`)
    }
  }
  console.log(`Seeded ${profCount} professions`)

  // 5. Seed Kinships
  let kinships: any[] = []

  const kinshipCsvPath = path.join(auxDataPath, 'Kinship.csv')
  if (fs.existsSync(kinshipCsvPath)) {
    console.log('Loading Kinships from CSV...')
    const csvData = parseCsvFile(kinshipCsvPath)
    kinships = csvData.map((row: any) => ({
      id: parseInt(row.id?.toString().trim() || '0'),
      name: row.name?.trim() || '',
      isOriginal: row.isOriginal === 'true' || row.isOriginal === true,
    }))
  } else {
    kinships = [
      { id: 1, name: 'Filho' },
      { id: 2, name: 'Filha' },
    ]
  }

  console.log('Seeding Kinships...')
  let kinshipCount = 0
  for (const kinship of kinships) {
    try {
      await prisma.kinship.upsert({
        where: { id: kinship.id },
        update: { name: kinship.name },
        create: kinship,
      })
      kinshipCount++
    } catch (e) {
      // Skip duplicates
      console.log(`Skipping duplicate kinship: ${kinship.name}`)
    }
  }
  console.log(`Seeded ${kinshipCount} kinships`)

  // 6. Seed ParticipationRoles
  let participationRoles: any[] = []

  const roleCsvPath = path.join(auxDataPath, 'ParticipationRole.csv')
  if (fs.existsSync(roleCsvPath)) {
    console.log('Loading ParticipationRoles from CSV...')
    const csvData = parseCsvFile(roleCsvPath)
    participationRoles = csvData.map((row: any) => ({
      id: parseInt(row.id?.toString().trim() || '0'),
      name: row.name?.trim() || '',
      isOriginal: row.isOriginal === 'true' || row.isOriginal === true,
    }))
  } else {
    participationRoles = [
      { id: 1, name: 'Testemunha' },
      { id: 2, name: 'Padrinho' },
    ]
  }

  console.log('Seeding ParticipationRoles...')
  let roleCount = 0
  for (const role of participationRoles) {
    try {
      await prisma.participationRole.upsert({
        where: { id: role.id },
        update: { name: role.name },
        create: role,
      })
      roleCount++
    } catch (e) {
      // Skip duplicates
      console.log(`Skipping duplicate role: ${role.name}`)
    }
  }
  console.log(`Seeded ${roleCount} participation roles`)

  // 7. Seed User
  const password = await hash('admin', 12)
  const user = await prisma.user.upsert({
    where: { email: 'admin@simplergn.com' },
    update: {},
    create: {
      email: 'admin@simplergn.com',
      name: 'Admin',
      password,
    }
  })
  console.log('User Seeded:', user.email)
}

main()
  .then(async () => {
    console.log('Seed completed successfully')
    await prisma.$disconnect()
    process.exit(0)
  })
  .catch(async (e) => {
    console.error('Seed failed:', e)
    await prisma.$disconnect()
    process.exit(1)
  })

