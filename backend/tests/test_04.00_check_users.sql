set search_path to public;


begin;
do
$test$
    begin
        raise notice 'TEST: le name de l''user est trop court !';
        perform should_fail($$
            update users set full_name = 'ae' where id = 1;
        $$, 'check_violation');
    end
$test$;
rollback;


begin;
do
$test$
    begin
        raise notice 'TEST: Le role ne peut être changé !';
        perform should_fail($$
            update users set role = 'client'::role_type where id = 1;
        $$, 'raise_exception');
    end
$test$;
rollback;
