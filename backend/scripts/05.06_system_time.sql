create or replace function get_simulated_time()
    returns setof system_time as
$$
begin
    return query select simulated_time from system_time limit 1;
end;
$$ language plpgsql security definer;


grant execute on function get_simulated_time to authenticated;