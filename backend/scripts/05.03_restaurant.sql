set search_path to public;
DROP TYPE IF EXISTS restaurants_info CASCADE;
DROP TYPE IF EXISTS reservation_info CASCADE;

CREATE TYPE reservation_info AS (
    id                  integer,
    client              integer,
    restaurant          integer,
    datetime            timestamp,
    number_of_guests    integer,
    status              status_type,
    special_requests    text
);

CREATE TYPE restaurants_info AS (
    id int,
    name varchar,
    address varchar,
    city varchar,
    phone varchar,
    description text,
    rating double precision,
    price_range int,
    slot_duration int,
    last_reservation reservation_info,
    nb_pending_reservation int
);
DROP FUNCTION IF EXISTS get_restaurants();
CREATE OR REPLACE FUNCTION get_restaurants()
    RETURNS SETOF restaurants_info AS $$
BEGIN
    RETURN QUERY
        SELECT r.id, r.name, r.address, r.city, r.phone,
               r.description, r.rating, r.price_range, r.slot_duration,
               (SELECT (resLast.id, resLast.client, resLast.restaurant,resLast.datetime,resLast.number_of_guests,resLast.status,resLast.special_requests)::reservation_info
                FROM reservations resLast
                WHERE resLast.restaurant = r.id
                ORDER BY resLast.datetime DESC LIMIT 1),
                (SELECT COUNT(*)::int
                 FROM reservations resPending
                 WHERE r.id = resPending.restaurant
                 AND resPending.status = 'pending')
        FROM restaurants r;
    END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


GRANT EXECUTE ON FUNCTION get_restaurants() TO authenticated;

