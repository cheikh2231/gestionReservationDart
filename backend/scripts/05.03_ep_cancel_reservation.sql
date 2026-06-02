set search_path to public;

DROP FUNCTION IF EXISTS public.cancel_reservation(int);
CREATE OR REPLACE FUNCTION cancel_reservation(id_res int)
    RETURNS reservations_info AS
$$
DECLARE
    result reservations_info;
BEGIN
    UPDATE reservations SET status ='cancelled' WHERE id = id_res;
    SELECT * INTO result
    FROM get_reservations()
    WHERE id = id_res;
    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION public.cancel_reservation(int) TO authenticated;