DROP PROCEDURE IF EXISTS app.usp_api_state_create;
CREATE OR REPLACE PROCEDURE app.usp_api_state_create(
    OUT p_out_state_id SMALLINT,
    IN p_state_name VARCHAR(50),
    IN p_state_uf CHAR(2),
    IN p_longitude DOUBLE PRECISION DEFAULT NULL,
    IN p_latitude DOUBLE PRECISION DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE 
        V_state_name_ascii VARCHAR(50);
        l_context TEXT;
BEGIN
    BEGIN

    p_state_name := TRIM(p_state_name);
    v_state_name_ascii := unaccent(p_state_name);

        INSERT INTO app.state 
        (
            state_name,
            state_uf,
            state_name_ascii,
            longitude,
            latitude,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_state_name,
            p_state_uf,
            v_state_name_ascii,
            p_longitude,
            p_latitude,
            p_created_by,
            p_modified_by
        ) RETURNING state_id INTO p_out_state_id;


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