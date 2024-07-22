
DROP TYPE IF EXISTS app.state_record;
CREATE TYPE app.state_record AS 
(
    state_id smallint,
    state_name varchar(50),
    longitude double precision,
    latitude double precision,
    state_uf char(2)
)

