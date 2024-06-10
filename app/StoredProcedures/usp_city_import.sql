DROP PROCEDURE IF EXISTS app.usp_city_import;
CREATE OR REPLACE PROCEDURE app.usp_city_import()
AS $$	
BEGIN

	TRUNCATE TABLE app.city;
	ALTER SEQUENCE app.city_city_id_seq RESTART WITH 1;
	
	INSERT INTO app.City
	(
		city_name,
		city_name_ascii,
		longitude,
		latitude,
		state_id,
		created_by,
		modified_by
	)
	
	SELECT DISTINCT
		 z.city_name
		,unaccent(z.city_name)
		,AVG(NULLIF(TRIM(z.longitude), '')::double precision) AS longitude
		,AVG(NULLIF(TRIM(z.latitude), '')::double precision) AS latitude
		,s.state_id
		,0
		,0
	FROM imp.zip_info z
		JOIN app.state s
			ON s.state_uf = TRIM(z.state_abbrev)
	
	GROUP BY 
	 z.city_name
	,unaccent(z.city_name)
	,s.state_id;
END;
$$ LANGUAGE plpgsql;