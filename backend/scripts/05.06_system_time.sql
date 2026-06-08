create or replace function get_simulated_time()
    returns setof system_time as
$$
begin
    return query select simulated_time from system_time limit 1;
end;
$$ language plpgsql security definer;
GRANT EXECUTE ON FUNCTION get_simulated_time TO anon;
grant execute on function get_simulated_time to authenticated;



DROP FUNCTION IF EXISTS update_simulated_time(timestamp);

CREATE OR REPLACE FUNCTION update_simulated_time(new_time timestamp)
    RETURNS void AS $$
BEGIN
    UPDATE system_time SET simulated_time = new_time;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION update_simulated_time(timestamp) TO anon;
grant execute on function update_simulated_time(timestamp) TO authenticated;