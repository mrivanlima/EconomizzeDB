-- Drop procedure if it exists
DROP PROCEDURE IF EXISTS app.usp_api_product_create;

-- Create or replace stored procedure
CREATE OR REPLACE PROCEDURE app.usp_api_product_create(
    OUT p_out_product_id INTEGER,
    IN p_product_name VARCHAR(200),
    IN p_product_concentration VARCHAR(20),
    IN p_product_quantity SMALLINT,
    IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE 
    v_product_name_ascii VARCHAR(200);
    l_context TEXT;
BEGIN
    BEGIN
        p_product_name := TRIM(p_product_name);
        v_product_name_ascii := unaccent(p_product_name);

        INSERT INTO app.product 
        (
            product_name,
            product_name_ascii,
            product_concentration,
            product_quantity,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_product_name,
            v_product_name_ascii,
            p_product_concentration,
            p_product_quantity,
            p_created_by,
            p_modified_by
        ) RETURNING product_id INTO p_out_product_id;

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