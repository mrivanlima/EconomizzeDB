DROP TYPE IF EXISTS app.user_record;
CREATE TYPE app.user_record AS 
(
    user_id integer,
    user_first_name varchar(100),
    user_middle_name varchar(100),
    user_last_name varchar(100),
    cpf char(11),
    rg  varchar(100),
    date_of_birth date
)  