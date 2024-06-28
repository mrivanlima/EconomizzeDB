
\! chcp 65001
\! set PGCLIENTENCODING=UTF8
\! SET client_encoding = 'UTF8'



\i 'C:/Development/EconomizzeDB/Config.sql'

--For UTF character in the sql file
-- \! chcp 65001
-- \! set PGCLIENTENCODING=UTF8
-----------------------------------

\c economizze



\i 'C:/Development/EconomizzeDB/schemas.sql'
\i 'C:/Development/EconomizzeDB/extensions.sql'
\i 'C:/Development/EconomizzeDB/DropTable.sql'

--Add imp tables
\i 'C:/Development/EconomizzeDB/imp/zip_info.sql'


--Add app tables
\i 'C:/Development/EconomizzeDB/app/Tables/profession.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/professional.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/error_log.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/state.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/city.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/neighborhood.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/street.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/address.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/address_type.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/facility.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/user.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/user_login.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/user_token.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/user_address.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/drugstore.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/drugstore_neighborhood_subscription.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/quote.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/product.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/quote_product.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/role.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/user_role.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/group.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/user_group.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/product_version.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/quote_response.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/quote_product_response.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/contact_type.sql'
\i 'C:/Development/EconomizzeDB/app/Tables/prescription.sql'


--Add app functions

\i 'C:/Development/EconomizzeDB/app/Functions/drop_all_foreign_keys.sql'
\i 'C:/Development/EconomizzeDB/app/Functions/usp_api_state_read_all.sql'
\i 'C:/Development/EconomizzeDB/app/Functions/usp_api_state_read_by_id.sql'

--Add Stored Procedures

\i 'C:/Development/EconomizzeDB/app/StoredProcedures/drop_foreign_keys.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_api_address_create.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_api_address_type_create.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_api_city_create.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_api_drugstore_create.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_api_group_create.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_api_neighborhood_create.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_api_state_create.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_api_state_update_by_id.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_api_street_create.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_api_user_address_create.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_api_user_create.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_api_user_login_create.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_api_user_setup.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_city_import.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_neighborhood_import.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_seed.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_state_import.sql'
\i 'C:/Development/EconomizzeDB/app/StoredProcedures/usp_street_import.sql'

--Add Views

\i 'C:/Development/EconomizzeDB/app/Views/v_street_details.sql'
\i 'C:/Development/EconomizzeDB/app/Views/v_user_login_details.sql'

--Add Indexes
\i 'C:/Development/EconomizzeDB/app/Indexes/idx_street_zipcode.sql'
\i 'C:/Development/EconomizzeDB/app/Indexes/ix_userlogin_username.sql'


\i 'C:/Development/EconomizzeDB/seed.sql'

\c postgres
