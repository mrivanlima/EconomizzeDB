drop table if exists app.error_log cascade;
drop table if exists app.state cascade;
drop table if exists app.city cascade;
drop table if exists app.neighborhood cascade;
drop table if exists app.street cascade;
drop table if exists app.address cascade;
drop table if exists app.address_type cascade;
drop table if exists app.user cascade;
drop table if exists app.user_login cascade;
drop table if exists app.user_token cascade;
drop table if exists app.user_address cascade;
drop table if exists app.drugstore cascade;
drop table if exists app.drugstore_neighborhood_subscription cascade;
drop table if exists app.quote cascade;
drop table if exists app.product cascade;
drop table if exists app.quote_product cascade;
drop table if exists app.role cascade;
drop table if exists app.user_role cascade;
drop table if exists app.group cascade;
drop table if exists app.user_group cascade;
drop table if exists app.product_version cascade;
drop table if exists app.quote_response cascade;
drop table if exists app.quote_product_response cascade;
drop table if exists app.contact_type cascade;
drop table if exists app.profession cascade;
drop table if exists app.facility cascade;
drop table if exists app.professional cascade;
drop table if exists app.prescription cascade;
drop table if exists app.prescription cascade;
drop table if exists app.user_password_reset cascade;
drop table if exists app.store cascade;
drop table if exists app.store_type cascade;
drop table if exists app.store_json cascade;
drop table if exists app.store_address cascade;
drop table if exists app.store_phone cascade;
DROP TABLE IF EXISTS app.quote_prescription CASCADE;
-- drop table if exists app.conformity cascade;
-- drop table if exists app.presentation cascade;





DROP FUNCTION IF EXISTS app.usp_api_state_read_by_id;
DROP FUNCTION IF EXISTS app.usp_api_state_read_all();
