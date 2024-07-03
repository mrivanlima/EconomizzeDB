DROP PROCEDURE IF EXISTS app.usp_api_facility_create;

-- Create or replace stored procedure
CREATE OR REPLACE PROCEDURE app.usp_api_facility_create(
    OUT p_out_facility_id INTEGER,
    IN p_facility_name VARCHAR(100),
    IN p_address_id INT,
    IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE 
    v_facility_name_ascii VARCHAR(100);
    l_context TEXT;
BEGIN
    BEGIN
        p_facility_name := TRIM(p_facility_name);
        v_facility_name_ascii := unaccent(p_facility_name);

        INSERT INTO app.facility 
        (
            facility_name,
            facility_name_ascii,
            address_id,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_facility_name,
            v_facility_name_ascii,
            p_address_id,
            p_created_by,
            p_modified_by
        ) RETURNING facility_id INTO p_out_facility_id;

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