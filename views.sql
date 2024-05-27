CREATE OR REPLACE VIEW app.v_street_details AS
SELECT s.street_id,
	   s.street_name,
       s.street_name_ascii,
	   s.zipcode,
       n.neighborhood_id,
       n.neighborhood_name,
       c.city_id,
       c.city_name,
       st.state_id,
       st.state_name
	   
FROM app.street s
JOIN app.neighborhood n
    ON n.neighborhood_id = s.neighborhood_id
JOIN app.city c
    ON c.city_id = n.city_id
JOIN app.state st
    ON st.state_id = c.state_id;