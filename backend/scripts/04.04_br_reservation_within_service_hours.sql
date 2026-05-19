set search_path to public;

DROP FUNCTION IF EXISTS check_reservation_service_hours() ;

create or replace function check_reservation_service_hours()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL as
$$
begin


    IF NEW.status IN ('pending', 'confirmed', 'completed') THEN

        IF NOT EXISTS (
            SELECT 1
            FROM services s
            WHERE s.restaurant = NEW.restaurant

              AND s.day_of_week =
                  CASE
                      WHEN EXTRACT(ISODOW FROM NEW.datetime) = 0 THEN 7
                      ELSE EXTRACT(ISODOW FROM NEW.datetime)
                      END

              AND NEW.datetime::time >= s.start_time AND NEW.datetime::time < s.end_time
        ) THEN
            RAISE EXCEPTION 'BR-04: La réservation doit être comprise dans un service valide';
        END IF;

    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS check_reservation_service_hours on reservations;

CREATE TRIGGER check_reservation_service_hours
    BEFORE INSERT OR UPDATE
    ON reservations
    FOR EACH ROW
EXECUTE FUNCTION check_reservation_service_hours();