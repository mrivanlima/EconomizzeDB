DROP PROCEDURE IF EXISTS app.usp_seed;
CREATE OR REPLACE PROCEDURE app.usp_seed()
AS $$	
BEGIN
	CALL app.usp_state_import();
	CALL app.usp_city_import();
	CALL app.usp_neighborhood_import();
	CALL app.usp_street_import();
END;
$$ LANGUAGE plpgsql;