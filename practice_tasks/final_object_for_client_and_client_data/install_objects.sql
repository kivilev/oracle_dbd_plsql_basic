-- Скрипт установки объектов в схему
spool install_objectsq.log
spool on

prompt ======================================================
prompt ===== INSTALL OBJECTS FOR CLIENT, CLIENT_DATA
prompt ======================================================

prompt ==== Types...
@@t_client_data.tps
@@t_client_data_array.tps
@@t_number_array.tps

prompt ==== Packages...
@@common_pack.pks
@@client_data_api_pack.pks
@@client_api_pack.pks

prompt ==== Package bodies...
@@client_api_pack.pkb
@@client_data_api_pack.pkb
@@common_pack.pkb

prompt ==== Triggers...
@@client_b_d_restrict.trg
@@client_b_iu_api.trg
@@client_b_iu_tech_fields.trg
@@client_data_b_iu_api.trg


prompt ==== Ut objects...

@@ut_common_pack.pks
@@ut_client_api_pack.pks
@@ut_client_data_api_pack.pks
@@ut_utils_pack.pks

@@ut_client_api_pack.pkb
@@ut_client_data_api_pack.pkb
@@ut_common_pack.pkb
@@ut_utils_pack.pkb

