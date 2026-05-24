import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database with initial data...');

  // Seed interests
  const interests = await Promise.all([
    prisma.interest.upsert({
      where: { slug: 'gaming' },
      update: {},
      create: {
        name: 'Gaming',
        slug: 'gaming',
        description: 'Video games, board games, and gaming communities',
        category: 'Entertainment',
      },
    }),
    prisma.interest.upsert({
      where: { slug: 'fitness' },
      update: {},
      create: {
        name: 'Fitness',
        slug: 'fitness',
        description: 'Fitness, sports, and wellness',
        category: 'Health',
      },
    }),
    prisma.interest.upsert({
      where: { slug: 'photography' },
      update: {},
      create: {
        name: 'Photography',
        slug: 'photography',
        description: 'Photography and visual arts',
        category: 'Arts',
      },
    }),
    prisma.interest.upsert({
      where: { slug: 'tech' },
      update: {},
      create: {
        name: 'Technology',
        slug: 'tech',
        description: 'Tech, coding, and software development',
        category: 'Tech',
      },
    }),
    prisma.interest.upsert({
      where: { slug: 'music' },
      update: {},
      create: {
        name: 'Music',
        slug: 'music',
        description: 'Music production, concerts, and performances',
        category: 'Entertainment',
      },
    }),
  ]);

  console.log(`✅ Seeded ${interests.length} interests`);
  console.log('🎉 Seeding completed successfully!');
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async e => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
