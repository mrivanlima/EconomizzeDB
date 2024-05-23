-----------------------------------------------------------------
--Create procedure to drop all foreign keys
-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE app.drop_foreign_keys()
AS $$
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
        RAISE NOTICE 'Dropping FK %', drop_stmt;
        EXECUTE drop_stmt;
    END LOOP;    
END;
$$ LANGUAGE plpgsql;


-----------------------------------------------------------------
--Create procedure to add new user 
-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE app.usp_api_user_create(
    OUT p_out_user_id INTEGER,
    IN p_user_first_name VARCHAR(100),
    IN p_user_middle_name VARCHAR(100) DEFAULT NULL,
    IN p_user_last_name VARCHAR(100) DEFAULT NULL,
    IN p_cpf CHAR(11) DEFAULT NULL,
    IN p_rg VARCHAR(100) DEFAULT NULL,
    IN p_date_of_birth DATE DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
BEGIN
    p_user_first_name := TRIM(p_user_first_name);
    p_user_middle_name := TRIM(p_user_middle_name);
    p_user_last_name := TRIM(p_user_last_name);
    p_cpf := TRIM(p_cpf);
    p_rg := TRIM(p_rg);
   
    BEGIN
        IF p_cpf IS NOT NULL AND LENGTH(p_cpf) < 11 THEN
            RAISE EXCEPTION 'cpf deve ser de 11 caracteres.';
        END IF;

        INSERT INTO app.user
        (
            user_first_name,
            user_middle_name,
            user_last_name,
            cpf,
            rg,
            date_of_birth
        ) 
        VALUES 
        (
            p_user_first_name,
            p_user_middle_name,
            p_user_last_name,
            p_cpf,
            p_rg,
            p_date_of_birth
        ) RETURNING user_id INTO p_out_user_id;  

    EXCEPTION
        WHEN OTHERS THEN
            p_error := TRUE;
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
            INSERT INTO app.error_log 
            (
                error_message, 
                error_code, 
                error_line
            )
            VALUES 
            (
                SQLERRM, 
                SQLSTATE, 
                l_context
            );
    END;  
END;
$$ LANGUAGE plpgsql;


-----------------------------------------------------------------
--Create procedure to add new user login
-----------------------------------------------------------------

CREATE OR REPLACE PROCEDURE app.usp_user_login_create(
    IN p_user_id INTEGER,
    IN p_username VARCHAR(100),
    IN p_email VARCHAR(200),
    IN p_password_hash VARCHAR(100),
    IN p_password_salt VARCHAR(100),
    IN p_is_verified BOOLEAN DEFAULT FALSE,
    IN p_is_active BOOLEAN DEFAULT FALSE,
    IN p_is_locked BOOLEAN DEFAULT FALSE,
    IN p_password_attempts SMALLINT DEFAULT 0,
    IN p_changed_initial_password BOOLEAN DEFAULT FALSE,
    IN p_locked_time TIMESTAMPTZ DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
BEGIN
    BEGIN
        p_username := TRIM(p_username);
        p_email := TRIM(p_email);
        -- Insert the new user login record into the app.user_login table
        INSERT INTO app.user_login (
            user_id,
            username,
            email,
            password_hash,
            password_salt,
            is_verified,
            is_active,
            is_locked,
            password_atempts,
            changed_initial_password,
            locked_time,
            created_by,
            created_on,
            modified_by,
            modified_on
        )
        VALUES 
        (
            p_user_id,
            p_username,
            p_email,
            p_password_hash,
            p_password_salt,
            COALESCE(p_is_verified, FALSE),
            COALESCE(p_is_active, FALSE),
            COALESCE(p_is_locked, FALSE),
            COALESCE(p_password_attempts, 0),
            p_changed_initial_password,
            p_locked_time,
            p_created_by,
            DEFAULT,  -- Use default for created_on
            p_modified_by,
            DEFAULT   -- Use default for modified_on
        );

        EXCEPTION
        WHEN OTHERS THEN
            p_error := TRUE;
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
            INSERT INTO app.error_log 
            (
                error_message, 
                error_code, 
                error_line
            )
            VALUES 
            (
                SQLERRM, 
                SQLSTATE, 
                l_context
            );
    END;
END;
$$ LANGUAGE plpgsql;


-----------------------------------------------------------------
--Create procedure to set up user
-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE app.usp_api_user_setup()