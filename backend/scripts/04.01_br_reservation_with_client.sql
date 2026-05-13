set search_path to public;

DROP FUNCTION IF EXISTS created_update_reservation_with_client_role();

CREATE OR REPLACE FUNCTION created_update_reservation_with_client_role()
       RETURNS TRIGGER
       LANGUAGE PLPGSQL
       AS
       $$

BEGIN
        IF not exists (select 1
            from users u
            where id = New.client and
                role = 'client') THEN
           RAISE EXCEPTION 'BR-01: Une réservation doit être associée à un utilisateur ayant le rôle client (id=%)',NEW.client;
END IF;
RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS created_update_reservation_with_client_role on reservations;

CREATE TRIGGER created_update_reservation_with_client_role
    BEFORE INSERT OR UPDATE
    ON reservations
    FOR EACH ROW
    EXECUTE FUNCTION created_update_reservation_with_client_role();