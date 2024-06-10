DROP PROCEDURE IF EXISTS app.usp_api_city_create;
CREATE OR REPLACE PROCEDURE app.usp_api_city_create(
    OUT p_out_city_id INTEGER,
    IN p_city_name VARCHAR(50),
    IN p_state_id SMALLINT,
    IN p_longitude DOUBLE PRECISION DEFAULT NULL,
    IN p_latitude DOUBLE PRECISION DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    v_city_name_ascii VARCHAR(50);
    l_context TEXT;
BEGIN
    BEGIN
        -- Trim and convert the city name to ASCII
        p_city_name := TRIM(p_city_name);
        v_city_name_ascii := unaccent(p_city_name);

        -- Insert the new city record
        INSERT INTO app.city 
        (
            city_name,
            city_name_ascii,
            longitude,
            latitude,
            state_id,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_city_name,
            v_city_name_ascii,
            p_longitude,
            p_latitude,
            p_state_id,
            p_created_by,
            p_modified_by
        ) RETURNING city_id INTO p_out_city_id;

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