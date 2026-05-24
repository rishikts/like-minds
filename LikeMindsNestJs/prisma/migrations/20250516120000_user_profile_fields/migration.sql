-- Like Minds: extend User table with onboarding / profile fields (run via Prisma or Supabase SQL editor)

-- Make supabaseId optional (iOS may sync via externalAuthId first)
ALTER TABLE "User" ALTER COLUMN "supabaseId" DROP NOT NULL;

-- New profile columns
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "externalAuthId" VARCHAR(255);
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "fullName" VARCHAR(150);
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "occupationStatus" VARCHAR(100);
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "personalityTypes" TEXT[] DEFAULT ARRAY[]::TEXT[];
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "socialComfort" VARCHAR(50);
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "hobbiesNarrative" VARCHAR(300);
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "selectedInterestIds" TEXT[] DEFAULT ARRAY[]::TEXT[];
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "authProvider" VARCHAR(20);
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "meetupsAttended" INTEGER NOT NULL DEFAULT 0;
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "meetupsHosted" INTEGER NOT NULL DEFAULT 0;
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "badges" TEXT[] DEFAULT ARRAY[]::TEXT[];
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "favoriteCommunities" TEXT[] DEFAULT ARRAY[]::TEXT[];

-- Drop unique on phone if it blocks multiple empty profiles (optional)
ALTER TABLE "User" DROP CONSTRAINT IF EXISTS "User_phone_key";

-- Indexes & constraints
CREATE UNIQUE INDEX IF NOT EXISTS "User_externalAuthId_key" ON "User"("externalAuthId");
CREATE INDEX IF NOT EXISTS "User_externalAuthId_idx" ON "User"("externalAuthId");
CREATE INDEX IF NOT EXISTS "User_username_idx" ON "User"("username");
