CREATE OR REPLACE FUNCTION signup(email text, password text, full_name text, phone text DEFAULT NULL)
RETURNS void AS $$
BEGIN
    INSERT INTO users (email, password, full_name, phone)
    VALUES (email, password, full_name, phone);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION signup(text, text, text, text) TO anon;

CREATE OR REPLACE FUNCTION is_email_available(email text)
    RETURNS boolean AS $$
BEGIN
RETURN NOT EXISTS(SELECT 1 FROM users WHERE trim(lower(users.email)) = trim(lower(is_email_available.email)));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_full_name_available(full_name text)
    RETURNS boolean AS $$
BEGIN
    RETURN NOT EXISTS(SELECT 1 FROM users WHERE trim(lower(users.full_name)) = trim(lower(is_full_name_available.full_name)));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION signup(email text, password text, full_name text, phone text DEFAULT NULL)
    RETURNS void AS $$
BEGIN
INSERT INTO users (email, password, full_name, phone)
VALUES (email, password, full_name, phone);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION is_full_name_available(text) TO anon;
GRANT EXECUTE ON FUNCTION signup(text, text, text, text) TO anon;
GRANT EXECUTE ON FUNCTION is_email_available(text) TO anon;