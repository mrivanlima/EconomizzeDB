DROP PROCEDURE IF EXISTS app.usp_api_user_login_update_by_username_for_lock;
CREATE OR REPLACE PROCEDURE app.usp_api_user_login_update_by_username_for_lock(
    IN p_username varchar(100),
    IN p_password_attempts smallint,
    OUT p_error_message varchar(20),
    OUT p_error boolean
)
AS $$
DECLARE
    stored_procedure_name VARCHAR := 'usp_api_user_login_update_by_username_for_lock';
    v_is_locked BOOLEAN := false;
    l_context TEXT;
BEGIN

    -- Check if uuid exists
    IF NOT EXISTS (SELECT 1 FROM app.User_login WHERE username = p_username) THEN
        p_error_message := CONCAT(p_username, ' not found!');
        RETURN;
    END IF;

    p_password_attempts := p_password_attempts + 1;
    v_is_locked := CASE WHEN COALESCE(p_password_attempts, 0) > 3 
                            THEN true
                            ELSE false
                    END;

    -- Begin transaction
    BEGIN
        -- Update the state record
        UPDATE app.User_login
        SET password_attempts = p_password_attempts,
            is_locked = v_is_locked,
            modified_by = COALESCE(p_modified_by, modified_by),  -- Only update modified_by if provided
            modified_on = current_timestamp
        WHERE username = p_username;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN

            ROLLBACK;
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