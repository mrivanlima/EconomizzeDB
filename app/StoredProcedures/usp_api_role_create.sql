-- Drop procedure if it exists
DROP PROCEDURE IF EXISTS app.usp_api_role_create;

-- Create or replace stored procedure
CREATE OR REPLACE PROCEDURE app.usp_api_role_create(
    OUT p_out_role_id SMALLINT,
    IN p_role_name VARCHAR(50),
    IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE 
    v_role_name_ascii VARCHAR(50);
    l_context TEXT;
BEGIN
    BEGIN
        p_role_name := TRIM(p_role_name);
        v_role_name_ascii := unaccent(p_role_name);

        INSERT INTO app.role 
        (
            role_name,
            role_name_ascii,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_role_name,
            v_role_name_ascii,
            p_created_by,
            p_modified_by
        ) RETURNING role_id INTO p_out_role_id;

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
$$
LANGUAGE plpgsql;
