create or replace trigger client_b_d_restrict
  before delete on client
begin
  raise_application_error(client_api_pack.e_manual_change_code,
                          client_api_pack.c_manual_delete_code_msg);
end;
/
