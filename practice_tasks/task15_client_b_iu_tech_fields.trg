create or replace trigger client_b_iu_tech_fields
  before insert or update on client
  for each row
declare
  v_current_timestamp client.create_dtime_tech%type := systimestamp;
begin
  if inserting then
    :new.create_dtime_tech := v_current_timestamp;
  end if;
  :new.update_dtime_tech := v_current_timestamp;
end;
/
