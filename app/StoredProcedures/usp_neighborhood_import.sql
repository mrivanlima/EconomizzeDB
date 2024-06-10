DROP PROCEDURE IF EXISTS app.usp_neighborhood_import;
CREATE OR REPLACE PROCEDURE app.usp_neighborhood_import()
AS $$	
BEGIN

	TRUNCATE TABLE app.neighborhood;
	ALTER SEQUENCE app.neighborhood_neighborhood_id_seq RESTART WITH 1;

	INSERT INTO app.neighborhood
	(
		neighborhood_name,
		neighborhood_name_ascii,
		longitude,
		latitude,
		city_id,
		created_by,
		modified_by
	)
	SELECT DISTINCT
			 z.neighborhood
			,unaccent(z.neighborhood)
			,AVG(NULLIF(TRIM(z.longitude), '')::double precision) AS longitude
			,AVG(NULLIF(TRIM(z.latitude), '')::double precision) AS latitude
			,ci.city_id
			,0
			,0
	
			
		FROM imp.zip_info z
			JOIN app.city ci
				ON ci.city_name = z.city_name
			JOIN App.State s
				ON s.state_uf = TRIM(z.state_abbrev)
				AND s.state_id = ci.state_id
		
		GROUP BY 
			 ci.city_id
			,z.neighborhood;
END;
$$ LANGUAGE plpgsql;