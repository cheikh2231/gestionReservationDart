set search_path to public;
-- USERS --

-- Le mot de passe doit avoir au minimum une longueur de 8 caractères, doit contenir au moins un chiffre, une lettre majuscule, une lettre minuscule et un caractère spécial parmi les suivants : ,;.:!?/$%&@#.
-- Déjà réalisé dans 02_security.sql
-- Le mot de passe doit être stocké de manière sécurisée (hachage + sel).
-- Déjà réalisé dans 02_security.sql

-- Le nom complet doit avoir une longueur d'au moins 3 caractères.
ALTER TABLE USERS ADD CONSTRAINT check_user_name_length
    CHECK ( length(trim(full_name)) >= 3 )

-- On ne peut pas modifier le rôle d'un utilisateur.
CREATE TRIGGER forbid_role_update
    BEFORE UPDATE
    ON users
    FOR EACH ROW
    EXECUTE FUNCTION forbid_role_update


CREATE OR REPLACE FUNCTION forbid_role_update()
       RETURNS TRIGGER
       LANGUAGE PLPGSQL
       AS
       $$
BEGIN
        IF OLD.role != NEW.ROLE THEN
           RAISE EXCEPTION 'Il est interdit de modifier le role de l''utilisateur';
END IF,
        RETURN NEW;
END;
$$;


-- TABLES --

-- Le numéro de table doit être strictement positif et unique au sein d'un même restaurant.
ALTER TABLE tables ADD CONSTRAINT check_table_if_exist
    UNIQUE(restaurant , table_number)

-- La capacité doit être strictement positive.
ALTER TABLE tables ADD CONSTRAINT check_capacity
    CHECK(capacity > 0)

-- On ne peut pas modifier le restaurant d'une table.
CREATE TRIGGER forbid_update_restaurant_table
    BEFORE UPDATE
    ON tables
    FOR EACH ROW
    EXECUTE FUNCTION forbid_update_restaurant_table()

CREATE OR REPLACE FUNCTION forbid_update_restaurant_table()
       RETURNS TRIGGER
       LANGUAGE PLPGSQL
       AS
       $$
BEGIN
        IF OLD.restaurant != NEW.restaurant THEN
           RAISE EXCEPTION 'Il est interdit de modifier le restaurant d''une table';
        END IF;
RETURN NEW
END;
$$;
-- SERVICES --

-- Le jour de la semaine doit être compris entre 1 (lundi) et 7 (dimanche).
ALTER TABLE services ADD CONSTRAINT service_day_range
    CHECK(capacity BETWEEN 1 AND 7)

-- L'heure de fin doit être postérieure à l'heure de début d'au moins une heure. Note : l'heure de fin d'un service représente l'heure au-delà de laquelle le restaurant n'accepte plus de clients.
ALTER TABLE services ADD CONSTRAINT service_duration_constraints
       CHECK(age(end_time,start_time) >= 1)
-- On ne peut pas modifier le restaurant d'un service.
CREATE TRIGGER forbid_update_restaurant_services
    BEFORE UPDATE
    ON services
    FOR EACH ROW
    EXECUTE FUNCTION forbid_update_restaurant_services()

CREATE OR REPLACE FUNCTION forbid_update_restaurant_services()
       RETURNS TRIGGER
       LANGUAGE PLPGSQL
       AS
       $$
BEGIN
        IF OLD.restaurant != NEW.restaurant Then
           RAISE EXCEPTION 'Il est interdit de modifier le restaurant d''un service';
END IF;
RETURN NEW
END;
$$;

-- RESTAURANTS --

-- Le nom doit avoir au minimum une longueur de 5 caractères.
alter table restaurants
    add constraint restaurants_name_length
        check (length(trim(name)) >= 5);

-- L'adresse doit avoir au minimum une longueur de 5 caractères.
alter table restaurants
    add constraint restaurants_adress_length
        check (length(trim(adress)) >= 5);

--La ville doit avoir au minimum une longueur de 3 caractères.
alter table restaurants
    add constraint restaurants_city_length
        check (length(trim(city)) >= 3);

--Le numéro de téléphone doit avoir un format de numéro belge valide, et peut être encodé avec ou sans espaces de séparation entre les groupes de chiffres.
alter table restaurants
    add constraint restaurant_phone_constraint
        check (regexp_match(phone,'^(?:\+32|0)[1-9](?:[ ]?[0-9]){7,8}$'))

-- La description, si elle est fournie, doit avoir au minimum une longueur de 10 caractères.
alter table restaurants
    add constraint description_check
        check ( description is null OR length(trim(description)) >= 10 );

--La note doit être comprise entre 0.0 et 5.0 si elle est définie
alter table restaurants
    add constraint rating_check
        check ( rating is null OR (length(rating) between 0.0 and 5.0) );

--La fourchette de prix doit être comprise entre 1 et 4 si elle est définie
alter table restaurants
    add constraint price_check
        check ( price_range is null OR (length(price_range) between 1 and 4) );

--La durée de créneau de réservation doit être soit 10, 15, 20, 30 ou 60 minutes.
alter table restaurants
    add constraint duration_check
        check ( slot_duration in (10,15,20,30,60) );

-- Reservation --

--Le statut d'une réservation doit être soit pending (en attente de confirmation),
-- confirmed (confirmée), cancelled (annulée) ou completed (terminée suite à la venue effective du client).


-- Le nombre de convives d'une réservation doit être strictement positif.


-- Le texte des demandes spéciales d'une réservation (special_requests), s'il est défini, doit avoir une longueur minimale de 10 caractères


-- On ne peut pas modifier le restaurant ou le client d'une réservation.

CREATE TRIGGER forbid_update_restaurant_or_client_services
    BEFORE UPDATE
    ON reservations
    FOR EACH ROW
    EXECUTE FUNCTION forbid_update_restaurant_or_client_services()

CREATE OR REPLACE FUNCTION forbid_update_restaurant_or_client_services()
       RETURNS TRIGGER
       LANGUAGE PLPGSQL
       AS
       $$
BEGIN
        IF OLD.restaurant != NEW.restaurant or OLD.client != NEW.client THEN
           RAISE EXCEPTION 'Il est interdit de modifier le restaurant ou le client d''un service';
END IF;
RETURN NEW
END;
$$;
