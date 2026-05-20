set search_path to public;

-- (BR-04) L'heure d'une réservation confirmée, terminée ou en attente doit être comprise entre
-- l'heure de début et l'heure de fin d'un service pour le même jour de la semaine.

DROP FUNCTION IF EXISTS check_reservation_service_hours() ;

create or replace function check_reservation_service_hours()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL as
$$
begin


    IF new.status in('confirmed','pending','completed')
        AND NOT EXISTS(
            select * from services s where day_of_week = extract(isodow from new.datetime::date)
                                       AND (new.datetime::time >= s.start_time and new.datetime::time <= s.end_time)
        )
    THEN
        RAISE EXCEPTION 'BR-04: La réservation doit être comprise dans un service valide';
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