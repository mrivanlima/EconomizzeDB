DROP PROCEDURE IF EXISTS app.usp_api_group_create;
CREATE OR REPLACE PROCEDURE app.usp_api_group_create(
    OUT p_out_group_id SMALLINT,
    IN p_group_name VARCHAR(50),
    IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE 
    v_group_name_ascii VARCHAR(50);
    l_context TEXT;
BEGIN
    BEGIN
        p_group_name := TRIM(p_group_name);
        v_group_name_ascii := unaccent(p_group_name);

        INSERT INTO app.group 
        (
            group_name,
            group_name_ascii,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_group_name,
            v_group_name_ascii,
            p_created_by,
            p_modified_by
        ) RETURNING group_id INTO p_out_group_id;

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