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