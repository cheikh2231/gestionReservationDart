set search_path to public;

DROP FUNCTION IF EXISTS get_tables();
CREATE OR REPLACE FUNCTION get_tables()
    RETURNS SETOF table_info AS $$
BEGIN
RETURN QUERY
SELECT
    t.id,
    t.restaurant,
    t.table_number,
    t.capacity
    FROM tables t;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_tables() TO authenticated;


