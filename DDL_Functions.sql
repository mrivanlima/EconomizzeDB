CREATE OR REPLACE FUNCTION drop_all_foreign_keys() RETURNS VOID AS $$
DECLARE
    fk_record RECORD;
    drop_stmt TEXT;
BEGIN
    FOR fk_record IN (
        SELECT conrelid::regclass AS table_from,
               conname AS constraint_def
        FROM pg_constraint
        WHERE contype = 'f'
    )
    LOOP
        drop_stmt := 'ALTER TABLE ' || fk_record.table_from || ' DROP CONSTRAINT ' || quote_ident(fk_record.constraint_def);
        raise notice 'Droping FK %', drop_stmt;
        EXECUTE drop_stmt;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION app.usp_api_state_read_by_id(
    p_state_id SMALLINT
)
RETURNS TABLE (
    out_state_name VARCHAR(50),
    out_longitude DOUBLE PRECISION,
    out_latitude DOUBLE PRECISION,
    out_state_uf CHAR(2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT state_name, 
           longitude,
           latitude,
           state_uf
    FROM app.state
    WHERE state_id = p_state_id
	LIMIT 1;
END;
$$ LANGUAGE plpgsql;