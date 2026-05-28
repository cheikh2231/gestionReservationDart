set search_path to public;

CREATE OR REPLACE FUNCTION get_my_restaurants()
    RETURNS SETOF restaurants AS $$
        BEGIN
            RETURN QUERY
                SELECT r.* FROM restaurant_managers rm
                JOIN restaurants r ON r.id = rm.restaurant
                WHERE manager = auth.id();
        END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_my_restaurants() TO authenticated;

GRANT SELECT ON restaurants TO authenticated;
GRANT SELECT ON restaurant_managers TO authenticated;