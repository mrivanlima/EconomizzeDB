-----------------------------------------------------------------
--Create procedure to drop all foreign keys
-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE app.drop_foreign_keys()
AS $$
DECLARE
    fk_record RECORD;
    drop_stmt TEXT;
BEGIN
    FOR fk_record IN (
        SELECT conrelid::regclass AS table_from,
               conname AS constraint_def
        FROM pg_constraint
        WHERE contype = 'f'
    )
    LOOP
        drop_stmt := 'ALTER TABLE ' || fk_record.table_from || ' DROP CONSTRAINT ' || quote_ident(fk_record.constraint_def);
        RAISE NOTICE 'Dropping FK %', drop_stmt;
        EXECUTE drop_stmt;
    END LOOP;    
END;
$$ LANGUAGE plpgsql;


-----------------------------------------------------------------
--Create procedure to add new user 
-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE app.usp_api_user_create(
    OUT p_out_user_id INTEGER,
    IN p_user_first_name VARCHAR(100),
    IN p_user_email VARCHAR(250),
    IN p_user_middle_name VARCHAR(100) DEFAULT NULL,
    IN p_user_last_name VARCHAR(100) DEFAULT NULL,
    IN p_cpf CHAR(11) DEFAULT NULL,
    IN p_rg VARCHAR(100) DEFAULT NULL,
    IN p_date_of_birth DATE DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
    l_error_line TEXT;
BEGIN
    p_user_first_name := TRIM(p_user_first_name);
    p_user_middle_name := TRIM(p_user_middle_name);
    p_user_last_name := TRIM(p_user_last_name);
    p_user_email := TRIM(p_user_email);
    p_cpf := TRIM(p_cpf);
    p_rg := TRIM(p_rg);
   
    BEGIN
        -- Check for existing email
        SELECT user_id INTO p_out_user_id
        FROM app.user
        WHERE user_email = p_user_email; 

        IF p_out_user_id IS NOT NULL THEN
            RAISE NOTICE 'Usuario encontrado!';
            RETURN;
        END IF;

        -- Check CPF length
        IF p_cpf IS NOT NULL AND LENGTH(p_cpf) < 11 THEN
            RAISE EXCEPTION 'CPF deve ser de 11 caracteres.';
        END IF;

        -- Insert new user
        INSERT INTO app.user
        (
            user_first_name,
            user_middle_name,
            user_last_name,
            user_email,
            cpf,
            rg,
            date_of_birth
        ) 
        VALUES 
        (
            p_user_first_name,
            p_user_middle_name,
            p_user_last_name,
            p_user_email,
            p_cpf,
            p_rg,
            p_date_of_birth
        ) RETURNING user_id INTO p_out_user_id;  

        EXCEPTION
        WHEN OTHERS THEN
            p_error := TRUE;
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT, l_error_line = PG_EXCEPTION_DETAIL;
            INSERT INTO app.error_log 
            (
                error_message, 
                error_code, 
                error_line
            )
            VALUES 
            (
                SQLERRM, 
                SQLSTATE, 
                l_error_line
            );
    END;  
END;
$$ LANGUAGE plpgsql;


-----------------------------------------------------------------
--Create procedure to add new user login
-----------------------------------------------------------------

CREATE OR REPLACE PROCEDURE app.usp_api_user_login_create(
    IN p_user_id INTEGER,
    IN p_username VARCHAR(100),
    IN p_password_hash VARCHAR(100),
    IN p_password_salt VARCHAR(100),
    IN p_is_verified BOOLEAN DEFAULT FALSE,
    IN p_is_active BOOLEAN DEFAULT FALSE,
    IN p_is_locked BOOLEAN DEFAULT FALSE,
    IN p_password_attempts SMALLINT DEFAULT 0,
    IN p_changed_initial_password BOOLEAN DEFAULT FALSE,
    IN p_locked_time TIMESTAMPTZ DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
BEGIN
    BEGIN
        p_username := TRIM(p_username);

        SELECT user_id INTO p_out_user_id
        FROM app.user_login
        WHERE username = p_username; 

        IF p_out_user_id IS NOT NULL THEN
            RAISE NOTICE 'Email encontrado!';
            RETURN;
        END IF;
        -- Insert the new user login record into the app.user_login table
        INSERT INTO app.user_login (
            user_id,
            username,
            password_hash,
            password_salt,
            is_verified,
            is_active,
            is_locked,
            password_atempts,
            changed_initial_password,
            locked_time,
            created_by,
            created_on,
            modified_by,
            modified_on
        )
        VALUES 
        (
            p_user_id,
            p_username,
            p_password_hash,
            p_password_salt,
            COALESCE(p_is_verified, FALSE),
            COALESCE(p_is_active, FALSE),
            COALESCE(p_is_locked, FALSE),
            COALESCE(p_password_attempts, 0),
            p_changed_initial_password,
            p_locked_time,
            p_created_by,
            DEFAULT,  -- Use default for created_on
            p_modified_by,
            DEFAULT   -- Use default for modified_on
        );

        EXCEPTION
        WHEN OTHERS THEN
            p_error := TRUE;
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
            INSERT INTO app.error_log 
            (
                error_message, 
                error_code, 
                error_line
            )
            VALUES 
            (
                SQLERRM, 
                SQLSTATE, 
                l_context
            );
    END;
END;
$$ LANGUAGE plpgsql;


-----------------------------------------------------------------
--Create procedure to set up user
-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE app.usp_api_user_setup(
    OUT v_out_user_id INTEGER,
    IN p_user_first_name VARCHAR(100),
    IN p_user_email VARCHAR(250),
    IN p_username VARCHAR(100),
    IN p_email VARCHAR(200),
    IN p_password_hash VARCHAR(100),
    IN p_password_salt VARCHAR(100),
    IN p_user_middle_name VARCHAR(100) DEFAULT NULL,
    IN p_user_last_name VARCHAR(100) DEFAULT NULL,
    IN p_cpf CHAR(11) DEFAULT NULL,
    IN p_rg VARCHAR(100) DEFAULT NULL,
    IN p_date_of_birth DATE DEFAULT NULL,
    IN p_is_verified BOOLEAN DEFAULT FALSE,
    IN p_is_active BOOLEAN DEFAULT FALSE,
    IN p_is_locked BOOLEAN DEFAULT FALSE,
    IN p_password_attempts SMALLINT DEFAULT 0,
    IN p_changed_initial_password BOOLEAN DEFAULT FALSE,
    IN p_locked_time TIMESTAMPTZ DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
BEGIN
    CALL app.usp_api_user_create
    (
        p_out_user_id := v_out_user_id,
        p_user_first_name := p_user_first_name,
        p_user_email := p_user_email,
        p_user_middle_name := p_user_middle_name,
        p_user_last_name := p_user_last_name,
        p_cpf := p_cpf,
        p_rg := p_rg,
        p_date_of_birth := p_date_of_birth ,
        p_error := p_error
    );

    IF NOT p_error THEN
        CALL app.usp_api_user_login_create
        (
            p_user_id := v_out_user_id,
            p_username := p_username,
            p_password_hash := p_password_hash,
            p_password_salt := p_password_salt,
            p_is_verified := p_is_verified,
            p_is_active := p_is_active,
            p_is_locked := p_is_locked,
            p_password_attempts := p_password_attempts,
            p_changed_initial_password := p_changed_initial_password,
            p_locked_time := p_locked_time,
            p_created_by := p_created_by,
            p_modified_by := p_modified_by,
            p_error := p_error
        );
    END IF;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE app.usp_api_state_create(
    OUT p_out_state_id SMALLINT,
    IN p_state_name VARCHAR(50),
    IN p_state_uf CHAR(2),
    IN p_longitude DOUBLE PRECISION DEFAULT NULL,
    IN p_latitude DOUBLE PRECISION DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE 
        V_state_name_ascii VARCHAR(50);
        l_context TEXT;
BEGIN
    BEGIN

    p_state_name := TRIM(p_state_name);
    v_state_name_ascii := unaccent(p_state_name);

        INSERT INTO app.state 
        (
            state_name,
            state_uf,
            state_name_ascii,
            longitude,
            latitude,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_state_name,
            p_state_uf,
            v_state_name_ascii,
            p_longitude,
            p_latitude,
            p_created_by,
            p_modified_by
        ) RETURNING state_id INTO p_out_state_id;


        EXCEPTION
            WHEN OTHERS THEN
                p_error := TRUE;
                GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
                INSERT INTO app.error_log 
                (
                    error_message, 
                    error_code, 
                    error_line
                )
                VALUES 
                (
                    SQLERRM, 
                    SQLSTATE, 
                    l_context
                );
    END;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE app.usp_api_city_create(
    OUT p_out_city_id INTEGER,
    IN p_city_name VARCHAR(50),
    IN p_state_id SMALLINT,
    IN p_longitude DOUBLE PRECISION DEFAULT NULL,
    IN p_latitude DOUBLE PRECISION DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    v_city_name_ascii VARCHAR(50);
    l_context TEXT;
BEGIN
    BEGIN
        -- Trim and convert the city name to ASCII
        p_city_name := TRIM(p_city_name);
        v_city_name_ascii := unaccent(p_city_name);

        -- Insert the new city record
        INSERT INTO app.city 
        (
            city_name,
            city_name_ascii,
            longitude,
            latitude,
            state_id,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_city_name,
            v_city_name_ascii,
            p_longitude,
            p_latitude,
            p_state_id,
            p_created_by,
            p_modified_by
        ) RETURNING city_id INTO p_out_city_id;

        EXCEPTION
            WHEN OTHERS THEN
                p_error := TRUE;
                GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
                INSERT INTO app.error_log 
                (
                    error_message, 
                    error_code, 
                    error_line
                )
                VALUES 
                (
                    SQLERRM, 
                    SQLSTATE, 
                    l_context
                );
    END;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE app.usp_api_neighborhood_create(
    OUT p_out_neighborhood_id INTEGER,
    IN p_neighborhood_name VARCHAR(50),
    IN p_city_id SMALLINT,
    IN p_longitude DOUBLE PRECISION DEFAULT NULL,
    IN p_latitude DOUBLE PRECISION DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    v_neighborhood_name_ascii VARCHAR(50);
    l_context TEXT;
BEGIN
    BEGIN
        -- Trim and convert the neighborhood name to ASCII
        p_neighborhood_name := TRIM(p_neighborhood_name);
        v_neighborhood_name_ascii := unaccent(p_neighborhood_name);

        -- Insert the new neighborhood record
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
        VALUES 
        (
            p_neighborhood_name,
            v_neighborhood_name_ascii,
            p_longitude,
            p_latitude,
            p_city_id,
            p_created_by,
            p_modified_by
        ) RETURNING neighborhood_id INTO p_out_neighborhood_id;

        EXCEPTION
            WHEN OTHERS THEN
                p_error := TRUE;
                GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
                INSERT INTO app.error_log 
                (
                    error_message, 
                    error_code, 
                    error_line
                )
                VALUES 
                (
                    SQLERRM, 
                    SQLSTATE, 
                    l_context
                );
    END;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE app.usp_api_street_create(
    OUT p_out_street_id INTEGER,
    IN p_street_name VARCHAR(50),
    IN p_zipcode CHAR(8),
    IN p_neighborhood_id INTEGER,
    IN p_longitude DOUBLE PRECISION DEFAULT NULL,
    IN p_latitude DOUBLE PRECISION DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    v_street_name_ascii VARCHAR(50);
    l_context TEXT;
BEGIN
    BEGIN
        -- Trim and convert the street name to ASCII
        p_street_name := TRIM(p_street_name);
        v_street_name_ascii := unaccent(p_street_name);

        -- Insert the new street record
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
        VALUES 
        (
            p_street_name,
            v_street_name_ascii,
            p_zipcode,
            p_longitude,
            p_latitude,
            p_neighborhood_id,
            p_created_by,
            p_modified_by
        ) RETURNING street_id INTO p_out_street_id;

        EXCEPTION
            WHEN OTHERS THEN
                p_error := TRUE;
                GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
                INSERT INTO app.error_log 
                (
                    error_message, 
                    error_code, 
                    error_line
                )
                VALUES 
                (
                    SQLERRM, 
                    SQLSTATE, 
                    l_context
                );
    END;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE app.usp_api_address_create(
    OUT p_out_address_id INTEGER,
    IN p_street_id INTEGER,
    IN p_complement VARCHAR(200),
    IN p_longitude DOUBLE PRECISION DEFAULT NULL,
    IN p_latitude DOUBLE PRECISION DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    v_complement_ascii VARCHAR(200);
    l_context TEXT;
BEGIN
    BEGIN
        -- Trim and convert the complement to ASCII
        p_complement := TRIM(p_complement);
        v_complement_ascii := unaccent(p_complement);

        -- Insert the new address record
        INSERT INTO app.address 
        (
            street_id,
            complement,
            complement_ascii,
            longitude,
            latitude,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_street_id,
            p_complement,
            v_complement_ascii,
            p_longitude,
            p_latitude,
            p_created_by,
            p_modified_by
        ) RETURNING address_id INTO p_out_address_id;

    EXCEPTION
        WHEN OTHERS THEN
            p_error := TRUE;
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
            INSERT INTO app.error_log 
            (
                error_message, 
                error_code, 
                error_line
            )
            VALUES 
            (
                SQLERRM, 
                SQLSTATE, 
                l_context
            );
    END;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE app.usp_api_address_type_create(
    OUT p_out_address_type_id INTEGER,
    IN p_address_type_name VARCHAR(20),
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    v_address_type_name_ascii VARCHAR(20);
    l_context TEXT;
BEGIN
    BEGIN
        -- Trim and convert the address type name to ASCII
        p_address_type_name := TRIM(p_address_type_name);
        v_address_type_name_ascii := unaccent(p_address_type_name);

        -- Insert the new address type record
        INSERT INTO app.address_type 
        (
            address_type_name,
            address_type_name_ascii,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_address_type_name,
            v_address_type_name_ascii,
            p_created_by,
            p_modified_by
        ) RETURNING address_type_id INTO p_out_address_type_id;

        EXCEPTION
            WHEN OTHERS THEN
                p_error := TRUE;
                GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
                INSERT INTO app.error_log 
                (
                    error_message, 
                    error_code, 
                    error_line
                )
                VALUES 
                (
                    SQLERRM, 
                    SQLSTATE, 
                    l_context
                );
    END;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE app.usp_api_user_address_create(
    IN p_user_id INTEGER,
    IN p_address_id INTEGER,
    IN p_address_type_id SMALLINT,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
BEGIN
    BEGIN
        -- Insert the new user address record
        INSERT INTO app.user_address 
        (
            user_id,
            address_id,
            address_type_id,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_user_id,
            p_address_id,
            p_address_type_id,
            p_created_by,
            p_modified_by
        );

        EXCEPTION
            WHEN OTHERS THEN
                p_error := TRUE;
                GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
                INSERT INTO app.error_log 
                (
                    error_message, 
                    error_code, 
                    error_line
                )
                VALUES 
                (
                    SQLERRM, 
                    SQLSTATE, 
                    l_context
                );
    END;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE app.usp_api_state_update_by_id(
    IN p_state_id INTEGER,
    IN p_state_name VARCHAR,
    IN p_state_name_ascii VARCHAR,
    IN p_state_uf CHAR(2),
    IN p_longitude DOUBLE PRECISION,
    IN p_latitude DOUBLE PRECISION,
    IN p_modified_by INTEGER,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    stored_procedure_name VARCHAR := 'usp_api_state_update_by_id';
    error_message VARCHAR;
    warning_message VARCHAR;
    l_context TEXT;
BEGIN
    -- Trim the state name
    p_state_name := TRIM(p_state_name);
    p_state_name_ascii := unaccent(TRIM(p_state_name));
    p_state_uf := TRIM(p_state_uf);

    -- Check if the state exists
    IF NOT EXISTS (SELECT 1 FROM app.state WHERE state_id = p_state_id) THEN
        error_message := CONCAT(p_state_id, ' not found!');
        RAISE EXCEPTION USING MESSAGE = error_message, ERRCODE = '50005';
    END IF;

    -- Begin transaction
    BEGIN
        -- Update the state record
        UPDATE app.state
        SET state_name = p_state_name,
            state_name_ascii = p_state_name_ascii,
            state_uf = p_state_uf,
            longitude = p_longitude,
            latitude = p_latitude,
            modified_by = COALESCE(p_modified_by, modified_by),  -- Only update modified_by if provided
            modified_on = current_timestamp
        WHERE state_id = p_state_id;

        -- Notify successful update
        RAISE NOTICE '% updated successfully!', p_state_name;
    EXCEPTION
        WHEN OTHERS THEN
            p_error := TRUE;
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
            -- Ensure the error_log table exists and is properly structured
            INSERT INTO app.error_log 
            (
                error_message, 
                error_code, 
                error_context
            )
            VALUES 
            (
                SQLERRM, 
                SQLSTATE, 
                l_context
            );
            -- Re-raise the exception to ensure the error is propagated
            RAISE;
    END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE app.usp_state_import()
AS $$	
BEGIN	
	TRUNCATE TABLE app.state;
	ALTER SEQUENCE app.state_state_id_seq RESTART WITH 1;
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
	GROUP BY state_name,
			 state_uf
	ORDER BY 1;
END;
$$ LANGUAGE plpgsql;

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

CREATE OR REPLACE PROCEDURE app.usp_api_address_create(
    OUT p_out_address_id INTEGER,
    IN p_street_id INTEGER,
    IN p_complement VARCHAR(200),
    IN p_complement_ascii VARCHAR(200),
	IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    IN p_longitude DOUBLE PRECISION DEFAULT NULL,
    IN p_latitude DOUBLE PRECISION DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
    l_error_line TEXT;
BEGIN
    p_complement := TRIM(p_complement);
    p_complement_ascii := unnacent(TRIM(p_complement_ascii));

    BEGIN
        -- Insert new address
        INSERT INTO app.address
        (
            street_id,
            complement,
            complement_ascii,
            longitude,
            latitude,
            created_by,
            modified_by
        )
        VALUES
        (
            p_street_id,
            p_complement,
            p_complement_ascii,
            p_longitude,
            p_latitude,
            p_created_by,
            p_modified_by
        ) RETURNING address_id INTO p_out_address_id;

    EXCEPTION
    WHEN OTHERS THEN
        p_error := TRUE;
        GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT, l_error_line = PG_EXCEPTION_DETAIL;
        INSERT INTO app.error_log
        (
            error_message,
            error_code,
            error_line
        )
        VALUES
        (
            SQLERRM,
            SQLSTATE,
            l_error_line
        );
    END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE app.usp_api_drugstore_create(
    OUT p_out_drugstore_id INTEGER,
    IN p_drugstore_name VARCHAR(200),
    IN p_drugstore_name_ascii VARCHAR(200),
    IN p_address_id INTEGER,
    IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
    l_error_line TEXT;
BEGIN
    p_drugstore_name := TRIM(p_drugstore_name);
    p_drugstore_name_ascii := unnacent(TRIM(p_drugstore_name_ascii));

    BEGIN
        -- Insert new drugstore
        INSERT INTO app.drugstore
        (
            drugstore_name,
            dugrstore_name_ascii,
            address_id,
            created_by,
            modified_by
        )
        VALUES
        (
            p_drugstore_name,
            p_drugstore_name_ascii,
            p_address_id,
            p_created_by,
            p_modified_by
        ) RETURNING drugstore_id INTO p_out_drugstore_id;

    EXCEPTION
    WHEN OTHERS THEN
        p_error := TRUE;
        GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT, l_error_line = PG_EXCEPTION_DETAIL;
        INSERT INTO app.error_log
        (
            error_message,
            error_code,
            error_line
        )
        VALUES
        (
            SQLERRM,
            SQLSTATE,
            l_error_line
        );
    END;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE app.usp_seed()
AS $$	
BEGIN
	CALL app.usp_state_import();
	CALL app.usp_city_import();
	CALL app.usp_neighborhood_import();
	CALL app.usp_street_import();
END;
$$ LANGUAGE plpgsql;










