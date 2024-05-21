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