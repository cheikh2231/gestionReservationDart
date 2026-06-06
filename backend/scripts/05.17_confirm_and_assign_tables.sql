set search_path to public,auth;
DROP FUNCTION IF EXISTS confirm_and_assign_tables(int,int[]);
CREATE OR REPLACE FUNCTION confirm_and_assign_tables(
    idres int,
    tables_ids int[]
)
    RETURNS reservation_info AS $$
DECLARE
    t_id int;
    result reservation_info;
BEGIN
    FOREACH t_id IN ARRAY tables_ids
    Loop
      INSERT INTO public.reservation_tables ("reservation","table") values(idres,t_id);
    END LOOP;
    SELECT * INTO result FROM public.confirm_reservation(idres);
    RETURN result;
END;
$$ LANGUAGE plpgsql security definer;


GRANT EXECUTE ON FUNCTION confirm_and_assign_tables(int,int[]) TO authenticated;

