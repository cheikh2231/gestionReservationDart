set search_path to public, auth;

DROP FUNCTION IF EXISTS public.complete_reservation(int);
CREATE OR REPLACE FUNCTION complete_reservation(id_res int)
    RETURNS reservation_info AS
$$
DECLARE
    result reservation_info;
BEGIN
    UPDATE reservations SET status = 'completed' WHERE id = id_res;
    SELECT * INTO result
    FROM get_reservations()
    WHERE id = id_res;
    RETURN result;
END;

$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION complete_reservation(int) TO authenticated;

