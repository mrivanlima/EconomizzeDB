
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
    constraint fk_facility_address foreign key (address_id) references app.address(address_id)
)