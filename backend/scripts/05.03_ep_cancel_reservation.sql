set search_path to public, auth;

DROP FUNCTION IF EXISTS public.cancel_reservation(int);

create or replace function cancel_reservation(id_res int)
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
UPDATE reservations SET status = 'cancelled' WHERE id = id_res;
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
where r.id = id_res and r.client = auth.id()
$$ language sql security definer;

GRANT EXECUTE ON FUNCTION public.cancel_reservation(int) TO authenticated;