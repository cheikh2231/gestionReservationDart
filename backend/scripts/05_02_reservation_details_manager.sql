-- Toutes les reservations du restaurant

CREATE OR REPLACE FUNCTION get_all_restaurant_reservations(restaurant_id integer)
    RETURNS SETOF reservations AS $$
    BEGIN
        RETURN QUERY
            SELECT res.*
            FROM reservations res
            WHERE res.restaurant = restaurant_id;

    END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_all_restaurant_reservations(integer) TO authenticated;



-- Toutes les reservations en attente du restaurant

-- Toutes les reservations confirmée du restaurant

-- Toutes les reservations Terminée du restaurant

-- Toutes les reservations Annulées du restaurant