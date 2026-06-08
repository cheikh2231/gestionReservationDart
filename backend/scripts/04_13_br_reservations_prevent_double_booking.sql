/*(BR-13) Un client ne peut pas avoir deux réservations en attente, confirmées ou terminées pour une même date et un même service.*/

DROP FUNCTION IF EXISTS reservation_prevent_double_booking() cascade;

CREATE OR REPLACE FUNCTION reservation_prevent_double_booking()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$
DECLARE
client_reservations INTEGER;
BEGIN
SELECT COUNT(*) INTO client_reservations FROM reservations AS r
JOIN restaurants ON restaurants.id = r.restaurant
JOIN services AS s ON s.restaurant = restaurants.id
WHERE r.client = NEW.client
and r.restaurant = new.restaurant
AND r.datetime::date = NEW.datetime::date
AND status != 'cancelled'
AND (
    NEW.datetime::time BETWEEN s.start_time AND s.end_time
    AND
    r.datetime::time BETWEEN s.start_time AND s.end_time
    )
AND r.id <> NEW.id;
    IF (client_reservations >= 1) THEN
        RAISE EXCEPTION 'Vous avez déjà une réservation pour ce service !';
    END IF;
RETURN NEW;
END;
$$;


DROP TRIGGER IF EXISTS reservation_prevent_double_booking on reservations;

CREATE TRIGGER reservation_prevent_double_booking
     BEFORE INSERT OR UPDATE
     ON reservations
     FOR EACH ROW
     EXECUTE FUNCTION reservation_prevent_double_booking();

