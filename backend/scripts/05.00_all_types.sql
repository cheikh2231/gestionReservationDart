DROP TYPE IF EXISTS user_info CASCADE;
DROP TYPE IF EXISTS restaurant_info CASCADE;
DROP TYPE IF EXISTS table_info CASCADE;
DROP TYPE IF EXISTS last_reservation_info CASCADE;
DROP TYPE IF EXISTS service_info CASCADE;

CREATE TYPE user_info AS (
    id          integer,
    full_name   text,
    email       text,
    phone       text,
    role        role_type
);
CREATE TYPE restaurant_info AS (
    id            integer,
    name          varchar,
    address       varchar,
    city          varchar,
    phone         varchar,
    description   text,
    rating        double precision,
    price_range   int,
    slot_duration int
);
CREATE TYPE table_info AS (
    id           integer,
    restaurant   integer,
    table_number integer,
    capacity     integer
);

CREATE TYPE last_reservation_info AS (
    id               integer,
    datetime         timestamp
);


CREATE TYPE service_info AS (
    id int,
    restaurant int,
    day_of_week int,
    start_time time,
    end_time time
);


DROP TYPE IF EXISTS reservation_info CASCADE;
DROP TYPE IF EXISTS restaurant_full_info CASCADE;

CREATE TYPE reservation_info AS (
    id               integer,
    client           user_info,
    restaurant       restaurant_info,
    datetime         timestamp,
    number_of_guests integer,
    status           status_type,
    special_requests text,
    tables           table_info[]
);

CREATE TYPE restaurant_full_info AS (
    restaurant           restaurant_info,
    last_reservation     last_reservation_info,
    nb_pending           integer
);
