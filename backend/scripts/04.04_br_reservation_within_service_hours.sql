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

              AND s.day_of_week = EXTRACT(ISODOW FROM NEW.datetime)
              AND NEW.datetime::time >= s.start_time AND NEW.datetime::time <= s.end_time
        ) THEN
            RAISE EXCEPTION 'BR-04: La réservation doit être comprise dans un service valide';
        END IF;

    END IF;

    RETURN NEW;
END;
$$;

DROP FUNCTION IF EXISTS check_service_modification_invalidates_reservations();

CREATE OR REPLACE FUNCTION check_service_modification_invalidates_reservations()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL AS
$$
BEGIN
    -- On cherche s'il y a une réservation "active" pour ce restaurant
    -- qui se retrouve subitement sans AUCUN service valide a cause d'une modification/suppression
    IF EXISTS (
        SELECT 1
        FROM reservations r
        WHERE r.restaurant = OLD.restaurant
          AND r.status::text IN ('pending', 'confirmed', 'completed')
          --
          AND NOT EXISTS (
            SELECT 1
            FROM services s
            WHERE s.restaurant = r.restaurant
              AND s.day_of_week = EXTRACT(ISODOW FROM r.datetime)::int
              AND r.datetime::time >= s.start_time
              AND r.datetime::time < s.end_time
        )
    ) THEN
        RAISE EXCEPTION 'BR-04: La modification ou suppression de ce service invalide une réservation existante.';
    END IF;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
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

DROP TRIGGER IF EXISTS check_service_modification_invalidates_reservations ON services;

CREATE TRIGGER check_service_modification_invalidates_reservations
    AFTER UPDATE OR DELETE
    ON services
    FOR EACH ROW
EXECUTE FUNCTION check_service_modification_invalidates_reservations();