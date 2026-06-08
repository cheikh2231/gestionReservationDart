set search_path to public;

DROP FUNCTION IF EXISTS public.cancel_reservation(int);
CREATE OR REPLACE FUNCTION cancel_reservation(id_res int)
    RETURNS reservation_info AS
$$
DECLARE
    result reservation_info;
    res_client int;
    res_rest int;
BEGIN
    SELECT client, restaurant INTO res_client, res_rest FROM reservations WHERE id = id_res;

    IF (auth.role() = 'client' AND res_client = auth.id()) OR
       (auth.role() = 'manager' AND EXISTS (SELECT 1
                                            FROM restaurant_managers
                                            WHERE restaurant = res_rest
                                              AND manager = auth.id())) THEN

        UPDATE reservations SET status ='cancelled' WHERE id = id_res AND status != 'cancelled';
    ELSE
        RAISE EXCEPTION 'Accès refusé : vous n''avez pas le droit d''annuler cette réservation.';
    END IF;

--     UPDATE reservations SET status ='cancelled' WHERE id = id_res and exists(select 1 from reservations where reservations.client = auth.id() and reservations.id = id_res and reservations.status != 'cancelled');
    SELECT * INTO result
    FROM get_reservations()
    WHERE id = id_res;
    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION public.cancel_reservation(int) TO authenticated;