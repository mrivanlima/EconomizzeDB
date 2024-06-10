CREATE INDEX ix_street_zipcode
ON app.street (zipcode)
INCLUDE (street_name, street_name_ascii, street_id);