create or replace trigger client_b_d_restrict
  before delete on client
begin
  client_api_pack.check_client_delete_restriction();
end;
/
