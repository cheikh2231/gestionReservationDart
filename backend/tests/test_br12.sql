begin;
do
$test$
    declare
r_id int;
begin
        raise notice 'TEST: BR-12.6 - OK - autoriser l''annulation après retrait préalable de toutes les tables associées (créer une réservation pour le client 4 au restaurant 1 le 2025-11-20 19:00:00 pour 2 convives puis associer la réservation à la table 1 puis passer le statut à confirmed puis supprimer l''association à la table puis passer le statut à cancelled)';
insert into reservations (client, restaurant, datetime, number_of_guests)
values (4, 1, '2025-11-20 19:00:00', 2)
    returning id into r_id;
insert into reservation_tables (reservation, "table") values (r_id, 1);
update reservations set status = 'confirmed'::status_type where id = r_id;
delete from reservation_tables where reservation = r_id;
update reservations set status = 'cancelled'::status_type where id = r_id;
set constraints all immediate;
end
$test$;
rollback;