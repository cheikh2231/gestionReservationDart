-- Toutes les reservations du restaurant
DROP FUNCTION IF EXISTS get_all_reservations();
CREATE OR REPLACE FUNCTION get_all_reservations()
    RETURNS SETOF reservations AS $$
    BEGIN
        RETURN QUERY
            SELECT res.id
            FROM reservations res;
    END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_all_reservations() TO authenticated;



