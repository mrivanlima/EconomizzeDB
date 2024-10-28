-- Drop procedure if it exists
DROP PROCEDURE IF EXISTS app.usp_api_prescription_create;

-- Create or replace stored procedure
CREATE OR REPLACE PROCEDURE app.usp_api_prescription_create(
    OUT p_out_prescription_id BIGINT,
    IN p_prescription_unique UUID,
    IN p_prescription_url VARCHAR(200),
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    IN p_facility_id INT DEFAULT NULL,
    IN p_professional_id INT DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE 
    l_context TEXT;
BEGIN
    BEGIN
        INSERT INTO app.prescription 
        (
            prescription_unique,
            presciption_url,
            facility_id,
            professional_id,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_prescription_unique,
            p_prescription_url,
            p_facility_id,
            p_professional_id,
            p_created_by,
            p_modified_by
        ) RETURNING prescription_id INTO p_out_prescription_id;

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