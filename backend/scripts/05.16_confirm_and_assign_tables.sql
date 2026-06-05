set search_path to public;
DROP FUNCTION IF EXISTS public.confirm_and_assign_tables(int,int[]);
CREATE OR REPLACE FUNCTION public.confirm_and_assign_tables(
    idres int,
    tables_ids int[]
)
    RETURNS boolean AS $$
DECLARE
    t_id int;
BEGIN
    FOREACH t_id IN ARRAY tables_ids
        Loop
          INSERT INTO public.reservation_tables ("reservation","table") values(idres,t_id);
        END LOOP;
    update public.reservations set status = 'confirmed'::status_type where id = idres;
RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT UPDATE ON TABLE public.reservations TO authenticated;
GRANT EXECUTE ON FUNCTION public.confirm_and_assign_tables(int,int[]) TO authenticated;
