set search_path to public, auth;

DROP FUNCTION IF EXISTS public.get_reservations();

create or replace function get_reservations()
returns table (
  id              int,
  client          int,
  restaurant      int,
  datetime        timestamp,
  number_of_guests int,
  status          text,
  special_requests text,

  restaurant_name    varchar,
  restaurant_address varchar,
  restaurant_city    varchar,
  restaurant_phone   varchar
) as $$
select
    r.id,
    r.client,
    r.restaurant,
    r.datetime,
    r.number_of_guests,
    r.status,
    r.special_requests,
    res.name,
    res.address,
    res.city,
    res.phone
from reservations r
         join restaurants res on res.id = r.restaurant
where r.client = auth.id()
    $$ language sql security definer;

GRANT EXECUTE ON FUNCTION public.get_reservations() TO authenticated;