create or replace trigger client_b_d_restrict
  before delete on client
begin
  raise_application_error(client_api_pack.c_error_code_delete_forbidden,
                          client_api_pack.c_error_msg_delete_forbidden);
end;
/
