-- Drop procedure if it exists
DROP PROCEDURE IF EXISTS app.usp_api_product_version_create;

-- Create or replace stored procedure
CREATE OR REPLACE PROCEDURE app.usp_api_product_version_create(
    OUT p_out_product_version_id SMALLINT,
    IN p_product_version_name VARCHAR(20),
    IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE 
    v_product_version_ascii VARCHAR(20);
    l_context TEXT;
BEGIN
    BEGIN
        p_product_version_name := TRIM(p_product_version_name);
        v_product_version_ascii := unaccent(p_product_version_name);

        INSERT INTO app.product_version 
        (
            product_version_name,
            product_version_ascii,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_product_version_name,
            v_product_version_ascii,
            p_created_by,
            p_modified_by
        ) RETURNING product_version_id INTO p_out_product_version_id;

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