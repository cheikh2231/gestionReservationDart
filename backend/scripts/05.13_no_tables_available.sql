
DROP FUNCTION IF EXISTS no_table_dispo(date, int, int, text, int);


CREATE OR REPLACE FUNCTION no_table_dispo(
    date date,
    nb_guests int,
    restaurant_id int,
    slot text,
    excluded_reservation_id int DEFAULT null
)
    RETURNS boolean AS $$
DECLARE
    any_single_table_fits boolean;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM tables t
        WHERE t.restaurant = restaurant_id
          AND t.capacity >= nb_guests
          AND t.id NOT IN (
            SELECT rt."table"
            FROM reservation_tables rt
                     JOIN reservations r ON r.id = rt.reservation
            WHERE r.restaurant = restaurant_id
              AND r.datetime::date = date
              AND r.datetime::time = slot::time
              AND r.status != 'cancelled'
              AND (excluded_reservation_id IS NULL OR r.id != excluded_reservation_id)
        )
    ) INTO any_single_table_fits;


    RETURN NOT any_single_table_fits;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION no_table_dispo(date, int, int, text, int) TO authenticated;