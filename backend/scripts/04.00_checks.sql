-- USERS --

-- Le mot de passe doit avoir au minimum une longueur de 8 caractères, doit contenir au moins un chiffre, une lettre majuscule, une lettre minuscule et un caractère spécial parmi les suivants : ,;.:!?/$%&@#.
-- Déjà réalisé dans 02_security.sql
-- Le mot de passe doit être stocké de manière sécurisée (hachage + sel).
-- Déjà réalisé dans 02_security.sql

-- Le nom complet doit avoir une longueur d'au moins 3 caractères.
ALTER TABLE USERS ADD CONSTRAINT check_user_name_length
    CHECK ( full_name.length >= 3 )

-- On ne peut pas modifier le rôle d'un utilisateur.
CREATE TRIGGER forbid_role_update
    BEFORE UPDATE
    ON users
    FOR EACH ROW
    EXECUTE FUNCTION forbid_role_update


CREATE OR REPLACE FUNCTION forbid_role_update
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
       $$


-- Tables --
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
    EXECUTE FUNCTION forbid_update_restaurant_table

CREATE OR REPLACE FUNCTION
       RETURNS TRIGGER
       LANGUAGE PLPGSQL
       AS
       $$
       BEGIN
            IF OLD.restaurant != NEW.restaurant
               RAISE EXCEPTION 'Il est interdit de modifier le restaurant d''une table';
            END IF;
            RETURN NEW
       END;
       $$
