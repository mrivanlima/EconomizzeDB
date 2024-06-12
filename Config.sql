
DROP DATABASE IF EXISTS economizze;
CREATE DATABASE EXISTS economizze
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

DROP DATABASE IF EXISTS appuser;
CREATE USER appuser WITH PASSWORD 'app';
GRANT ALL PRIVILEGES ON DATABASE Economizze TO appuser;     