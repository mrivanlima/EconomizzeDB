--Medico, dentista, etc
create table app.profession
(
    profession_id smallserial,
    profession_name varchar(20),
    profession_name_ascii varchar(20),
    created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_profession primary key (profession_id)
)