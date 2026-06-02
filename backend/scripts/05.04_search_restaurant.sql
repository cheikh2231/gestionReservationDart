set search_path to public;

DROP FUNCTION IF EXISTS get_restaurants(text, int);

CREATE OR REPLACE FUNCTION get_restaurants(search_filter text, limit_count int)
    RETURNS SETOF restaurants_info AS $$
BEGIN
    RETURN QUERY
        SELECT
            r.id, r.name, r.address, r.city, r.phone,
            r.description, r.rating, r.price_range, r.slot_duration,
            MAX(resLast.datetime) as last_reservation,
            COUNT(DISTINCT resPending.id)::int as nb_pending_reservation
            FROM restaurants r LEFT JOIN reservations resLast
            ON resLast.restaurant = r.id
            AND resLast.client = (current_setting('request.jwt.claims', true)::json ->> 'user_id')::int
            LEFT JOIN reservations resPending
            ON resPending.restaurant = r.id
            AND resPending.client = (current_setting('request.jwt.claims', true)::json ->> 'user_id')::int
            AND resPending.status = 'pending'
            WHERE search_filter IS NULL
            OR r.name ILIKE '%' || search_filter || '%'
            OR r.city ILIKE '%' || search_filter || '%'
            OR r.description ILIKE '%' || search_filter || '%'
            GROUP BY r.id, r.name, r.address, r.city, r.phone, r.description, r.rating, r.price_range, r.slot_duration
            ORDER BY r.name ASC
            LIMIT limit_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_restaurants(text, int) TO authenticated;