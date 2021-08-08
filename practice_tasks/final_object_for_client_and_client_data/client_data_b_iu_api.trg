create or replace trigger client_data_b_iu_api
  before insert or update on client_data
begin
  client_data_api_pack.is_changes_through_api(); -- проверяем выполняется ли изменение через API
end;
/
