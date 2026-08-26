-- Matchday Vault V14 Supabase schema
create table if not exists public.vault_snapshots (
  user_id uuid primary key references auth.users(id) on delete cascade,
  state jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.vault_snapshots enable row level security;
create policy "own snapshot select" on public.vault_snapshots for select using (auth.uid()=user_id);
create policy "own snapshot insert" on public.vault_snapshots for insert with check (auth.uid()=user_id);
create policy "own snapshot update" on public.vault_snapshots for update using (auth.uid()=user_id) with check (auth.uid()=user_id);

create table if not exists public.inbox_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  external_id text,
  event_type text not null default 'other',
  club_id text,
  sender text,
  subject text,
  body text,
  event_date timestamptz,
  membership_id text,
  fixture_id text,
  ticket_id text,
  confidence numeric not null default 0,
  needs_review boolean not null default true,
  review_reason text,
  extracted jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  unique(user_id, external_id)
);
alter table public.inbox_events enable row level security;
create policy "own inbox select" on public.inbox_events for select using (auth.uid()=user_id);
create policy "own inbox insert" on public.inbox_events for insert with check (auth.uid()=user_id);
create policy "own inbox update" on public.inbox_events for update using (auth.uid()=user_id) with check (auth.uid()=user_id);

create table if not exists public.gmail_tokens (
  user_id uuid primary key references auth.users(id) on delete cascade,
  refresh_token text not null,
  gmail_address text,
  updated_at timestamptz not null default now()
);
alter table public.gmail_tokens enable row level security;
-- Deliberately no client-side read policy: refresh tokens are for server-side Edge Functions only.
