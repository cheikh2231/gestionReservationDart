set search_path to public;

/****

(BR-07) Pour un même jour de la semaine, les services d'un restaurant ne peuvent pas se chevaucher.

****/

drop function if exists cannot_overlap();

create or replace function cannot_overlap() returns trigger
as
$$

    begin
        if exists(select * from services where  restaurant = new.restaurant and day_of_week = new.day_of_week and id != new.id
                                           and(start_time < new.end_time and new.start_time<end_time ))

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
insert into services (restaurant, day_of_week, start_time, end_time)

values (1, 1, '08:00', '09:00')
returning id;


insert into services (restaurant, day_of_week, start_time, end_time)

values (1, 1, '09:00', '10:00')
returning id;



-- Modifier le second pour qu'il commence après la fin du premier (ne chevauche plus)

update services set start_time = '09:00' where id = 90;

-- Vérifions qu'on peut le modifier pour qu'il commence encore plus tard (toujours pas de chevauchement)

update services set start_time = '09:30', end_time = '10:30' where id = 90;