-- =============================================================================
-- DEPRECATED — kept for reference.
-- Use 002_profiles_and_interests.sql instead for new Supabase projects.
-- This file uses the old PascalCase "User" shape (Prisma-driven, no auth.users
-- linkage). Do NOT run alongside 002_*.sql; pick one.
-- =============================================================================
-- Like Minds — Supabase PostgreSQL: single `User` profile table
-- Run in Supabase Dashboard → SQL Editor (or use Prisma migrate against DATABASE_URL)
-- =============================================================================

CREATE TABLE IF NOT EXISTS "User" (
  "id"                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  "supabaseId"          VARCHAR(255) UNIQUE,
  "externalAuthId"      VARCHAR(255) UNIQUE,
  "email"               VARCHAR(255) NOT NULL UNIQUE,
  "firstName"           VARCHAR(100),
  "lastName"            VARCHAR(100),
  "fullName"            VARCHAR(150),
  "username"            VARCHAR(100) UNIQUE,
  "profileImageUrl"     TEXT,
  "bio"                 VARCHAR(500),
  "dateOfBirth"         DATE,
  "gender"              VARCHAR(50),
  "phone"               VARCHAR(20),
  "location"            VARCHAR(255),
  "occupationStatus"    VARCHAR(100),
  "personalityTypes"    TEXT[] NOT NULL DEFAULT '{}',
  "socialComfort"       VARCHAR(50),
  "hobbiesNarrative"    VARCHAR(300),
  "selectedInterestIds" TEXT[] NOT NULL DEFAULT '{}',
  "authProvider"        VARCHAR(20),
  "meetupsAttended"     INTEGER NOT NULL DEFAULT 0,
  "meetupsHosted"       INTEGER NOT NULL DEFAULT 0,
  "badges"              TEXT[] NOT NULL DEFAULT '{}',
  "favoriteCommunities" TEXT[] NOT NULL DEFAULT '{}',
  "isVerified"          BOOLEAN NOT NULL DEFAULT false,
  "isOnboarded"         BOOLEAN NOT NULL DEFAULT false,
  "role"                TEXT NOT NULL DEFAULT 'USER',
  "status"              TEXT NOT NULL DEFAULT 'ACTIVE',
  "lastLoginAt"         TIMESTAMPTZ,
  "lastActivityAt"      TIMESTAMPTZ,
  "createdAt"           TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updatedAt"           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS "User_email_idx" ON "User"("email");
CREATE INDEX IF NOT EXISTS "User_supabaseId_idx" ON "User"("supabaseId");
CREATE INDEX IF NOT EXISTS "User_externalAuthId_idx" ON "User"("externalAuthId");

-- Row Level Security (optional — enable when using Supabase client directly from iOS)
-- ALTER TABLE "User" ENABLE ROW LEVEL SECURITY;
-- CREATE POLICY "users_read_own" ON "User" FOR SELECT USING (auth.uid()::text = "supabaseId");
