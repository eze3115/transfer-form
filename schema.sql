-- PostgreSQL schema for transfer form workflow

create table if not exists requests (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  status text not null default 'pending',
  data jsonb not null, -- the form payload (employee + schedule + answers)
  final_pdf_url text,
  requester_email text not null
);

create table if not exists signers (
  id uuid primary key default gen_random_uuid(),
  request_id uuid references requests(id) on delete cascade,
  role text not null,            -- 'employee' | 'current_supervisor' | 'current_pd' | 'new_supervisor' | 'new_pd'
  name text,
  email text,
  order_index int not null,      -- 0..4 in sequence
  token text unique not null,    -- magic link token
  signed_at timestamptz,
  decision text,                 -- 'YES' | 'NO' | null
  decision_reason text,
  agreed_last_date text,
  staffing_reviewed boolean,
  signature_data_url text        -- PNG data URL of signature
);

create index if not exists signers_request_idx on signers(request_id);

-- trigger to update updated_at
create or replace function set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end; $$ language plpgsql;

drop trigger if exists trg_requests_updated on requests;
create trigger trg_requests_updated before update on requests
for each row execute procedure set_updated_at();
