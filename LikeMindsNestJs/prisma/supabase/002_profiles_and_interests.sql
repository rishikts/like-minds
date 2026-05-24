-- =============================================================================
-- Like Minds — Supabase initial setup
-- Project: yghswgwuzpbvoqpmtyau
-- Run this entire file in: Supabase Dashboard -> SQL Editor -> New query
-- Idempotent: safe to re-run.
--
-- What this creates:
--   1. public.profiles            (1:1 with auth.users)
--   2. public.interests           (catalog for onboarding chips)
--   3. set_updated_at() trigger fn
--   4. handle_new_auth_user() trigger fn  (auto-creates a profile on signup)
--   5. RLS policies on both tables
--   6. Seed interests
-- =============================================================================

-- ----- Extensions -----------------------------------------------------------
create extension if not exists "pgcrypto";

-- ----- Shared trigger: keep updated_at honest --------------------------------
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- =============================================================================
-- 1. profiles
-- =============================================================================
create table if not exists public.profiles (
  id                     uuid primary key references auth.users(id) on delete cascade,

  email                  text not null,
  username               text unique,
  full_name              text,
  phone                  text,
  profile_image_url      text,
  bio                    varchar(500),

  date_of_birth          date,
  gender                 text,
  city                   text,
  occupation_status      text,

  personality_types      text[] not null default '{}',
  social_comfort         text check (social_comfort in ('introvert','balanced','extrovert')),
  hobbies_narrative      varchar(300),
  selected_interest_ids  uuid[] not null default '{}',

  auth_provider          text check (auth_provider in ('apple','google','guest','email')),
  meetups_attended       integer not null default 0,
  meetups_hosted         integer not null default 0,
  badges                 text[] not null default '{}',
  favorite_communities   uuid[] not null default '{}',

  is_verified            boolean not null default false,
  is_onboarded           boolean not null default false,
  status                 text not null default 'active'
                          check (status in ('active','inactive','banned','suspended')),
  role                   text not null default 'user'
                          check (role in ('admin','moderator','user')),

  last_login_at          timestamptz,
  last_activity_at       timestamptz,
  created_at             timestamptz not null default now(),
  updated_at             timestamptz not null default now()
);

create index if not exists profiles_username_idx
  on public.profiles (username);
create index if not exists profiles_is_onboarded_idx
  on public.profiles (is_onboarded);
create index if not exists profiles_created_at_idx
  on public.profiles (created_at desc);
create index if not exists profiles_selected_interests_gin
  on public.profiles using gin (selected_interest_ids);
create index if not exists profiles_personality_types_gin
  on public.profiles using gin (personality_types);

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- Auto-provision a profile row whenever a new auth.users row is created.
-- security definer + locked search_path is the Supabase-recommended pattern.
create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name, auth_provider)
  values (
    new.id,
    coalesce(new.email, ''),
    coalesce(
      new.raw_user_meta_data ->> 'full_name',
      new.raw_user_meta_data ->> 'name'
    ),
    coalesce(new.raw_app_meta_data ->> 'provider', 'email')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_auth_user();

-- RLS
alter table public.profiles enable row level security;

drop policy if exists "profiles readable by authenticated" on public.profiles;
create policy "profiles readable by authenticated"
  on public.profiles for select
  to authenticated
  using (true);

drop policy if exists "users can update own profile" on public.profiles;
create policy "users can update own profile"
  on public.profiles for update
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Inserts happen via the on_auth_user_created trigger (runs as definer, bypasses RLS).
-- The NestJS backend uses service_role, which also bypasses RLS.
-- Anon/authenticated clients should NOT insert directly, so no insert policy.

-- =============================================================================
-- 2. interests (catalog)
-- =============================================================================
create table if not exists public.interests (
  id           uuid primary key default gen_random_uuid(),
  slug         text not null unique,
  name         text not null,
  category     text,
  icon         text,
  description  text,
  is_active    boolean not null default true,
  sort_order   integer not null default 0,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create index if not exists interests_category_active_idx
  on public.interests (category) where is_active;
create index if not exists interests_sort_order_active_idx
  on public.interests (sort_order) where is_active;

drop trigger if exists interests_set_updated_at on public.interests;
create trigger interests_set_updated_at
  before update on public.interests
  for each row execute function public.set_updated_at();

alter table public.interests enable row level security;

drop policy if exists "interests readable by everyone" on public.interests;
create policy "interests readable by everyone"
  on public.interests for select
  to anon, authenticated
  using (is_active);

-- Writes are admin-only; do them with service_role from the backend.

-- ----- Seed a starter catalog -----------------------------------------------
insert into public.interests (slug, name, category, icon, sort_order) values
  ('trekking',    'Trekking',    'outdoors', 'figure.hiking',     10),
  ('cricket',     'Cricket',     'sports',   'sportscourt.fill',  20),
  ('football',    'Football',    'sports',   'soccerball',        30),
  ('reading',     'Reading',     'arts',     'book.fill',         40),
  ('photography', 'Photography', 'arts',     'camera.fill',       50),
  ('music',       'Music',       'arts',     'music.note',        60),
  ('coffee',      'Coffee',      'food',     'cup.and.saucer.fill', 70),
  ('cooking',     'Cooking',     'food',     'fork.knife',        80),
  ('startups',    'Startups',    'tech',     'lightbulb.fill',    90),
  ('gaming',      'Gaming',      'tech',     'gamecontroller.fill', 100),
  ('yoga',        'Yoga',        'wellness', 'figure.mind.and.body', 110),
  ('travel',      'Travel',      'outdoors', 'airplane',          120)
on conflict (slug) do nothing;

-- =============================================================================
-- Done. Verify in Dashboard -> Table Editor that "profiles" and "interests"
-- are listed under the public schema with the lock icon (RLS enabled).
-- =============================================================================
