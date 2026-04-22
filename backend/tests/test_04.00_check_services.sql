set search_path to public;

begin;
do
$test$
    begin
        raise notice 'TEST: Le jour de la semaine doit être compris entre 1 (lundi) et 7 (dimanche)';
        perform should_fail($$
            update services set day_of_week = 8 where id = 1;
        $$, 'check_violation');
    end
$test$;
rollback;


begin;
do
$test$
    begin
        raise notice 'TEST: L''heure de fin doit être postérieure à l''heure de début d''au moins une heure. Note : l''heure de fin d''un service représente l''heure au-delà de laquelle le restaurant n''accepte plus de clients.';
        perform should_fail($$
           INSERT INTO services (restaurant,day_of_week,start_time,end_time) VALUES(1,6,'12:00:00','12:59:00')
        $$, 'check_violation');
    end
$test$;
rollback;

begin;
do
$test$
    begin
        raise notice 'TEST: Il est interdit de modifier le restaurant d''un service.';
        perform should_fail($$
           UPDATE services SET restaurant = 2 where id=1;
        $$, 'raise_exception');
    end
$test$;
rollback;
