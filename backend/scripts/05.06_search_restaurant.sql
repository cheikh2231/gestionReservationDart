set search_path to public;

DROP FUNCTION IF EXISTS get_search_restaurants(text, int);

CREATE OR REPLACE FUNCTION get_search_restaurants(search_filter text, limit_count int)
    RETURNS SETOF public.restaurant_full_info AS $$
BEGIN
    RETURN QUERY
        SELECT
            (r.id, r.name, r.address, r.city, r.phone,
            r.description, r.rating, r.price_range, r.slot_duration)::restaurant_info,
            (SELECT (resLast.id,resLast.datetime)::last_reservation_info
             FROM reservations resLast
             WHERE resLast.restaurant = r.id
              AND resLast.client = auth.id()
        ORDER BY resLast.datetime DESC LIMIT 1),
        (SELECT COUNT(*)::int
         FROM reservations resPending
         WHERE resPending.restaurant = r.id
           AND resPending.client = auth.id()
         AND resPending.status = 'pending')
    FROM restaurants r
    WHERE search_filter IS NULL
        OR r.name ILIKE '%' || search_filter || '%'
        OR r.city ILIKE '%' || search_filter || '%'
        OR r.description ILIKE '%' || search_filter || '%'
    ORDER BY r.name
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_search_restaurants(text, int) TO authenticated;