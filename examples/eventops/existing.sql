insert into public.events (id, organization_id, title)
values ('00000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000001', 'Community Build Night');

insert into public.attendees (id, organization_id)
values ('00000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000001');

insert into public.registrations (id, organization_id, event_id, attendee_id, status, registered_at)
values ('00000000-0000-0000-0000-000000000030', '00000000-0000-0000-0000-000000000001',
        '00000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000020',
        'checked_in', '2026-11-01 12:00:00+00');
