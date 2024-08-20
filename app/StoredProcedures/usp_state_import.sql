DROP PROCEDURE IF EXISTS app.usp_state_import;
CREATE PROCEDURE app.usp_state_import()
AS $$	
BEGIN	
	-- TRUNCATE TABLE app.state;
	-- ALTER SEQUENCE app.state_state_id_seq RESTART WITH 1;
	WITH states
	AS(
		SELECT DISTINCT
			z.state_abbrev AS state_uf,
			CASE 
				WHEN z.state_abbrev = 'AC' THEN 'Acre'
				WHEN z.state_abbrev = 'AL' THEN 'Alagoas'
				WHEN z.state_abbrev = 'AM' THEN 'Amazonas'
				WHEN z.state_abbrev = 'AP' THEN 'Amapá'
				WHEN z.state_abbrev = 'BA' THEN 'Bahia'
				WHEN z.state_abbrev = 'CE' THEN 'Ceará'
			    WHEN z.state_abbrev = 'DF' THEN 'Distrito Federal'
				WHEN z.state_abbrev = 'ES' THEN 'Espirito Santo'
				WHEN z.state_abbrev = 'GO' THEN 'Goiás'
				WHEN z.state_abbrev = 'MA' THEN 'Maranhão'
				WHEN z.state_abbrev = 'MG' THEN 'Minas Gerais'
				WHEN z.state_abbrev = 'MS' THEN 'Mato Grosso do Sul'
				WHEN z.state_abbrev = 'MT' THEN 'Mato Grosso'
				WHEN z.state_abbrev = 'PA' THEN 'Pará'
				WHEN z.state_abbrev = 'PB' THEN 'Paraiba'
			    WHEN z.state_abbrev = 'PE' THEN 'Pernambuco'
				WHEN z.state_abbrev = 'PI' THEN 'Piauí'
				WHEN z.state_abbrev = 'PR' THEN 'Paraná'
				WHEN z.state_abbrev = 'RJ' THEN 'Rio de Janeiro'
				WHEN z.state_abbrev = 'RN' THEN 'Rio Grande do Norte'
				WHEN z.state_abbrev = 'RR' THEN 'Roraima'
				WHEN z.state_abbrev = 'RS' THEN 'Rio Grande do Sul'
				WHEN z.state_abbrev = 'SC' THEN 'Santa Catarina'
				WHEN z.state_abbrev = 'SE' THEN 'Sergipe'
			    WHEN z.state_abbrev = 'SP' THEN 'São Paulo'
				WHEN z.state_abbrev = 'TO' THEN 'Tocantins'
			END AS state_name,
			NULLIF(trim(z.longitude), '') AS longitude,
			NULLIF(trim(z.latitude), '') AS latitude
		FROM imp.zip_info z
	)
	INSERT INTO app.state 
	(
		state_name, 
		state_name_ascii, 
		state_uf,
		longitude,
		latitude,
		created_by,
		modified_by
	)	
	SELECT 	state_name,
			unaccent(state_name),
			state_uf,
			AVG(longitude::double precision) AS longitude,
		    AVG(latitude::double precision) AS latitude,
			0,
			0
	FROM states
	WHERE state_uf = 'GO'
	GROUP BY state_name,
			 state_uf
	ORDER BY 1;
END;
$$ LANGUAGE plpgsql;