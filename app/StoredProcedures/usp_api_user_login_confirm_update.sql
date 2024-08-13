-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS app.usp_api_user_login_confirm_update;

-- Create or replace the procedure
CREATE OR REPLACE PROCEDURE app.usp_api_user_login_confirm_update(
    IN p_user_unique_id UUID,
    OUT p_out_message VARCHAR(100),
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
    v_user_login_id INT;
BEGIN
    BEGIN
        -- Check if the user with the given user_unique_id exists
        IF NOT EXISTS (SELECT 1 FROM app.user_login WHERE user_unique_id = p_user_unique_id) THEN
            p_out_message := 'User not found!';
            p_error := TRUE;
            RETURN;
        END IF;

        v_user_login_id := (SELECT user_id FROM app.user_login WHERE user_unique_id = p_user_unique_id);
        -- Update the user record to set is_verified to true
        UPDATE app.user_login
        SET is_verified = TRUE,
            modified_by = v_user_login_id,  -- Optionally, you can set this to the ID of the user making the change
            modified_on = CURRENT_TIMESTAMP
        WHERE user_unique_id = p_user_unique_id;

        -- Set output message
        p_out_message := 'User verification updated successfully.';
        
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
            p_out_message := 'Error occurred during user verification update.';
    END;
END;
$$ LANGUAGE plpgsql;
