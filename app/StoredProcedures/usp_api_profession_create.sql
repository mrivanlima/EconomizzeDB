DROP PROCEDURE IF EXISTS app.usp_api_profession_create;
CREATE OR REPLACE PROCEDURE app.usp_api_profession_create(
    OUT p_out_profession_id SMALLINT,
    IN p_profession_name VARCHAR(20),
    IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE 
    v_profession_name_ascii VARCHAR(20);
    l_context TEXT;
BEGIN
    BEGIN
        p_profession_name := TRIM(p_profession_name);
        v_profession_name_ascii := unaccent(p_profession_name);

        INSERT INTO app.profession 
        (
            profession_name,
            profession_name_ascii,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_profession_name,
            v_profession_name_ascii,
            p_created_by,
            p_modified_by
        ) RETURNING profession_id INTO p_out_profession_id;

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