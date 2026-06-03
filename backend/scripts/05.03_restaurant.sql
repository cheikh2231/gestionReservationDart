set search_path to public;

DROP FUNCTION IF EXISTS get_restaurants();
CREATE OR REPLACE FUNCTION get_restaurants()
    RETURNS SETOF restaurant_full_info AS $$
BEGIN
    RETURN QUERY
        SELECT (r.id, r.name, r.address, r.city, r.phone,
               r.description, r.rating, r.price_range, r.slot_duration)::restaurant_info,
               (SELECT (resLast.id, resLast.datetime)::last_reservation_info
                FROM reservations resLast
                WHERE resLast.restaurant = r.id
                ORDER BY resLast.datetime DESC LIMIT 1),
                (SELECT COUNT(*)::int
                 FROM reservations resPending
                 WHERE r.id = resPending.restaurant
                 AND resPending.status = 'pending')
        FROM restaurants r;
    END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


GRANT EXECUTE ON FUNCTION get_restaurants() TO authenticated;

