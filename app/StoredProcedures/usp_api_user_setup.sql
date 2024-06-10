-----------------------------------------------------------------
--Create procedure to set up user
-----------------------------------------------------------------
DROP PROCEDURE IF EXISTS app.usp_api_user_setup;
CREATE OR REPLACE PROCEDURE app.usp_api_user_setup(
	OUT p_out_user_id INTEGER,
	OUT p_out_message VARCHAR(100),
    IN p_user_first_name VARCHAR(100),
    IN p_user_email VARCHAR(250),
	IN p_username VARCHAR(100),
    IN p_password_hash VARCHAR(100),
    IN p_password_salt VARCHAR(100),
    IN p_user_middle_name VARCHAR(100) DEFAULT NULL,
    IN p_user_last_name VARCHAR(100) DEFAULT NULL,
    IN p_cpf CHAR(11) DEFAULT NULL,
    IN p_rg VARCHAR(100) DEFAULT NULL,
    IN p_date_of_birth DATE DEFAULT NULL,
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
    l_error_line TEXT;
    L_procedure_name TEXT := 'usp_api_user_setup';	
BEGIN

	BEGIN

		IF EXISTS (SELECT 1 FROM app.user WHERE user_email = p_user_email) THEN
		        p_out_message := 'Email ja cadastrado!';
		        RAISE EXCEPTION USING MESSAGE = p_out_message;
		ELSEIF EXISTS (SELECT 1 FROM app.user_login WHERE username = p_username) THEN
		        p_out_message := 'Usuario encontrado!';
		        RAISE EXCEPTION USING MESSAGE = p_out_message;
	    END IF;
	
		
	    CALL app.usp_api_user_create(
	        p_out_user_id := p_out_user_id,
	        p_out_message := p_out_message,
	        p_user_first_name := p_user_first_name,
	        p_user_email := p_user_email,
	        p_user_middle_name := p_user_middle_name,
	        p_user_last_name := p_user_last_name,
	        p_cpf := p_cpf,
	        p_rg := p_rg,
	        p_date_of_birth := p_date_of_birth,
	        p_error := p_error
	    );
	
	    IF NOT p_error THEN
	        CALL app.usp_api_user_login_create(
		        p_user_id := p_out_user_id,
		        p_out_message := p_out_message,
		        p_username := p_username,
		        p_password_hash := p_password_hash,
		        p_password_salt := p_password_salt,
		        p_is_verified := p_is_verified,
		        p_is_active := p_is_active,
		        p_is_locked := p_is_locked,
		        p_password_attempts := p_password_attempts,
		        p_changed_initial_password := p_changed_initial_password,
		        p_locked_time := p_locked_time,
		        p_created_by := p_created_by,
		        p_modified_by := p_modified_by,
		        p_error := p_error
			);
	    END IF;
	EXCEPTION
        WHEN OTHERS THEN
            p_error := TRUE;
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT, l_error_line = PG_EXCEPTION_DETAIL;
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
                l_error_line
            );
    END;  

END;
$$ LANGUAGE plpgsql;