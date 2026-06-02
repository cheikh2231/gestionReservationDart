DROP TYPE IF EXISTS table_restaurant_info CASCADE;
DROP TYPE IF EXISTS table_info CASCADE;

CREATE TYPE table_restaurant_info AS (
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


CREATE TYPE table_info AS (
    id              integer,
    restaurant      table_restaurant_info,
    table_number    integer,
    capacity        integer
    );


DROP FUNCTION IF EXISTS get_tables();
CREATE OR REPLACE FUNCTION get_tables()
    RETURNS SETOF table_info AS $$
BEGIN
RETURN QUERY
SELECT
    t.id,
    (res.id, res.name, res.address, res.city, res.phone, res.description,
     res.rating, res.price_range, res.slot_duration)::table_restaurant_info,
    t.table_number,
    t.capacity
    FROM tables t
         JOIN restaurants res ON res.id = t.restaurant;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_tables() TO authenticated;


