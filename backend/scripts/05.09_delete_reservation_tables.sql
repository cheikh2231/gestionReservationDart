set search_path to public, auth;

DROP FUNCTION IF EXISTS public.delete_reservation_tables(int);
CREATE OR REPLACE FUNCTION delete_reservation_tables(id_res int)
    RETURNS reservation_info AS
$$
DECLARE
    result reservation_info;
    res_client int;
    res_rest int;
BEGIN
    SELECT client, restaurant INTO res_client, res_rest FROM reservations WHERE id = id_res;

    IF (auth.role() = 'client' AND res_client = auth.id()) OR
       (auth.role() = 'manager' AND EXISTS (SELECT 1 FROM restaurant_managers WHERE restaurant = res_rest AND manager = auth.id())) THEN

        DELETE FROM reservation_tables WHERE reservation = id_res;
    ELSE
        RAISE EXCEPTION 'Accès refusé.';
    END IF;
--     DELETE FROM reservation_tables WHERE reservation = id_res and exists(select 1 from reservations where reservations.client = auth.id() and reservations.id = id_res);
    SELECT * INTO result
    FROM get_reservations()
    WHERE id = id_res;
    RETURN result;
END;

$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION delete_reservation_tables(int) TO authenticated;

