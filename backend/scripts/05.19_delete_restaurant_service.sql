set search_path to public, auth;

DROP FUNCTION IF EXISTS public.delete_restaurant_service(int);
CREATE OR REPLACE FUNCTION delete_restaurant_service(id_service int)
    RETURNS void AS
$$
DECLARE
    authorized bool;
BEGIN
    SELECT true INTO authorized from services s
    JOIN restaurant_managers rm on rm.restaurant = s.restaurant
    WHERE s.id = id_service
    AND rm.manager = auth.id();
    IF authorized THEN
        DELETE FROM services WHERE id = id_service;
    ELSE
        RAISE EXCEPTION 'Action non autorisée ou service introubable';
    END IF;
END;

$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION delete_restaurant_service(int) TO authenticated;

