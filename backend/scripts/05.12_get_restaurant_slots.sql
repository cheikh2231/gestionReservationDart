DROP FUNCTION IF EXISTS get_slots(restaurant_id int, simulated_time timestamp, target_date date);
CREATE OR REPLACE FUNCTION get_slots(restaurant_id int, simulated_time timestamp, target_date date)
    RETURNS TABLE(slot_time time) AS $$
DECLARE
    slot_duration_val int;
BEGIN
    SELECT r.slot_duration INTO slot_duration_val
    FROM restaurants r
    WHERE r.id = restaurant_id;

    RETURN QUERY
        SELECT gs::time
        FROM services s,
             generate_series(
                     (target_date + s.start_time)::timestamp,
                     (target_date + s.end_time - (slot_duration_val || ' minutes')::interval)::timestamp,
                     (slot_duration_val || ' minutes')::interval
             ) gs
        WHERE s.restaurant = restaurant_id
          AND s.day_of_week = EXTRACT(ISODOW FROM target_date)::int
          AND (
            target_date > simulated_time::date
                OR gs::time > simulated_time::time
            )
        ORDER BY 1;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION get_slots(restaurant_id int, simulated_time timestamp, target_date date) TO authenticated;
