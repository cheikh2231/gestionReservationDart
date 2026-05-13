set search_path to public;

DROP FUNCTION IF EXISTS check_tables_reservation_same();

CREATE OR REPLACE FUNCTION check_tables_reservation_same()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$

BEGIN
    IF not exists (select 1
                   from reservations r
                       join tables t on t.id = NEW.table
                   where r.id = NEW.reservation and
                         t.restaurant = r.restaurant) THEN
        RAISE EXCEPTION 'BR-03: Une réservation doit être associée à une table appartenant au restaurant';
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS check_tables_reservation_same on reservation_tables;

CREATE TRIGGER check_tables_reservation_same
    BEFORE INSERT OR UPDATE
    ON reservation_tables
    FOR EACH ROW
EXECUTE FUNCTION check_tables_reservation_same();