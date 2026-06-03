set search_path to public;

/****
(BR-08) Au moment de leur création ou de leur modification,
  les heures de début et de fin d'un service doivent être alignées sur les créneaux de réservation pour le restaurant.
****/

drop function if exists slot_duration_exception();
create or replace function slot_duration_exception() returns trigger
as
$$
    begin
        if exists(select * from services join public.restaurants r on r.id = new.restaurant where (EXTRACT(MINUTE FROM new.start_time)::int % r.slot_duration != 0) or                                                                 EXTRACT(MINUTE FROM new.end_time)::int % r.slot_duration != 0) then
               Raise EXCEPTION 'les heures de début et de fin d''un service doivent être alignées sur les créneaux de réservation pour le restaurant.';
        end if;
    return new;
    end;
$$language plpgsql;


create or replace trigger slot_duration_exception
before insert or
update on services
for each row
execute function slot_duration_exception();


-- -- slot_duration du restaurant 1 = 30 min, 12:20 n'est pas un multiple de 30  KO
-- INSERT INTO services (restaurant, day_of_week, start_time, end_time)
-- VALUES (1, 3, '12:20', '14:00');
--
-- -- okkkkk
-- INSERT INTO services (restaurant, day_of_week, start_time, end_time)
-- VALUES (1, 3, '12:00', '14:30');