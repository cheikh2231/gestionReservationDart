set search_path to public, auth;

DROP FUNCTION IF EXISTS public.delete_reservation_tables(int);
CREATE OR REPLACE FUNCTION delete_reservation_tables(id_res int)
    RETURNS reservation_info AS
$$
DECLARE
    result reservation_info;
BEGIN
    DELETE FROM reservation_tables WHERE reservation = id_res and exists(select 1 from reservations where reservations.client = auth.id() and reservations.id = id_res);
    SELECT * INTO result
    FROM get_reservations()
    WHERE id = id_res;
    RETURN result;
END;

$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION delete_reservation_tables(int) TO authenticated;

