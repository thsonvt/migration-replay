-- Minimal EventOps schema for the registration workflow.
create table public.events (
    id uuid primary key,
    organization_id uuid not null,
    title text not null,
    unique (organization_id, id)
);

create table public.attendees (
    id uuid primary key,
    organization_id uuid not null,
    unique (organization_id, id)
);

create table public.registrations (
    id uuid primary key,
    organization_id uuid not null,
    event_id uuid not null,
    attendee_id uuid not null,
    status text not null default 'registered'
        check (status in ('registered', 'waitlisted', 'cancelled', 'checked_in')),
    registered_at timestamptz not null default now(),
    foreign key (organization_id, event_id) references public.events (organization_id, id),
    foreign key (organization_id, attendee_id) references public.attendees (organization_id, id),
    unique (event_id, attendee_id)
);
