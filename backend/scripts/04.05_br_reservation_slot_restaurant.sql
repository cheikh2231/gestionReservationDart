set search_path to public;

DROP FUNCTION IF EXISTS check_reservation_slot_restaurant() ;

create or replace function check_reservation_slot_restaurant()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL as
$$
DECLARE
slot_value INT;
reservation_minutes INT;
BEGIN

SELECT slot_duration
INTO slot_value
FROM restaurants
WHERE id = NEW.restaurant;

-- convertir l'heure en minutes
reservation_minutes := EXTRACT(MINUTE FROM NEW.datetime);

    -- vérifier que les minutes correspondent à un multiple du slot
    IF (reservation_minutes % slot_value) != 0 THEN
       RAISE EXCEPTION 'BR-05: Heure de réservation invalide pour le slot du restaurant';

END IF;

RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS check_reservation_slot_restaurant on reservations;

CREATE TRIGGER check_reservation_slot_restaurant
    BEFORE INSERT OR UPDATE
    ON reservations
    FOR EACH ROW
    EXECUTE FUNCTION check_reservation_slot_restaurant();