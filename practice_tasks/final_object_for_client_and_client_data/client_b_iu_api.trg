create or replace trigger client_b_iu_api
  before insert or update on client
begin
  client_api_pack.is_changes_through_api(); -- проверяем выполняется ли изменение через API
end;
/
