alter table public.registrations add column registration_source text;

-- The fixture's policy preserves the uncertainty about earlier registrations.
update public.registrations set registration_source = 'unknown' where registration_source is null;

alter table public.registrations alter column registration_source set not null;
