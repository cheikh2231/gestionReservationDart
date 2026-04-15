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