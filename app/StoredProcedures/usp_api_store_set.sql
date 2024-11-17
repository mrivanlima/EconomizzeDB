
DROP PROCEDURE IF EXISTS app.usp_api_store_set;
CREATE OR REPLACE PROCEDURE app.usp_api_store_set 
(
	OUT out_storeId INT,
	IN  in_cnpj VARCHAR(20),
	OUT p_error BOOLEAN
)
AS $$
DECLARE 
    v_product_version_ascii VARCHAR(20);
    l_context TEXT;
BEGIN
	BEGIN
	    WITH inserted_store AS (
	        INSERT INTO app.store
	        (
	            store_type_id,
	            store_unique_id,
	            cnpj,
	            store_name,
	            store_name_ascii,
	            is_active,
	            created_by,
	            created_on,
	            modified_by,
	            modified_on
	        )
	        SELECT 
	            1 as store_type_id,
	            gen_random_uuid() as store_unique_id,
	            store_cnpj,
	            store_json->'estabelecimento'->>'nome_fantasia' as store_name,
	            unaccent(store_json->'estabelecimento'->>'nome_fantasia') as store_name_ascii,
	            true as is_active,
	            0 as created_by,
	            NOW() as created_on,
	            0 as modified_by,
	            NOW() AS modified_on
	        FROM app.store_json aj
	        WHERE store_cnpj = in_cnpj
	        RETURNING store_id
	    )
	    SELECT store_id 
		INTO out_storeId 
		FROM inserted_store;
	
		INSERT INTO app.store_address 
		(
	        store_id,
	        street_id,
			number,
			complement,
			complement_ascii,
			longitude,
			latitude,
			created_by,
			created_on,
			modified_by,
			modified_on
	    )
	    SELECT 
		    new_store_id,
			s.street_id,
			aj.store_json->'estabelecimento'->>'numero' AS "Numero",
			aj.store_json->'estabelecimento'->>'complemento' AS "Complemento",
			unaccent(aj.store_json->'estabelecimento'->>'complemento') AS "Complemento_ascii",
			0 as longitude,
			0 as latitude,
			0 as created_by,
			NOW() as created_on,
			0 as modified_by,
			NOW() as modified_on
	
		FROM app.store_json aj
		    JOIN app.street s
		        ON s.zipcode = aj.store_json->'estabelecimento'->>'cep'
		 WHERE aj.store_cnpj = in_cnpj;
	
		INSERT INTO app.store_phone
		(
		    store_id,
		    country_code,
		    state_code,
		    phone_number,
		    is_main,
		    is_active,
		    is_whatsapp,
		    created_by,
		    created_on,
		    modified_by,
		    modified_on
	    )
		SELECT 
			 new_store_id,
			'55' as country_code,
			store_json->'estabelecimento'->>'ddd1' AS ddd,
			'' || (store_json->'estabelecimento'->>'ddd1')::TEXT || '' || (store_json->'estabelecimento'->>'telefone1')::TEXT AS phone_number,
			true as is_main,
			true as is_active,
			true as is_whatsapp,
			0 as created_by,
			now() as created_on,
			0 as modified_by,
			now() as modified_on
		FROM app.store_json aj
		WHERE aj.store_cnpj = in_cnpj
		
		UNION
		
		SELECT 
			new_store_id,
			'55' as country_code,
			store_json->'estabelecimento'->>'ddd2' AS ddd,
			'' || (store_json->'estabelecimento'->>'ddd2')::TEXT || '' || (store_json->'estabelecimento'->>'telefone2')::TEXT AS phone_number,
			true as is_main,
			true as is_active,
			true as is_whatsapp,
			0 as created_by,
			now() as created_on,
			0 as modified_by,
			now() as modified_on
		FROM app.store_json aj
		WHERE aj.store_cnpj = in_cnpj; 

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
END $$
LANGUAGE plpgsql;
