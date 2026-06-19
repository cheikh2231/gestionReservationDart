set search_path to public, auth;

drop function if exists public.update_service(int, int, time, time);

create or replace function public.update_service(
    p_service_id int,
    p_day_of_week int,
    p_start_time time,
    p_end_time time
)
returns services
language plpgsql
security definer
set search_path = public, auth, pg_temp
as
$$
declare
v_service services%rowtype;
    v_authorized boolean;
begin
    if p_service_id is null then
        raise exception 'service_id requis pour la modification';
end if;

select *
into v_service
from services
where id = p_service_id;

if not found then
        raise exception 'Service introuvable';
end if;

select exists(
    select 1
    from restaurant_managers rm
    where rm.restaurant = v_service.restaurant
      and rm.manager = auth.id()
)
into v_authorized;

if not v_authorized then
        raise exception 'Action non autorisée';
end if;

update services
set day_of_week = p_day_of_week,
    start_time = p_start_time,
    end_time = p_end_time
where id = p_service_id
    returning *
into v_service;

return v_service;
end;
$$;

grant execute on function public.update_service(int, int, time, time) to authenticated;

