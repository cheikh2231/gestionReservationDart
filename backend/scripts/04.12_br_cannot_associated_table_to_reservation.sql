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
        if exists(select * from reservation_tables rt join public.reservations r on r.id = new.reservation where r.status in ('cancelled','pending ')) then
            RAISE EXCEPTION 'Une réservation en attente ou annulée ne peut être associée à aucune une table.';
        end if;

    elsif TG_TABLE_NAME = 'reservations' then
        if new.status in ('cancelled', 'pending') then
            DELETE FROM reservation_tables WHERE reservation = new.id;
        end if;
    end if;
    return new;
end;
$$ language plpgsql;


create or replace trigger cannot_associated_table_to_reservation
    before insert or update on reservation_tables
    for each row
execute function cannot_associated_table_to_reservation();

create or replace trigger cannot_associated_table_to_reservation
    after update on reservations
    for each row
execute function cannot_associated_table_to_reservation();


