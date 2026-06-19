drop function if exists public.check_restaurant_service_reservations(int, int, time, time);

create or replace function public.check_restaurant_service_reservations(
    p_service_id int,
    p_day_of_week int,
    p_start_time time,
    p_end_time time
)
    returns integer
    language plpgsql
    security definer
    set search_path = public, auth, pg_temp
as
$$
declare
    v_service services%rowtype;
    v_count integer;
    v_authorized boolean;
begin
    if p_service_id is null then
        raise exception 'service_id requis';
    end if;

    if p_end_time <= p_start_time then
        raise exception 'L''heure de fin doit être après l''heure de début';
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

    select count(*)
    into v_count
    from reservations r
    where r.restaurant = v_service.restaurant
      and r.status in ('pending', 'confirmed')
      and extract(isodow from r.datetime) = v_service.day_of_week
      and r.datetime::time >= v_service.start_time
      and r.datetime::time < v_service.end_time
      and (
        extract(isodow from r.datetime) <> p_day_of_week
            or r.datetime::time < p_start_time
            or r.datetime::time >= p_end_time
        );

    return v_count;
end;
$$;

grant execute on function public.check_restaurant_service_reservations(int, int, time, time) to authenticated;