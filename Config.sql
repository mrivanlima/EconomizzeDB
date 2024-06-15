
DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'economizze') THEN
      
    CREATE DATABASE economizze
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

   END IF;
END
$$ LANGUAGE plpgsql;
    

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'appuser') THEN
      CREATE USER appuser WITH PASSWORD 'app';
      GRANT ALL PRIVILEGES ON DATABASE Economizze TO appuser;   
   END IF;
END
$$ LANGUAGE plpgsql;


  
