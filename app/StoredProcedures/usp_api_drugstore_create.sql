DROP PROCEDURE IF EXISTS app.usp_api_drugstore_create;
CREATE OR REPLACE PROCEDURE app.usp_api_drugstore_create(
    OUT p_out_drugstore_id INTEGER,
    IN p_drugstore_name VARCHAR(200),
    IN p_drugstore_name_ascii VARCHAR(200),
    IN p_address_id INTEGER,
    IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
    l_error_line TEXT;
BEGIN
    p_drugstore_name := TRIM(p_drugstore_name);
    p_drugstore_name_ascii := unnacent(TRIM(p_drugstore_name_ascii));

    BEGIN
        -- Insert new drugstore
        INSERT INTO app.drugstore
        (
            drugstore_name,
            dugrstore_name_ascii,
            address_id,
            created_by,
            modified_by
        )
        VALUES
        (
            p_drugstore_name,
            p_drugstore_name_ascii,
            p_address_id,
            p_created_by,
            p_modified_by
        ) RETURNING drugstore_id INTO p_out_drugstore_id;

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