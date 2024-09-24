DROP PROCEDURE IF EXISTS app.usp_api_user_login_update_password;
CREATE OR REPLACE PROCEDURE app.usp_api_user_login_update_password(
    OUT p_out_message VARCHAR(100),
    IN p_user_id INTEGER,
    IN p_password_hash VARCHAR(100),
	IN p_password_salt VARCHAR(100),
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    stored_procedure_name VARCHAR := 'usp_api_user_login_update_password';
    l_context TEXT;
BEGIN

    -- Check if uuid exists
    IF NOT EXISTS (SELECT 1 FROM app.User_login WHERE user_id = p_user_id) THEN
        p_out_message := CONCAT(p_user_id, ' not found!');
        RETURN;
    END IF;

    -- Begin transaction
    BEGIN
        -- Update the state record
        UPDATE app.User_login
        SET password_attempts = 0,
            password_hash = p_password_hash,
            password_salt = p_password_salt,
            modified_by = COALESCE(p_modified_by, modified_by),  -- Only update modified_by if provided
            modified_on = current_timestamp
        WHERE user_id = p_user_id;

    EXCEPTION
        WHEN OTHERS THEN

            p_error := TRUE;
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
            -- Ensure the error_log table exists and is properly structured
            INSERT INTO app.error_log 
            (
                error_message, 
                error_code, 
                error_context
            )
            VALUES 
            (
                SQLERRM, 
                SQLSTATE, 
                l_context
            );
            -- Re-raise the exception to ensure the error is propagated
            RAISE;
    END;
END;
$$ LANGUAGE plpgsql;