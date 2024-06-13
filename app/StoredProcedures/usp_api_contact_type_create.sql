DROP PROCEDURE IF EXISTS app.usp_api_contact_type_create;
CREATE OR REPLACE PROCEDURE app.usp_api_contact_type_create(
    OUT p_out_contact_type_id SMALLINT,
    OUT p_out_message VARCHAR(100),
    IN p_contact_type_name VARCHAR(20),
    IN p_contact_type_name_ascii VARCHAR(20),
    IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
BEGIN
    BEGIN
        -- Trim and process the contact type name
        p_contact_type_name := TRIM(p_contact_type_name);
        p_contact_type_name_ascii := TRIM(p_contact_type_name_ascii);

        -- Insert the new contact type record
        INSERT INTO app.contact_type 
        (
            contact_type_name,
            contact_type_name_ascii,
            created_by,
            created_on,
            modified_by,
            modified_on
        )
        VALUES 
        (
            p_contact_type_name,
            p_contact_type_name_ascii,
            p_created_by,
            current_timestamp,
            p_modified_by,
            current_timestamp
        ) RETURNING contact_type_id INTO p_out_contact_type_id;

        p_out_message := 'Insertion successful';
        p_error := FALSE;

    EXCEPTION
        WHEN OTHERS THEN
            p_error := TRUE;
            p_out_message := 'An error occurred, please try again!';
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
