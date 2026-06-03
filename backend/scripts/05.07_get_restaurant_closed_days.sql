
DROP FUNCTION IF EXISTS public.get_closed_days(int);

CREATE OR REPLACE FUNCTION public.get_closed_days(id_res int)
    RETURNS SETOF int AS $$
BEGIN
    RETURN QUERY
        SELECT * FROM generate_series(1, 7)
        EXCEPT
        SELECT DISTINCT day_of_week
        FROM services
        WHERE restaurant = id_res;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.get_closed_days(int) TO authenticated;