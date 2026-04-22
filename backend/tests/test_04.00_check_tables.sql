set search_path to public;


begin;
do
$test$
    begin
        raise notice 'TEST: Le numéro de table doit être strictement positif et unique au sein d''un même restaurant. !';
        perform should_fail($$
            update tables set table_number = 1 where id = 3;
        $$, 'unique_violation');
    end
$test$;
rollback;


begin;
do
$test$
    begin
        raise notice 'TEST: la capacity doit etre positif !';
        perform should_fail($$
            update tables set capacity = 0 where id = 1;
        $$, 'check_violation');
    end
$test$;
rollback;

begin;
do
$test$
    begin
        raise notice 'TEST: Le numéro de table doit être strictement positif et unique au sein d''un même restaurant. !';
        perform should_fail($$
            update tables set restaurant = 2 where id = 1;
        $$, 'raise_exception');
    end
$test$;
rollback;