set search_path to public;

/****

(BR-06) Une table ne peut pas faire l'objet de deux réservations terminées ou confirmées pour une même date et un même service.

****/
drop function if exists get_service(id_resto int,heure Time);
create or replace function get_service(id_resto int,heure Time) returns int
as
$$
    declare id_service INTEGER;
begin
    select s.id into id_service from services s where s.restaurant = id_resto and heure >= s.start_time
                                                  and heure <= s.end_time;
    if id_service is null then
        RAISE 'don''t have a service with this id resto % and for this time %',id_resto,heure;
    end if;
    return id_service;
    end;
$$language plpgsql;

drop function if exists no_double_reservation();

create or replace function no_double_reservation()
    returns trigger
as
$$
declare
    nb_res int;
begin
    select count(*) into nb_res
    from reservation_tables rt
             join reservations r on r.id = rt.reservation
             join reservations r_new on r_new.id = new.reservation
    where rt."table" = new."table"
      and date(r.datetime) = date(r_new.datetime)
      and get_service(r.restaurant, r.datetime::time)
        = get_service(r_new.restaurant, (r_new.datetime::time))
      and r.status in ('confirmed','completed')
      and r_new.status in ('confirmed','completed');

    if nb_res > 0 then
        raise exception 'Une table ne peut pas faire l''objet de deux réservations terminées ou confirmées pour une même date et un même service.';
    end if;

    return new;
end;


$$ language plpgsql;


CREATE or REPLACE trigger no_double_reservation
before insert or update on reservation_tables
for each row
execute function no_double_reservation();


drop function if exists no_double_reservation_on_reservation() cascade;
create or replace function no_double_reservation_on_reservation()
    returns trigger as $$
begin
    if (NEW.status in ('confirmed', 'completed') and (OLD.status is distinct from NEW.status or OLD.datetime is distinct from NEW.datetime)) then
        if exists (
            select 1
            from reservation_tables rt1
                     join reservation_tables rt2 on rt2.table = rt1.table
                     join reservations r2 on r2.id = rt2.reservation
            where rt1.reservation = NEW.id
              and r2.id != NEW.id
              and date(NEW.datetime) = date(r2.datetime)
              and get_service(NEW.restaurant, NEW.datetime::time) = get_service(r2.restaurant, r2.datetime::time)
              and r2.status in ('confirmed', 'completed')
        ) then
            raise exception 'Une table ne peut pas faire l''objet de deux réservations terminées ou confirmées pour une même date et un même service.';
        end if;
    end if;
    return new;
end;
$$ language plpgsql;

drop trigger if exists no_double_reservation_on_res on reservations;
CREATE or REPLACE trigger no_double_reservation_on_res
    after update of status, datetime on reservations
    for each row
execute function no_double_reservation_on_reservation();



--
--
-- INSERT INTO reservation_tables (reservation, "table")
-- VALUES (23, 1);
--

