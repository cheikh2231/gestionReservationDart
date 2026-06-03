set search_path to public;

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