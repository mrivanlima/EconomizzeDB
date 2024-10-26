DROP FUNCTION IF EXISTS app.usp_api_quote_read_by_id;

CREATE OR REPLACE FUNCTION app.usp_api_quote_read_by_id
(
    p_quote_id BIGINT
)
RETURNS SETOF app.quote AS $$
BEGIN
    RETURN QUERY
    SELECT quote_id,
           user_id,
           neighborhood_id,
           prescription_id,
           is_expired,
           created_by,
           created_on,
           modified_by,
           modified_on
    FROM app.quote
    WHERE quote_id = p_quote_id
    LIMIT 1;

END;
$$ LANGUAGE plpgsql;
