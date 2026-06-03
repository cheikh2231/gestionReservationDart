DROP TYPE IF EXISTS reservations_info CASCADE ;
DROP TYPE IF EXISTS reservation_table_info CASCADE;
DROP TYPE IF EXISTS reservation_restaurant_info CASCADE;
DROP TYPE IF EXISTS reservation_user_info CASCADE;

CREATE TYPE reservation_user_info AS (
    id          integer,
    full_name   text,
    email       text,
    phone       text
);

CREATE TYPE reservation_restaurant_info AS (
    id          integer,
    name        text,
    address     text,
    city        text,
    phone       text,
    description text,
    rating      double precision,
    price_range  int,
    slot_duration int
);

CREATE TYPE reservation_table_info AS (
    id              integer,
    restaurant      integer,
    table_number    integer,
    capacity        integer
);

CREATE TYPE reservations_info AS (
    id                  integer,
    client              reservation_user_info,
    restaurant          reservation_restaurant_info,
    datetime            timestamp,
    number_of_guests    integer,
    status              status_type,
    special_requests    text,
    tables              reservation_table_info[]
);

DROP FUNCTION IF EXISTS get_reservations();
CREATE OR REPLACE FUNCTION get_reservations()
    RETURNS SETOF reservations_info AS $$
BEGIN
    RETURN QUERY
        SELECT
            r.id,
            (c.id, c.full_name, c.email, c.phone)::reservation_user_info,
            (res.id, res.name, res.address, res.city, res.phone, res.description, res.rating, res.price_range, res.slot_duration)::reservation_restaurant_info,
            r.datetime,
            r.number_of_guests,
            r.status,
            r.special_requests,
            ARRAY(
                    SELECT (t.id, t.restaurant, t.table_number, t.capacity)::reservation_table_info
                    FROM reservation_tables rt
                             JOIN tables t ON t.id = rt.table
                    WHERE rt.reservation = r.id
            )
        FROM reservations r
                 JOIN users c ON c.id = r.client
                 JOIN restaurants res ON res.id = r.restaurant;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_reservations() TO authenticated;


