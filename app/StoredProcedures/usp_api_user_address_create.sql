
DROP PROCEDURE IF EXISTS app.usp_api_user_address_create;
CREATE OR REPLACE PROCEDURE app.usp_api_user_address_create(
    IN p_user_id INTEGER,
    IN p_street_id INTEGER,
    IN p_complement VARCHAR(256),
    IN p_address_type_id SMALLINT,
    OUT p_out_address_id INTEGER,
    IN p_longitude DOUBLE PRECISION DEFAULT NULL,
    IN p_latitude DOUBLE PRECISION DEFAULT NULL,
    IN p_main_address	BOOLEAN DEFAULT false, 
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
	p_out_message VARCHAR(100);
BEGIN
    BEGIN

        IF EXISTS (
                    SELECT 1 
                    FROM app.user_address 
                    WHERE user_id = p_user_id
                    AND address_type_id = p_address_type_id
                    AND street_id = p_street_id
                ) THEN
	        p_out_message := 'Usuario com esse endereco ja registrado!';
            p_error := true;
            RETURN;
    	END IF;
        
        CALL app.usp_api_address_create
        (
            p_out_address_id => p_out_address_id,
            p_out_message => p_out_message,
            p_street_id => p_street_id,
            p_complement => p_complement,
            p_longitude => p_longitude,
            p_latitude => p_latitude,
            p_created_by => p_created_by,
            p_modified_by => p_created_by,
            p_error => p_error
        );

        INSERT INTO app.user_address 
        (
            user_id,
            street_id,
            address_id,
            address_type_id,
            main_address,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_user_id,
            p_street_id,
            p_out_address_id,
            p_address_type_id,
            p_main_address,
            p_created_by,
            p_modified_by
        );

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
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
            RAISE;
    END;
END;
$$
LANGUAGE plpgsql;