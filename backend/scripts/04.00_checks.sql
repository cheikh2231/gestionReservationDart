set search_path to public;
-- USERS --

-- Le mot de passe doit avoir au minimum une longueur de 8 caractères, doit contenir au moins un chiffre, une lettre majuscule, une lettre minuscule et un caractère spécial parmi les suivants : ,;.:!?/$%&@#.
-- Déjà réalisé dans 02_security.sql
-- Le mot de passe doit être stocké de manière sécurisée (hachage + sel).
-- Déjà réalisé dans 02_security.sql

-- Le nom complet doit avoir une longueur d'au moins 3 caractères.
ALTER TABLE USERS
DROP CONSTRAINT IF EXISTS check_user_name_length ;

ALTER TABLE USERS ADD CONSTRAINT check_user_name_length
CHECK ( length(trim(full_name)) >= 3 );

-- On ne peut pas modifier le rôle d'un utilisateur.
DROP TRIGGER IF EXISTS forbid_role_update ON USERS;
DROP FUNCTION IF EXISTS forbid_role_update();
CREATE OR REPLACE FUNCTION forbid_role_update()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    IF OLD.role != NEW.ROLE THEN
        RAISE EXCEPTION 'Il est interdit de modifier le role de l''utilisateur';
    END IF;
    RETURN NEW;
END;
$$;



CREATE TRIGGER forbid_role_update
    BEFORE UPDATE
    ON users
    FOR EACH ROW
EXECUTE FUNCTION forbid_role_update();

-- TABLES --

-- Le numéro de table doit être strictement positif et unique au sein d'un même restaurant.
ALTER TABLE tables
DROP CONSTRAINT IF EXISTS check_table_if_exist;

ALTER TABLE tables ADD CONSTRAINT check_table_if_exist
UNIQUE(restaurant , table_number);

-- La capacité doit être strictement positive.
ALTER TABLE tables
DROP CONSTRAINT IF EXISTS check_capacity;

ALTER TABLE tables ADD CONSTRAINT check_capacity
CHECK(capacity > 0);

-- On ne peut pas modifier le restaurant d'une table.
DROP TRIGGER IF EXISTS forbid_update_restaurant_table ON tables;
DROP FUNCTION IF EXISTS forbid_update_restaurant_table;

CREATE OR REPLACE FUNCTION forbid_update_restaurant_table()
       RETURNS TRIGGER
       LANGUAGE PLPGSQL
       AS
       $$
BEGIN
        IF OLD.restaurant != NEW.restaurant THEN
           RAISE EXCEPTION 'Il est interdit de modifier le restaurant d''une table';
        END IF;
        RETURN NEW;
END;
$$;

CREATE TRIGGER forbid_update_restaurant_table
BEFORE UPDATE
ON tables
FOR EACH ROW
EXECUTE FUNCTION forbid_update_restaurant_table();

-- SERVICES --

-- Le jour de la semaine doit être compris entre 1 (lundi) et 7 (dimanche).
ALTER TABLE services
DROP CONSTRAINT IF EXISTS service_day_range;

ALTER TABLE services ADD CONSTRAINT service_day_range
CHECK(day_of_week BETWEEN 1 AND 7);

-- L'heure de fin doit être postérieure à l'heure de début d'au moins une heure. Note : l'heure de fin d'un service représente l'heure au-delà de laquelle le restaurant n'accepte plus de clients.
ALTER TABLE services
DROP CONSTRAINT IF EXISTS service_duration_constraints;

ALTER TABLE services ADD CONSTRAINT service_duration_constraints
CHECK(end_time >= start_time + interval '1 hour' );

-- On ne peut pas modifier le restaurant d'un service.
DROP TRIGGER IF EXISTS forbid_update_restaurant_services ON services;
DROP FUNCTION IF EXISTS forbid_update_restaurant_services();

CREATE OR REPLACE FUNCTION forbid_update_restaurant_services()
       RETURNS TRIGGER
       LANGUAGE PLPGSQL
       AS
       $$
        BEGIN
                IF OLD.restaurant != NEW.restaurant Then
                   RAISE EXCEPTION 'Il est interdit de modifier le restaurant d''un service';
        END IF;
        RETURN NEW;
END;
$$;


CREATE TRIGGER forbid_update_restaurant_services
BEFORE UPDATE
ON services
FOR EACH ROW
EXECUTE FUNCTION forbid_update_restaurant_services();

-- RESTAURANTS --

-- Le nom doit avoir au minimum une longueur de 5 caractères.
ALTER TABLE restaurants
DROP CONSTRAINT IF EXISTS restaurants_name_length;

ALTER TABLE restaurants
ADD CONSTRAINT restaurants_name_length
CHECK (length(trim(name)) >= 5);

-- L'adresse doit avoir au minimum une longueur de 5 caractères.
ALTER TABLE restaurants
DROP CONSTRAINT IF EXISTS restaurants_address_length;

ALTER TABLE restaurants
ADD CONSTRAINT restaurants_address_length
CHECK (length(trim(address)) >= 5);

--La ville doit avoir au minimum une longueur de 3 caractères.
ALTER TABLE restaurants
DROP CONSTRAINT IF EXISTS restaurants_city_length;

ALTER TABLE restaurants
ADD CONSTRAINT restaurants_city_length
CHECK (length(trim(city)) >= 3);

--Le numéro de téléphone doit avoir un format de numéro belge valide, et peut être encodé avec ou sans espaces de séparation entre les groupes de chiffres.

SELECT id, name, phone
FROM restaurants
WHERE     phone ~ '^\+32[ ]?([1-9]\d{0,2})[ ]?(\d{2}[ ]?\d{2}[ ]?\d{2}|\d{3}[ ]?\d{2}[ ]?\d{2})$';


ALTER TABLE restaurants
DROP CONSTRAINT IF EXISTS restaurants_phone_constraint;

ALTER TABLE restaurants
ADD CONSTRAINT restaurants_phone_constraint
CHECK (
    phone ~ '^\+32[ ]?([1-9]\d{0,2})[ ]?(\d{2}[ ]?\d{2}[ ]?\d{2}|\d{3}[ ]?\d{2}[ ]?\d{2})$'
    );

-- La description, si elle est fournie, doit avoir au minimum une longueur de 10 caractères.
ALTER TABLE restaurants
DROP CONSTRAINT IF EXISTS description_check;

ALTER TABLE restaurants
ADD CONSTRAINT description_check
CHECK ( description is null OR length(trim(description)) >= 10 );

--La note doit être comprise entre 0.0 et 5.0 si elle est définie
ALTER TABLE restaurants
DROP CONSTRAINT IF EXISTS rating_check;

ALTER TABLE restaurants
ADD CONSTRAINT rating_check
CHECK (rating is null OR (rating between 0.0 and 5.0) );

--La fourchette de prix doit être comprise entre 1 et 4 si elle est définie
ALTER TABLE restaurants
DROP CONSTRAINT IF EXISTS price_check;

ALTER TABLE restaurants
ADD CONSTRAINT price_check
CHECK ( price_range is null OR (price_range between 1 and 4) );

--La durée de créneau de réservation doit être soit 10, 15, 20, 30 ou 60 minutes.
ALTER TABLE restaurants
DROP CONSTRAINT IF EXISTS duration_check;

ALTER TABLE restaurants
ADD CONSTRAINT duration_check
CHECK ( slot_duration in (10,15,20,30,60) );

-- Reservation --

--Le statut d'une réservation doit être soit pending (en attente de confirmation),
-- confirmed (confirmée), cancelled (annulée) ou completed (terminée suite à la venue effective du client).
ALTER TABLE reservations
DROP CONSTRAINT IF EXISTS check_reservations_status;

ALTER TABLE reservations
ADD CONSTRAINT check_reservations_status
CHECK ( status::text IN ('pending', 'confirmed', 'cancelled', 'completed') ); -- ::text sert a convertir l''enum en text

-- Le nombre de convives d'une réservation doit être strictement positif.
ALTER TABLE reservations
DROP CONSTRAINT IF EXISTS check_number_of_guests;

ALTER TABLE reservations
ADD CONSTRAINT check_number_of_guests
CHECK ( number_of_guests > 0 );

-- Le texte des demandes spéciales d'une réservation (special_requests), s'il est défini, doit avoir une longueur minimale de 10 caractères
ALTER TABLE reservations
DROP CONSTRAINT IF EXISTS check_special_requests;

ALTER TABLE reservations
ADD CONSTRAINT check_special_requests
CHECK ( special_requests is null or length(trim(special_requests)) >= 10 );

-- On ne peut pas modifier le restaurant ou le client d'une réservation.
DROP FUNCTION IF EXISTS forbid_update_restaurant_or_client_services();

CREATE OR REPLACE FUNCTION forbid_update_restaurant_or_client_services()
       RETURNS TRIGGER
       LANGUAGE PLPGSQL
       AS
       $$
BEGIN
        IF OLD.restaurant != NEW.restaurant or OLD.client != NEW.client THEN
           RAISE EXCEPTION 'Il est interdit de modifier le restaurant ou le client d''une reservations';
END IF;
RETURN NEW;
END;
$$;
-- // restaurant manager et restaurant table
DROP TRIGGER IF EXISTS forbid_update_restaurant_or_client_services on reservations;

CREATE TRIGGER forbid_update_restaurant_or_client_services
BEFORE UPDATE
ON reservations
FOR EACH ROW
EXECUTE FUNCTION forbid_update_restaurant_or_client_services();