DROP PROCEDURE IF EXISTS app.usp_api_neighborhood_create;
CREATE OR REPLACE PROCEDURE app.usp_api_neighborhood_create(
    OUT p_out_neighborhood_id INTEGER,
    IN p_neighborhood_name VARCHAR(50),
    IN p_city_id SMALLINT,
    IN p_longitude DOUBLE PRECISION DEFAULT NULL,
    IN p_latitude DOUBLE PRECISION DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    v_neighborhood_name_ascii VARCHAR(50);
    l_context TEXT;
BEGIN
    BEGIN
        -- Trim and convert the neighborhood name to ASCII
        p_neighborhood_name := TRIM(p_neighborhood_name);
        v_neighborhood_name_ascii := unaccent(p_neighborhood_name);

        -- Insert the new neighborhood record
        INSERT INTO app.neighborhood 
        (
            neighborhood_name,
            neighborhood_name_ascii,
            longitude,
            latitude,
            city_id,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_neighborhood_name,
            v_neighborhood_name_ascii,
            p_longitude,
            p_latitude,
            p_city_id,
            p_created_by,
            p_modified_by
        ) RETURNING neighborhood_id INTO p_out_neighborhood_id;

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