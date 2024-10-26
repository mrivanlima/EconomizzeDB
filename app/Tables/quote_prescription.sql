DROP TABLE IF EXISTS app.quote_prescription CASCADE;
CREATE TABLE IF NOT EXISTS app.quote_prescription
(
	quote_id bigint,
	prescription_id bigint,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_quote_prescription primary key (quote_id, prescription_id),
	constraint fk_quote_prescription_quote foreign key (quote_id) references app.quote(quote_id),
    constraint fk_quote_prescription_prescription foreign key (prescription_id) references app.prescription(prescription_id),
    constraint fk_quote_prescription_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_quote_prescription_modified_by foreign key (modified_by) references app.user_login(user_id)
);