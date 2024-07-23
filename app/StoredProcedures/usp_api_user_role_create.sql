-----------------------------------------------------------------
--Create procedure to add new user role
-----------------------------------------------------------------
DROP PROCEDURE IF EXISTS app.usp_api_user_role_create;
CREATE OR REPLACE PROCEDURE app.usp_api_user_role_create(
    OUT p_out_message VARCHAR(100),
    IN p_role_id SMALLINT,
    IN p_user_id INTEGER,
    IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    IN p_is_active BOOLEAN DEFAULT TRUE,
    IN p_role_start_date TIMESTAMPTZ DEFAULT NULL,
    IN p_role_end_date TIMESTAMPTZ DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
BEGIN
    BEGIN
        -- Check if the role and user combination already exists
        IF EXISTS (SELECT 1 FROM app.user_role WHERE role_id = p_role_id AND user_id = p_user_id) THEN
            p_out_message := 'User role already exists!';
            p_error := TRUE;
            RETURN;
        END IF;

        -- Insert the new user role record into the app.user_role table
        INSERT INTO app.user_role (
            role_id,
            user_id,
            is_active,
            role_start_date,
            role_end_date,
            created_by,
            created_on,
            modified_by,
            modified_on
        )
        VALUES 
        (
            p_role_id,
            p_user_id,
            COALESCE(p_is_active, TRUE),
            p_role_start_date,
            p_role_end_date,
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
