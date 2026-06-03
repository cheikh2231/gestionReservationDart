set search_path to public;

DROP FUNCTION IF EXISTS get_tables();
CREATE OR REPLACE FUNCTION get_tables()
    RETURNS SETOF table_info AS $$
BEGIN
RETURN QUERY
SELECT
    t.id,
    (res.id, res.name, res.address, res.city, res.phone, res.description, res.rating, res.price_range, res.slot_duration)::restaurant_info,
    t.table_number,
    t.capacity
    FROM tables t
    JOIN restaurants res ON res.id = t.restaurant;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_tables() TO authenticated;


