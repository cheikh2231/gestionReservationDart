/*(BR-09) Une nouvelle réservation doit avoir le status pending.
Une réservation existante ne peut pas revenir "en arrière" dans son cycle de vie. Les transitions autorisées sont :
pending -> confirmed
pending -> cancelled
confirmed -> completed
confirmed -> cancelled
La transition confirmed -> pending est autorisée dans certains cas (voir règles temporelles).

Aucune transition depuis completed ou cancelled n'est autorisée.
RT :
En plus des transitions décrites ci-dessus, le statut d'une réservation peut passer de confirmed à pending
uniquement si la réservation est dans le futur (pour permettre l'édition par le client).

*/
DROP FUNCTION IF EXISTS reservation_status_lifecycle_control();
CREATE OR REPLACE FUNCTION reservation_status_lifecycle_control()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    current_simulated_time TIMESTAMP;
BEGIN
    SELECT simulated_time INTO current_simulated_time FROM system_time LIMIT 1;
    IF (TG_OP = 'INSERT') THEN
        NEW.status := 'pending';
        RETURN NEW;
    END IF;
    IF (TG_OP = 'UPDATE') THEN
        IF (OLD.status = NEW.status) THEN
            RETURN NEW;
        END IF;
        IF (OLD.STATUS = 'completed') THEN
            RAISE EXCEPTION 'Le status ne peut pas être mis a jours.';
        END IF;
        IF (OLD.status = 'cancelled') THEN
            RAISE EXCEPTION 'Le status ne peut pas être mis a jours.';
        END IF;
        IF (OLD.status = 'confirmed') THEN
            IF (NEW.status = 'pending' AND current_simulated_time > NEW.date_time) THEN
                RAISE EXCEPTION 'Le status ne peut pas être mis a jours.';
            END IF;
        END IF;
        IF (OLD.status = 'pending') THEN
           IF(NEW.status = 'completed') THEN
                RAISE EXCEPTION 'Le status ne peut pas être mis a jours.';
           END IF;
        END IF;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS reservation_status_lifecycle_control on reservations;

CREATE TRIGGER reservation_status_lifecycle_control
    BEFORE INSERT OR UPDATE
    ON reservations
    FOR EACH ROW
    EXECUTE FUNCTION reservation_status_lifecycle_control();

