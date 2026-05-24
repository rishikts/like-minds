import { PrismaClient } from '@prisma/client';

const p = new PrismaClient();

(async () => {
  const interests = await p.interests.findMany({ orderBy: { sort_order: 'asc' } });
  const profileCount = await p.profiles.count();
  console.log(`profiles row count: ${profileCount}`);
  console.log(`interests row count: ${interests.length}`);
  console.log(
    `first 3 interests: ${interests.slice(0, 3).map((i) => `${i.slug}/${i.name}`).join(', ')}`,
  );
  await p.$disconnect();
})().catch((e) => {
  console.error('FAILED:', e.message);
  process.exit(1);
});
