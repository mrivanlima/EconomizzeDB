DROP VIEW IF EXISTS app.v_user_address;
CREATE OR REPLACE VIEW app.v_user_address AS
SELECT  ua.user_id,
        ua.address_id,
        s.street_id,
        s.zipcode,
        a.complement

FROM app.user_address ua
JOIN app.address a
    ON a.address_id = ua.address_id
JOIN app.street s
    ON s.street_id = a.street_id