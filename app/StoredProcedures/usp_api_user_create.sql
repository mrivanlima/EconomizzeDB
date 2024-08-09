-----------------------------------------------------------------
--Create procedure to add new user 
-----------------------------------------------------------------
DROP PROCEDURE IF EXISTS app.usp_api_user_create;
CREATE OR REPLACE PROCEDURE app.usp_api_user_create(
    IN p_user_id INTEGER,
	OUT p_out_message VARCHAR(100),
    IN p_user_first_name VARCHAR(100),
    IN p_user_middle_name VARCHAR(100) DEFAULT NULL,
    IN p_user_last_name VARCHAR(100) DEFAULT NULL,
    IN p_phone_number VARCHAR(15) DEFAULT NULL,
    IN p_cpf CHAR(11) DEFAULT NULL,
    IN p_rg VARCHAR(100) DEFAULT NULL,
    IN p_date_of_birth DATE DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
    l_error_line TEXT;
    L_procedure_name TEXT := 'usp_api_user_create';
	-- l_is_match BOOLEAN := p_cpf ~ '^([-\.\s]?(\d{3})){3}[-\.\s]?(\d{2})$';
BEGIN
    p_user_first_name := TRIM(p_user_first_name);
    p_user_middle_name := TRIM(p_user_middle_name);
    p_user_last_name := TRIM(p_user_last_name);
    p_user_email := TRIM(p_user_email);
    p_phone_number := TRIM(p_phone_number);
    p_cpf := TRIM(p_cpf);
    p_rg := TRIM(p_rg);
   
    BEGIN

        -- Insert new user
        INSERT INTO app.user
        (
            user_id,
            user_first_name,
            user_middle_name,
            user_last_name,
            cpf,
            rg,
            phone_number,
            date_of_birth
        ) 
        VALUES 
        (
            p_user_id,
            p_user_first_name,
            p_user_middle_name,
            p_user_last_name,
            p_cpf,
            p_rg,
            p_phone_number,
            p_date_of_birth
        );  

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