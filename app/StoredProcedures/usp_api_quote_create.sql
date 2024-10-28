-- Drop procedure if it exists
DROP PROCEDURE IF EXISTS app.usp_api_quote_create;

-- Create or replace stored procedure
CREATE OR REPLACE PROCEDURE app.usp_api_quote_create(
    OUT p_out_quote_id BIGINT,
    OUT p_out_message VARCHAR(100),
    IN p_user_id INTEGER,
    IN p_neighborhood_id INTEGER,
    IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE 
    l_context TEXT;
BEGIN
    BEGIN
        -- Insert into the quote table
        INSERT INTO app.quote 
        (
            user_id,
            neighborhood_id,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_user_id,
            p_neighborhood_id,
            p_created_by,
            p_modified_by
        ) RETURNING quote_id INTO p_out_quote_id;

    EXCEPTION
        WHEN OTHERS THEN
            p_error := TRUE;
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
            -- Log the error in the error_log table
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
