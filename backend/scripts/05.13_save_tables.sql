set search_path to public;

DROP FUNCTION IF EXISTS get_restaurant_tables(int);

CREATE OR REPLACE FUNCTION get_restaurant_tables(p_restaurant_id int)
    RETURNS SETOF table_info AS $$
BEGIN
    RETURN QUERY
        SELECT t.id,
               (res.id, res.name, res.address, res.city, res.phone)::restaurant_info,
                t.table_number,t.capacity
        FROM tables t
        JOIN restaurants res ON res.id = t.restaurant
        WHERE t.restaurant = p_restaurant_id
        ORDER BY t.capacity ASC, t.table_number ASC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION get_restaurant_tables(int) TO authenticated;


DROP FUNCTION IF EXISTS save_table(int, int, int, int);

CREATE OR REPLACE FUNCTION save_table( p_restaurant_id int,p_table_number int, p_capacity int, p_table_id int DEFAULT NULL)
    RETURNS table_info AS $$
DECLARE
    new_id int;
    result table_info;
BEGIN
    IF p_table_id IS NULL THEN
        INSERT INTO tables (restaurant, table_number, capacity)
        VALUES (p_restaurant_id, p_table_number, p_capacity)
        RETURNING id INTO new_id;
    ELSE
        UPDATE tables
        SET table_number = p_table_number,
        capacity = p_capacity
        WHERE id = p_table_id AND restaurant = p_restaurant_id
        RETURNING id INTO new_id;
    END IF;

    SELECT * INTO result FROM get_restaurant_tables(p_restaurant_id) WHERE id = new_id;
    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION save_table(int, int, int, int) TO authenticated;