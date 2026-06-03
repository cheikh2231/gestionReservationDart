DROP FUNCTION IF EXISTS get_reservations();
CREATE OR REPLACE FUNCTION get_reservations()
    RETURNS SETOF reservation_info AS $$
BEGIN
    RETURN QUERY
        SELECT
            r.id,
            (c.id, c.full_name, c.email, c.phone , c.role)::user_info,
            (res.id, res.name, res.address, res.city, res.phone, res.description, res.rating, res.price_range, res.slot_duration)::restaurant_info,
            r.datetime,
            r.number_of_guests,
            r.status,
            r.special_requests,
            ARRAY(
                    SELECT (t.id, t.restaurant, t.table_number, t.capacity)::table_info
                    FROM reservation_tables rt
                             JOIN tables t ON t.id = rt.table
                    WHERE rt.reservation = r.id
            )
        FROM reservations r
                 JOIN users c ON c.id = r.client
                 JOIN restaurants res ON res.id = r.restaurant;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_reservations() TO authenticated;


