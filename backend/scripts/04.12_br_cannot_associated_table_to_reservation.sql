set search_path to public;

/****

(BR-12) Une réservation en attente ou annulée ne peut être associée à aucune une table.
****/

drop function if exists cannot_associated_table_to_reservation();

create or replace function cannot_associated_table_to_reservation() returns trigger
as
$$
begin

    if TG_TABLE_NAME = 'reservation_tables' then
        if  exists(select 1 from reservations r where r.id = new.reservation and r.status in ('cancelled','pending')) then
            RAISE EXCEPTION 'Une réservation en attente ou annulée ne peut être associée à aucune une table.';
        end if;
    end if;
    return new;
end;
$$ language plpgsql;

DROP TRIGGER IF EXISTS cannot_associated_table_to_reservation_tables ON reservation_tables;

create constraint trigger cannot_associated_table_to_reservation_tables
    after insert or update on reservation_tables
    deferrable initially deferred
    for each row
execute function cannot_associated_table_to_reservation();

