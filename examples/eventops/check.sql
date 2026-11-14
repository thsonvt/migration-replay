do $$
begin
    if not exists (
        select from information_schema.columns
        where table_schema = 'public' and table_name = 'registrations'
          and column_name = 'registration_source' and data_type = 'text' and is_nullable = 'NO'
    ) then
        raise exception 'Expected registrations.registration_source to be required text';
    end if;
end $$;

insert into public.events (id, organization_id, title)
values ('00000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000001', 'Workshop');
insert into public.attendees (id, organization_id)
values ('00000000-0000-0000-0000-000000000021', '00000000-0000-0000-0000-000000000001');
insert into public.registrations (id, organization_id, event_id, attendee_id, registration_source)
values ('00000000-0000-0000-0000-000000000031', '00000000-0000-0000-0000-000000000001',
        '00000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000021', 'web');
