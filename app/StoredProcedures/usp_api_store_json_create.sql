DROP PROCEDURE IF EXISTS app.usp_api_store_json_create;
CREATE OR REPLACE PROCEDURE app.usp_api_store_json_create(
    P_store_cnpj VARCHAR(100),
    p_store_json JSONB,
    p_created_by int
)
LANGUAGE plpgsql
AS $$
DECLARE
    l_context TEXT;
BEGIN

    BEGIN
        -- Insert a new record into the table
        INSERT INTO app.store_json (
            store_cnpj,
            store_json, 
            created_by, 
            modified_by
        )
        VALUES (
            P_store_cnpj,
            p_store_json, 
            p_created_by, 
            p_created_by 
        
        );

        EXCEPTION
            WHEN OTHERS THEN
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
$$;
