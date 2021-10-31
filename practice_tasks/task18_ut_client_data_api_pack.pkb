create or replace package body ut_client_data_api_pack is

  procedure insert_or_update_client_data is
    v_client_id        client.client_id%type;
    v_phone            client_data.field_value%type := ut_common_pack.get_random_client_mobile_phone();
    v_inn              client_data.field_value%type := ut_common_pack.get_random_client_inn();
    v_client_data      t_client_data_array := t_client_data_array(t_client_data(ut_common_pack.c_client_mobile_phone_id,
                                                                                v_phone),
                                                                  t_client_data(ut_common_pack.c_client_inn_id,
                                                                                v_inn));
    v_phone_after_test client_data.field_value%type;
    v_inn_after_test   client_data.field_value%type;
  
  begin
    -- setup
    v_client_id := ut_common_pack.create_default_client();
  
    -- вызов тестируемой функции
    client_data_api_pack.insert_or_update_client_data(p_client_id   => v_client_id,
                                                      p_client_data => v_client_data);
  
    -- получаем данные    
    v_phone_after_test := ut_common_pack.get_client_field_value(v_client_id,
                                                                ut_common_pack.c_client_mobile_phone_id);
    v_inn_after_test   := ut_common_pack.get_client_field_value(v_client_id,
                                                                ut_common_pack.c_client_inn_id);
  
    -- проверяем условие теста  
    if v_phone != v_phone_after_test
       or v_inn != v_inn_after_test then
      ut_common_pack.ut_failed();
    end if;
  
  end;

  procedure delete_client_data is
    v_client_id        client.client_id%type;
    v_delete_field_ids t_number_array := t_number_array(ut_common_pack.c_client_mobile_phone_id,
                                                        ut_common_pack.c_client_inn_id);
    v_phone_after_test client_data.field_value%type;
    v_inn_after_test   client_data.field_value%type;
  begin
    -- setup
    v_client_id := ut_common_pack.create_default_client();
  
    -- вызов тестируемой функции
    client_data_api_pack.delete_client_data(p_client_id        => v_client_id,
                                            p_delete_field_ids => v_delete_field_ids);
  
    -- получаем данные  
    v_phone_after_test := ut_common_pack.get_client_field_value(v_client_id,
                                                                ut_common_pack.c_client_mobile_phone_id);
    v_inn_after_test   := ut_common_pack.get_client_field_value(v_client_id,
                                                                ut_common_pack.c_client_inn_id);
    -- проверяем условие теста
    if v_phone_after_test is not null
       or v_inn_after_test is not null then
      ut_common_pack.ut_failed();
    end if;
  
  end;

  procedure update_client_data_with_direct_dml_and_enabled_manual_change is
  begin
    common_pack.enable_manual_changes();
  
    -- выполняем операцию
    update client_data cl
       set cl.field_value = cl.field_value
     where cl.client_id = ut_common_pack.c_non_existing_client_id;
  
    common_pack.disable_manual_changes();
  
  exception
    when others then
      common_pack.disable_manual_changes();
      raise;
  end;
  
  
  procedure insert_client_data_with_empty_array_leads_to_error is
    v_client_data t_client_data_array;
    v_client_id client.client_id%type;             
  begin
    -- setup
    v_client_id := ut_common_pack.create_default_client();
      
    client_data_api_pack.insert_or_update_client_data(p_client_id => v_client_id, p_client_data => v_client_data);
  
    ut_common_pack.ut_failed();
  exception
    when common_pack.e_invalid_input_parameter then
      null;
  end;

  procedure delete_client_data_with_empty_array_leads_to_error is
    v_client_id   client.client_id%type;
    v_client_data t_client_data_array;
  begin
    -- setup
    v_client_id := ut_common_pack.create_default_client();
  
    -- вызов тестируемой функции
    client_data_api_pack.insert_or_update_client_data(p_client_id   => v_client_id,
                                                      p_client_data => v_client_data);
  
    ut_common_pack.ut_failed();
  exception
    when common_pack.e_invalid_input_parameter then
      null;
  end;

  procedure direct_insert_client_data_leads_to_error is
    v_client_id client.client_id%type := ut_common_pack.c_non_existing_client_id;
    v_field_id  client_data.field_id%type := ut_common_pack.c_client_field_email_id;
  begin
    insert into client_data
      (client_id
      ,field_id
      ,field_value)
    values
      (v_client_id
      ,v_field_id
      ,null);
  
    ut_common_pack.ut_failed();
  exception
    when common_pack.e_manual_changes then
      null;
  end;

  procedure direct_update_client_data_leads_to_error is
    v_client_id client.client_id%type := ut_common_pack.c_non_existing_client_id;
  begin
    update client_data cl
       set cl.field_value = cl.field_value
     where cl.client_id = v_client_id;
  
    ut_common_pack.ut_failed();
  exception
    when common_pack.e_manual_changes then
      null;
  end;

end ut_client_data_api_pack;
/
