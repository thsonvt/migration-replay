do $$
begin
    if not exists (
        select from public.registrations
        where id = '00000000-0000-0000-0000-000000000030'
          and organization_id = '00000000-0000-0000-0000-000000000001'
          and event_id = '00000000-0000-0000-0000-000000000010'
          and attendee_id = '00000000-0000-0000-0000-000000000020'
          and status = 'checked_in' and registered_at = '2026-11-01 12:00:00+00'
          and registration_source = 'unknown'
    ) then
        raise exception 'Expected the original checked-in registration with its original details and source unknown';
    end if;
end $$;
