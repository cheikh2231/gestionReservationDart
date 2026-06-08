set search_path to public;

DROP FUNCTION IF EXISTS get_services(int);

CREATE OR REPLACE FUNCTION get_services(restaurant_id int)
    RETURNS SETOF service_info AS $$
BEGIN
    RETURN QUERY
        SELECT DISTINCT ON (s.day_of_week, s.start_time, s.id)
            s.id,
            s.restaurant,
            s.day_of_week,
            s.start_time,
            s.end_time,
            -- Si le compte des réservations est supérieur à 0 -> true
            (COUNT(r.id) > 0) AS used_by_reservation,
            -- Min et Max classiques grâce au GROUP BY
            MIN(r.datetime::time) AS min_reservation_start_time,
            MAX(r.datetime::time) AS max_reservation_start_time
        FROM services s
            LEFT JOIN reservations r ON s.restaurant = r.restaurant
            AND s.day_of_week = EXTRACT(ISODOW FROM r.datetime)
            AND r.datetime::time >= s.start_time
            AND r.datetime::time < s.end_time
        WHERE s.restaurant = restaurant_id
        GROUP BY s.id, s.restaurant, s.day_of_week, s.start_time, s.end_time
        ORDER BY s.day_of_week ASC, s.start_time ASC, s.id ASC;

--     RETURN QUERY
--         SELECT id ,restaurant,day_of_week,start_time,end_time
--         from services
--         where restaurant = restaurant_id
--         ORDER BY day_of_week ASC, start_time ASC;
--
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_services(int) TO authenticated;

