DROP function if exists add_reservation(restaurant_id int, datetime_res timestamp, nb_guests int, request text);
CREATE OR REPLACE FUNCTION add_reservation(
    restaurant_id int,
    datetime_res timestamp,
    nb_guests int,
    request text
)
    RETURNS reservation_info AS $$
DECLARE
    result reservation_info;
    new_id int;
BEGIN
    IF auth.role() = 'manager' THEN
            RAISE EXCEPTION 'Accès refusé : un manager ne peut pas créer de réservation.';
    END IF;

    INSERT INTO reservations (client, restaurant, datetime, number_of_guests, status, special_requests)
    VALUES (auth.id(), restaurant_id, datetime_res, nb_guests, 'pending', NULLIF(request, ''))
    RETURNING id INTO new_id;

    SELECT * INTO result FROM get_reservations() WHERE id = new_id;
    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION add_reservation(int, timestamp, int, text) TO authenticated;
