/*
Le changement de temps simulé n'a pas d'effet sur le statut des réservations existantes.

(BR-14) Une réservation ne peut pas être créée dans le passé (ne doit être vérifié qu'au moment de la création).

!!!!!!!!!!!!!
En plus des transitions décrites ci-dessus, le statut d'une réservation peut
passer de confirmed à pending uniquement si la réservation est dans le futur (pour permettre l'édition par le client).
!!!!!!!!!!!!!  VOIR BR 04.09 reservations status lifecycle control
*/



DROP FUNCTION IF EXISTS reservation_prevent_past_on_insert();

CREATE OR REPLACE FUNCTION reservation_prevent_past_on_insert()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$
    DECLARE
        current_simulated_time TIMESTAMP;
    BEGIN
        SELECT simulated_time INTO current_simulated_time FROM system_time LIMIT 1;
    IF (NEW.datetime < current_simulated_time) THEN
        RAISE EXCEPTION 'Merci de verifier la date de votre reservation';
    END IF;
    RETURN NEW;
    END;
$$;


DROP TRIGGER IF EXISTS reservation_prevent_past_on_insert on reservations;

CREATE TRIGGER reservation_prevent_past_on_insert
    BEFORE INSERT
    ON reservations
    FOR EACH ROW
    EXECUTE FUNCTION reservation_prevent_past_on_insert();
    
