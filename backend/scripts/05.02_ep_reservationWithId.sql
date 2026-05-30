set search_path to public, auth;

DROP FUNCTION IF EXISTS public.get_reservation(int);

CREATE OR REPLACE FUNCTION public.get_reservation(idRes int)
    RETURNS TABLE (
                      id int,
                      restaurant_name text,
                      restaurant_address text,
                      restaurant_phone text,
                      date_time timestamp,
                      nb_guests int,
                      status text,
                      special_requests text
                  ) AS $$
BEGIN
RETURN QUERY
SELECT
    r.id,
    res.name::text as restaurant_name,
    res.address::text as restaurant_address,
    res.phone::text as restaurant_phone,
    r.datetime as date_time,
    r.number_of_guests as nb_guests,
    r.status::text,
    r.special_requests::text
FROM public.reservations r
         JOIN public.restaurants res ON r.restaurant = res.id

WHERE r.client = (current_setting('request.jwt.claims', true)::json ->> 'user_id')::int
and r.id = idRes
ORDER BY r.datetime DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.get_reservation(int) TO authenticated;