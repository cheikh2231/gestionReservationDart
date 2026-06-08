
DROP FUNCTION IF EXISTS no_table_dispo(date, int, int, text,int);


CREATE OR REPLACE FUNCTION no_table_dispo(
    date date,
    nb_guests int,
    restaurant_id int,
    slot text,
    id_reservation_if_in_edit int default null
)
    RETURNS boolean AS $$
DECLARE
    sum_capacities integer;
    sum_nb_guests integer;
BEGIN
    SELECT SUM(t.capacity) into sum_capacities from tables t
    where t.restaurant = restaurant_id;
    select SUM(number_of_guests) into sum_nb_guests from reservations r where r.restaurant = restaurant_id and r.datetime::date = date
    and get_service(r.restaurant,r.datetime::time) = get_service(restaurant_id,slot::time)
    and r.status != 'cancelled' and r.status != 'completed'
    and (id_reservation_if_in_edit is null or r.id != id_reservation_if_in_edit);

    RETURN sum_nb_guests + nb_guests > sum_capacities;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION no_table_dispo(date, int, int, text,int) TO authenticated;