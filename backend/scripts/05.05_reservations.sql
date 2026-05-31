CREATE TYPE user_info AS (
    id          integer,
    full_name   text,
    email       text,
    phone       text
);

CREATE TYPE restaurant_info AS (
    id          integer,
    name        text,
    address     text,
    city        text,
    phone       text
);


CREATE TYPE table_info AS (
    id              integer,
    restaurant      integer,
    table_number    integer,
    capacity        integer
);

CREATE TYPE reservation_info AS (
    id                  integer,
    client              user_info,
    restaurant          restaurant_info,
    datetime            timestamp,
    number_of_guests    integer,
    status              text,
    special_requests    text,
    tables              table_info[]
);

DROP FUNCTION IF EXISTS get_reservations();
CREATE OR REPLACE FUNCTION get_reservations()
    RETURNS reservation_info AS $$
DECLARE
    result reservation_info;
BEGIN
        SELECT (
                r.id,
                (c.id,c.full_name,c.email,c.phone)::user_info,
                (res.id,res.name,res.address,res.city,res.phone)::restaurant_info,
                r.datetime,r.number_of_guests,r.status,r.special_requests,
                ARRAY(
                        SELECT (t.id, t.restaurant, t.table_number, t.capacity)::table_info
                        FROM reservation_tables rt
                        JOIN tables t ON t.id = rt.table
                        WHERE rt.reservation = r.id
                ))::reservation_info INTO result
                FROM reservations r
                JOIN users c ON c.id = r.client
                JOIN restaurants res ON res.id = r.restaurant;
        RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;