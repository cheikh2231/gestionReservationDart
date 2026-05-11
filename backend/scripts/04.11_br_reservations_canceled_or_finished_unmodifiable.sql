/*(BR-11) Une réservation terminée ou annulée ne peut pas être modifiée.*/
DROP FUNCTION IF EXISTS reservation_cannot_be_modified_when_cancelled_or_completed();

CREATE OR REPLACE FUNCTION reservation_cannot_be_modified_when_cancelled_or_completed()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    IF OLD.status IN('cancelled', 'completed') THEN
        RAISE EXCEPTION 'Modification interdite pour ce statut.';
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS reservation_cannot_be_modified_when_cancelled_or_completed on reservations;

CREATE TRIGGER reservation_cannot_be_modified_when_cancelled_or_completed
BEFORE UPDATE
ON reservations
FOR EACH ROW
EXECUTE FUNCTION reservation_cannot_be_modified_when_cancelled_or_completed();
