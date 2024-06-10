DROP PROCEDURE IF EXISTS app.usp_api_street_create;
CREATE OR REPLACE PROCEDURE app.usp_api_street_create(
    OUT p_out_street_id INTEGER,
    IN p_street_name VARCHAR(50),
    IN p_zipcode CHAR(8),
    IN p_neighborhood_id INTEGER,
    IN p_longitude DOUBLE PRECISION DEFAULT NULL,
    IN p_latitude DOUBLE PRECISION DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    v_street_name_ascii VARCHAR(50);
    l_context TEXT;
BEGIN
    BEGIN
        -- Trim and convert the street name to ASCII
        p_street_name := TRIM(p_street_name);
        v_street_name_ascii := unaccent(p_street_name);

        -- Insert the new street record
        INSERT INTO app.street 
        (
            street_name,
            street_name_ascii,
            zipcode,
            longitude,
            latitude,
            neighborhood_id,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_street_name,
            v_street_name_ascii,
            p_zipcode,
            p_longitude,
            p_latitude,
            p_neighborhood_id,
            p_created_by,
            p_modified_by
        ) RETURNING street_id INTO p_out_street_id;

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