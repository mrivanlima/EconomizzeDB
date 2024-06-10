DROP PROCEDURE IF EXISTS app.usp_street_import;
CREATE OR REPLACE PROCEDURE app.usp_street_import()
AS $$	
BEGIN
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
	SELECT DISTINCT
		z.details,
		unaccent(z.details),
		z.zip_code,
		AVG(NULLIF(TRIM(z.longitude), '')::double precision) AS longitude,
		AVG(NULLIF(TRIM(z.latitude), '')::double precision) AS latitude,
		n.neighborhood_id,
		0,
		0
	FROM imp.zip_info z
		JOIN app.neighborhood n
			ON n.neighborhood_name = z.neighborhood
		JOIN app.city ci
			ON ci.city_id = n.city_id
			AND ci.city_name = z.city_name
		JOIN app.state s
			ON s.state_uf = TRIM(z.state_abbrev)
			AND s.state_id = ci.state_id
	GROUP BY n.neighborhood_id,
		     z.details,
		     z.zip_code;
END;
$$ LANGUAGE plpgsql;