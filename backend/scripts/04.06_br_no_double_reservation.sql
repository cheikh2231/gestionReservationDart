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
                                                  and heure < s.end_time;
    if id_service is null then
        RAISE 'don''t have a service with this idresto % and for this time %',id_resto,heure;
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
      and r.status in ('confirmed','pending')
      and r_new.status in ('confirmed','pending');

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



INSERT INTO reservations (client, restaurant, datetime, number_of_guests, status)
VALUES (3, 1, '2024-11-15 19:00:00', 2, 'confirmed')
RETURNING id;


INSERT INTO reservation_tables (reservation, "table")
VALUES (23, 1);
