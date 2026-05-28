set search_path to public;

CREATE TYPE restaurant_with_last_reservation AS (
    id int,
    name varchar,
    address varchar,
    city varchar,
    phone varchar,
    description text,
    rating double precision,
    price_range int,
    slot_duration int,
    last_reservation timestamp,
    nb_pending_reservation int
);

CREATE OR REPLACE FUNCTION get_my_restaurants_with_last_reservation()
    RETURNS SETOF restaurant_with_last_reservation AS $$
BEGIN
    RETURN QUERY
        SELECT r.id, r.name, r.address, r.city, r.phone,
               r.description, r.rating, r.price_range, r.slot_duration,
               MAX(resLast.datetime) as last_reservation,
               COUNT(resPending.id)::int as nb_pending_reservation
        FROM restaurant_managers rm
                 JOIN restaurants r ON r.id = rm.restaurant
                 LEFT JOIN reservations resLast ON resLast.restaurant = r.id
                 LEFT JOIN reservations resPending ON resPending.restaurant = r.id AND resPending.status = 'pending'
        WHERE manager = auth.id()
        GROUP BY r.id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_my_restaurants_with_last_reservation() TO authenticated;

GRANT SELECT ON restaurants TO authenticated;
GRANT SELECT ON restaurant_managers TO authenticated;