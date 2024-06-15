
--Nome do medico ou outro profisiional
create table app.professional
(
    professional_id serial,
    profession_id smallint,
    professional_name varchar(200),
    professional_name_ascii varchar(20),
    counsel_number VARCHAR(10),
    created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_professional primary key (professional_id),
    constraint fk_professional_profession foreign key (profession_id) references app.profession(profession_id)
)