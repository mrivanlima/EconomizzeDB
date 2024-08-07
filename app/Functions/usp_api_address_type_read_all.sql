CREATE OR REPLACE FUNCTION app.usp_api_address_type_read_all()
RETURNS SETOF app.address_type
AS $$
BEGIN
    RETURN QUERY
    SELECT address_type_id,
           address_type_name,
           address_type_name_ascii,
           created_by,
           created_on,
           modified_by,
           modified_on
    FROM app.address_type;
END;
$$ LANGUAGE plpgsql;

