
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