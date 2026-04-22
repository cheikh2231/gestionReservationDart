set search_path to public;

begin;
do
$test$
begin
        raise notice 'TEST: Le statut d''une réservation doit être soit pending (en attente de confirmation),confirmed (confirmée), cancelled (annulée) ou completed (terminée suite à la venue effective du client)';
        perform should_fail($$
            update reservations set status = 'abc'::status_type where id = 1;
        $$, 'invalid_text_representation');
end
$test$;
rollback;

begin;
do
$test$
    begin
        raise notice 'TEST: Le nombre de convives d''une réservation doit être strictement positif !';
        perform should_fail($$
            update reservations set number_of_guests = 0 where id = 1;
        $$, 'check_violation');
    end
$test$;
rollback;


begin;
do
$test$
    begin
        raise notice 'TEST: Le texte des demandes spéciales d''une réservation (special_requests), s''il est défini, doit avoir une longueur minimale de 10 caractères!';
        perform should_fail($$
            update reservations set special_requests = 'abc' where id = 1;
        $$, 'check_violation');
    end
$test$;
rollback;

begin;
do
$test$
    begin
        raise notice 'TEST: On ne peut pas modifier le restaurant ou le client d''une réservation..';
        perform should_fail($$
           UPDATE reservations SET restaurant = 2 where id=1;
        $$, 'raise_exception');
    end
$test$;
rollback;

begin;
do
$test$
    begin
        raise notice 'TEST: On ne peut pas modifier le restaurant ou le client d''une réservation..';
        perform should_fail($$
           UPDATE reservations SET client = 2 where id=1;
        $$, 'raise_exception');
    end
$test$;
rollback;

