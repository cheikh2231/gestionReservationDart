DROP FUNCTION IF EXISTS get_all_reservations_with_user();
DROP VIEW IF EXISTS view_reservations;

CREATE OR REPLACE VIEW view_reservations AS
SELECT res.*, u.full_name,u.email,u.phone
FROM reservations res
JOIN users u ON res.client = u.id;

GRANT SELECT ON view_reservations TO authenticated;

CREATE OR REPLACE FUNCTION get_all_reservations_with_user()
    RETURNS SETOF view_reservations AS $$
BEGIN
    RETURN QUERY SELECT * FROM view_reservations;
END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION get_all_reservations_with_user() TO authenticated;