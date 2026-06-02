DROP TYPE IF EXISTS restaurant_info CASCADE;
DROP TYPE IF EXISTS table_info CASCADE;


CREATE TYPE restaurant_info AS (
    id          integer,
    name        text,
    address     text,
    city        text,
    phone       text
    );


CREATE TYPE table_info AS (
    id              integer,
    restaurant      restaurant_info,
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
    (res.id, res.name, res.address, res.city, res.phone)::restaurant_info,
    t.table_number,
    t.capacity
FROM tables t
         JOIN restaurants res ON res.id = t.restaurant;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_tables() TO authenticated;


