import { PrismaClient, UserStatus } from '@prisma/client'
import bcrypt from 'bcrypt'

const prisma = new PrismaClient()

async function main() {
  const hashedPassword = await bcrypt.hash('123456', 10)

  // --- 1. Create ADMIN (Dean) ---
  console.log('Seeding Admin...')

  // Create Personne profile first
  const adminPersonne = await prisma.personne.upsert({
    where: { email: 'admin@faculty.com' },
    update: {},
    create: {
      nom: 'Admin',
      prenom: 'System',
      email: 'admin@faculty.com',
      tele: '0600000000',
      ville: 'Campus',
      adr: 'Administration Building'
    },
  })

  // Create User account linked to Personne
  await prisma.user.upsert({
    where: { email: 'admin@faculty.com' },
    update: { status: 'ACTIVE' }, // Ensure they are active if they exist
    create: {
      email: 'admin@faculty.com',
      password: hashedPassword,
      role: 'DEAN', // or 'ADMIN' depending on what your app checks
      status: 'ACTIVE', // <--- IMPORTANT: This approves the account
      personneId: adminPersonne.idp,
      name: 'Admin System'
    },
  })

  // Add to Personnels table
  await prisma.personnels.upsert({
    where: { idp: adminPersonne.idp },
    update: {},
    create: {
      idp: adminPersonne.idp,
      fonction: 'Dean',
      specialite: 'Administration'
    }
  })


  // --- 2. Create PROFESSOR ---
  console.log('Seeding Professor...')

  const profPersonne = await prisma.personne.upsert({
    where: { email: 'prof@faculty.com' },
    update: {},
    create: {
      nom: 'Professor',
      prenom: 'Demo',
      email: 'prof@faculty.com',
      tele: '0611111111',
      ville: 'Campus',
    },
  })

  await prisma.user.upsert({
    where: { email: 'prof@faculty.com' },
    update: { status: 'ACTIVE' },
    create: {
      email: 'prof@faculty.com',
      password: hashedPassword,
      role: 'PROFESSOR',
      status: 'ACTIVE', // Auto-approved
      personneId: profPersonne.idp,
      name: 'Professor Demo'
    },
  })

  await prisma.personnels.upsert({
    where: { idp: profPersonne.idp },
    update: {},
    create: {
      idp: profPersonne.idp,
      fonction: 'Professor',
      specialite: 'Computer Science'
    }
  })


  // --- 3. Create STUDENT ---
  console.log('Seeding Student...')

  const studentPersonne = await prisma.personne.upsert({
    where: { email: 'student@faculty.com' },
    update: {},
    create: {
      nom: 'Student',
      prenom: 'Demo',
      email: 'student@faculty.com',
      tele: '0622222222',
      ville: 'City',
      date_nai: new Date('2000-01-01')
    },
  })

  await prisma.user.upsert({
    where: { email: 'student@faculty.com' },
    update: { status: 'ACTIVE' },
    create: {
      email: 'student@faculty.com',
      password: hashedPassword,
      role: 'STUDENT',
      status: 'ACTIVE', // Auto-approved
      personneId: studentPersonne.idp,
      name: 'Student Demo'
    },
  })

  // Add to Etudiants table (using idp as primary key as per schema)
  await prisma.etudiants.upsert({
    where: { idp: studentPersonne.idp },
    update: {},
    create: {
      idp: studentPersonne.idp,
      cne: 'D123456789',
      niveau: 'L1',
      date_insc: new Date(),
      statut: 'Enrolled'
    }
  })

  console.log('Seeding finished.')
}

main()
  .then(async () => {
    await prisma.$disconnect()
  })
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  })