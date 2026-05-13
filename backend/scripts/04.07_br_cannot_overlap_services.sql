set search_path to public;

/****

(BR-07) Pour un même jour de la semaine, les services d'un restaurant ne peuvent pas se chevaucher.

****/

drop function if exists cannot_overlap();

create or replace function cannot_overlap() returns trigger
as
$$
    begin
        if exists(select * from services where  restaurant = new.restaurant and day_of_week = new.day_of_week
                                           and(start_time < new.end_time and new.start_time<end_time))
            then
            RAISE EXCEPTION 'Pour un même jour de la semaine, les services d''un restaurant ne peuvent pas se chevaucher.';
        end if;

        return new;
    end;

$$language plpgsql;


create or replace trigger cannot_overlap
before insert or update on services
for each row
execute function cannot_overlap();


-- -- Chevauchement : 13:00-15:00 chevauche 12:00-14:00 (restaurant 1, lundi)  KO
-- INSERT INTO services (id, restaurant, day_of_week, start_time, end_time)
-- VALUES (999, 1, 1, '13:00', '15:00');
-- -- → doit lever une exception
-- -- OK
-- INSERT INTO services (id, restaurant, day_of_week, start_time, end_time)
-- VALUES (999, 1, 1, '14:00', '16:00');
