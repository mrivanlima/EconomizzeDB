
--Clinica, hospital, etc
create table app.facility
(
    facility_id serial,
    facility_name varchar(100),
    facility_name_ascii varchar(100),
    address_id int,
    created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_facility primary key (facility_id),
    constraint uk_facility_name_asci unique (facility_name_ascii),
    constraint fk_facility_address foreign key (address_id) references app.address(address_id),
    constraint fk_facility_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_facility_modified_by foreign key (modified_by) references app.user_login(user_id)
);
