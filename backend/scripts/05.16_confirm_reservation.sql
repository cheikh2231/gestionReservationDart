set search_path to public, auth;

DROP FUNCTION IF EXISTS public.confirm_reservation(int);
CREATE OR REPLACE FUNCTION confirm_reservation(id_res int)
    RETURNS reservation_info AS
$$
DECLARE
    result reservation_info;
BEGIN
    UPDATE reservations SET status = 'confirmed' WHERE id = id_res;
    SELECT * INTO result
    FROM get_reservations()
    WHERE id = id_res;
    RETURN result;
END;

$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION confirm_reservation(int) TO authenticated;

