DROP FUNCTION IF EXISTS update_reservation(timestamp, int, int, text, status_type);
CREATE OR REPLACE FUNCTION update_reservation(
    datetimeupdated timestamp,
    idres int,
    nog int,
    request text,
    statusupdated status_type
)
    RETURNS boolean AS $$
BEGIN
 update public.reservations set
     status = statusupdated,
     number_of_guests = nog,
     special_requests = request ,
     datetime = datetimeupdated
    where id = idres
    and reservations.client = auth.id();

    RETURN FOUND;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION update_reservation(timestamp, int, int, text, status_type) TO authenticated;
