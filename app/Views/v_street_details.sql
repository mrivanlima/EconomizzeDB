DROP VIEW IF EXISTS app.v_street_details;
CREATE OR REPLACE VIEW app.v_street_details AS
SELECT s.street_id,
	   s.street_name,
       s.street_name_ascii,
	   s.zipcode,
       n.neighborhood_name,
       n.neighborhood_id,
       c.city_name,
       st.state_name
	   
FROM app.street s
JOIN app.neighborhood n
    ON n.neighborhood_id = s.neighborhood_id
JOIN app.city c
    ON c.city_id = n.city_id
JOIN app.state st
    ON st.state_id = c.state_id;