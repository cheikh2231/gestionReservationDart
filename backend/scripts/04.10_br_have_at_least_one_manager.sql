set search_path to public;

/****

(BR-10) Un restaurant doit avoir au moins un manager.

****/

drop function if exists at_least_one_manager();

create or replace function at_least_one_manager() returns trigger
as
$$
declare nbmanagers INTEGER;
begin
    select count(*) into nbmanagers from restaurant_managers where restaurant = old.restaurant group by restaurant;
    if (nbmanagers = 1) then
        RAISE exception 'le restaurant avec l''id % doit avoir au moins un manager.',old.restaurant;
    end if;
return old;
end;

$$language plpgsql;


create or replace trigger at_least_one_manager
before delete on restaurant_managers
for each row
execute function at_least_one_manager();


-- Tenter de supprimer le dernier → doit lever une exception KO
DELETE FROM restaurant_managers
WHERE restaurant =5;