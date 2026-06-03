set search_path to public;

DROP FUNCTION IF EXISTS get_tables();
CREATE OR REPLACE FUNCTION get_tables()
    RETURNS SETOF table_info AS $$
BEGIN
RETURN QUERY
SELECT
    t.id,
    (res.id, res.name, res.address, res.city, res.phone, res.description, res.rating, res.price_range, res.slot_duration)::restaurant_info,
    t.table_number,
    t.capacity
    FROM tables t
    JOIN restaurants res ON res.id = t.restaurant;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_tables() TO authenticated;


DROP FUNCTION IF EXISTS get_available_tables(int,int);
CREATE OR REPLACE FUNCTION get_available_tables(restaurant_id int, reservation_id int)
    RETURNS SETOF table_info AS $$
BEGIN
    RETURN QUERY
        SELECT * FROM tables t
        WHERE t.restaurant = restaurant_id
        AND t.id not in
            (
                SELECT rt.table FROM reservation_tables rt
                JOIN reservations res ON res.id = rt.reservation
                WHERE res.status in ('pending','confirmed')
            );

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_available_tables(int, int) TO authenticated;


CREATE OR REPLACE FUNCTION get_tables_with_and_whitout_availability(restaurant_id int,reservation_id int)
    RETURNS TABLE (
                      id int,
                      restaurant int,
                      capacity int,
                      table_number int,
                      reserved boolean
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT t.id, t.restaurant, t.capacity, t.table_number,
               EXISTS(
                   SELECT 1
                   FROM reservation_tables rt
                            JOIN reservations r ON rt.reservation = r.id
                       -- on cherche le service dans lequel tombe la reservation r
                            JOIN services s ON s.restaurant = r.restaurant
                       AND s.day_of_week = EXTRACT(ISODOW FROM r.datetime)
                       AND r.datetime::time >= s.start_time
                       AND r.datetime::time < s.end_time
                   WHERE rt.table = t.id -- la table doit etre celle qu'on est occupé a verifier
                     AND r.id != reservation_id -- on ne verifie pas sur la reservation qu'on est occupé a modifier
                     AND r.status IN ('confirmed', 'completed') -- on ne prend en considération que les status confirmed et completed
                     AND s.id = ( -- le service doit etre le meme que celui de la reservation qu'on modifie
                       SELECT s2.id FROM services s2
                                             JOIN reservations r2 ON r2.id = reservation_id
                       WHERE s2.restaurant = restaurant_id
                         AND s2.day_of_week = EXTRACT(ISODOW FROM r2.datetime)
                         AND r2.datetime::time >= s2.start_time
                         AND r2.datetime::time < s2.end_time
                   )
               ) AS reserved
        FROM tables t
        WHERE t.restaurant = restaurant_id
        ORDER BY t.table_number;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_tables_with_and_whitout_availability(int, int) TO authenticated;