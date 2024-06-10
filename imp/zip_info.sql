create table if not exists imp.zip_info (
    zip_id serial,
    city_name text,
    ibge text,
    ddd text,
    state_abbrev text,
    altitude text,
    longitude text,
    neighborhood text,
    complement text,
    zip_code text,
    details text,
    latitude text,
	constraint pk_imp_cep primary key (zip_id)
);
