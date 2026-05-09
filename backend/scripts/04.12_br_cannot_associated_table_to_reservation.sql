set search_path to public;

/****

(BR-12) Une réservation en attente ou annulée ne peut être associée à aucune une table.
pas finiiiiiiiiiiiiiiiiii est-ce qu'une annulation doit automatiquement libérer les tables ?
****/

drop function if exists cannot_associated_table_to_reservation();

create or replace function cannot_associated_table_to_reservation() returns trigger
as
$$
begin
    if TG_TABLE_NAME = 'reservation_tables' then
        if exists(select 1 from reservations r where r.id = new.reservation and r.status in ('cancelled', 'pending')) then
            RAISE EXCEPTION 'Une réservation en attente ou annulée ne peut être associée à aucune table.';
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


