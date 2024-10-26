-- Drop procedure if it exists
DROP PROCEDURE IF EXISTS app.usp_api_quote_prescription_create;

-- Create or replace stored procedure
CREATE OR REPLACE PROCEDURE app.usp_api_quote_prescription_create(
    IN p_prescription_id BIGINT,
    IN p_quote_id BIGINT,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE 
    l_context TEXT;
BEGIN
    BEGIN
        INSERT INTO app.quote_prescription 
        (
            prescription_id,
            quote_id,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_prescription_id,
            p_quote_id,
            p_created_by,
            p_modified_by
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
$$
LANGUAGE plpgsql;