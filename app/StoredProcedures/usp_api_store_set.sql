
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
FROM  app.store_json aj
where store_cnpj = '15.029.651/0001-81'
AND NOT EXISTS (SELECT * FROM app.store s2 where s2.cnpj = aj.store_cnpj)
RETURNING store_id;


DO $$
DECLARE
    new_store_id INTEGER;
BEGIN
    -- Insert into the store table and return the newly inserted store_id
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
        WHERE store_cnpj = '15.029.651/0001-81'
        RETURNING store_id
    )
    SELECT store_id INTO new_store_id FROM inserted_store;


    -- Output the new store_id for debugging
    RAISE NOTICE 'New store_id: %', new_store_id;

    -- Use PERFORM instead of SELECT to avoid the error
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
    select 
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

	from app.store_json aj
	    JOIN app.street s
	        ON s.zipcode = aj.store_json->'estabelecimento'->>'cep'
	 WHERE aj.store_cnpj = '15.029.651/0001-81';

   

END $$;



   --store_json->>'razao_social' AS "Razao Social",
    store_json->'estabelecimento'->>'nome_fantasia' AS "Nome Fantasia",
    store_json->'estabelecimento'->>'cep' AS "Cep",
    store_json->'estabelecimento'->>'numero' AS "Numero",
    store_json->'estabelecimento'->>'complemento' AS "Complemento",
    store_json->'estabelecimento'->>'telefone1' AS "Telefone 1",
    store_json->'estabelecimento'->>'telefone2' AS "Telefone 2"--,
    --store_json->'estabelecimento'->>'cnpj' AS "CNPJ",
    --store_json->>'cnpj_raiz' AS "CNPJ Raiz",
    --store_json->'estabelecimento'->>'cnpj_ordem' AS "CNPJ Ordem",
    --store_json->'estabelecimento'->>'cnpj_digito_verificador' AS "CNPJ Digito Verificador",
    --store_json->'estabelecimento'->>'email' AS "Email",
    --store_json->'estabelecimento'->'inscricoes_estaduais'->0->>'inscricao_estadual' AS "Inscrição Estadual",
    --store_json->'estabelecimento'->'atividade_principal'->>'descricao' AS "Atividade Principal"
FROM  app.store_json
where store_cnpj = '15.029.651/0001-81'
;