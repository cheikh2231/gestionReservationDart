set search_path to public;

DROP TYPE IF EXISTS service_info CASCADE;

CREATE TYPE service_info AS (
    id int,
    restaurant int,
    day_of_week int,
    start_time time,
    end_time time
);

DROP FUNCTION IF EXISTS get_services(int);

CREATE OR REPLACE FUNCTION get_services(restaurant_id int)
    RETURNS SETOF service_info AS $$
BEGIN
    RETURN QUERY
        SELECT id ,restaurant,day_of_week,start_time,end_time
        from services
        where restaurant = restaurant_id
        ORDER BY day_of_week ASC, start_time ASC;

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_services(int) TO authenticated;