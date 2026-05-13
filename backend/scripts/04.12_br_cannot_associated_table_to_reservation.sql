set search_path to public;

/****

(BR-12) Une réservation en attente ou annulée ne peut être associée à aucune une table.
****/

drop function if exists cannot_associated_table_to_reservation();

create or replace function cannot_associated_table_to_reservation() returns trigger
as
$$
declare have_table bool;
begin
    if TG_TABLE_NAME = 'reservation_tables' then
        if exists(select * from reservation_tables rt join public.reservations r on r.id = new.reservation where r.status in ('cancelled','pending')) then
            RAISE EXCEPTION 'Une réservation en attente ou annulée ne peut être associée à aucune une table.';
        end if;

    elsif TG_TABLE_NAME = 'reservations' then
        have_table = exists(select * from reservation_tables where reservation = new.id);
        if (new.status in ('cancelled', 'pending') and have_table) then
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

DROP TRIGGER IF EXISTS cannot_associated_table_to_reservation ON reservations;
create or replace trigger cannot_associated_table_to_reservation
    after update on reservations
    for each row
execute function cannot_associated_table_to_reservation();


