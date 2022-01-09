create or replace package body client_data_api_pack is

  g_is_api boolean := false; -- признак выполняется ли изменения через API

  procedure allow_changes is
  begin
    g_is_api := true;
  end;

  procedure disallow_changes is
  begin
    g_is_api := false;
  end;

  procedure insert_or_update_client_data(p_client_id   client.client_id%type
                                        ,p_client_data t_client_data_array) is
  begin
    if p_client_id is null then
      raise_application_error(common_pack.c_error_code_invalid_input_parameter,
                              common_pack.c_error_msg_empty_object_id);
    end if;
  
    if p_client_data is not empty then
    
      for i in p_client_data.first .. p_client_data.last loop
      
        if (p_client_data(i).field_id is null) then
          raise_application_error(common_pack.c_error_code_invalid_input_parameter,
                                  common_pack.c_error_msg_empty_field_id);
        end if;
      
        if (p_client_data(i).field_value is null) then
          raise_application_error(common_pack.c_error_code_invalid_input_parameter,
                                  common_pack.c_error_msg_empty_field_value);
        end if;
      end loop;
    else
      raise_application_error(common_pack.c_error_code_invalid_input_parameter,
                              common_pack.c_error_msg_empty_collection);
    end if;
    
    -- попытка заблокировать клиента (защита от параллельных изменений)
    client_api_pack.try_lock_client(p_client_id);
  
    allow_changes();
  
    -- вставка/обновление данных
    merge into client_data o
    using (select p_client_id client_id
                 ,value      (t).field_id       field_id
                 ,value      (t).field_value       field_value
             from table(p_client_data) t) n
    on (o.client_id = n.client_id and o.field_id = n.field_id)
    when matched then
      update set o.field_value = n.field_value
    when not matched then
      insert
        (client_id
        ,field_id
        ,field_value)
      values
        (n.client_id
        ,n.field_id
        ,n.field_value);
  
    disallow_changes();
  
  exception
    when others then
      disallow_changes();
      raise;
  end;

  -- Удаление клиентских данных
  procedure delete_client_data(p_client_id        client.client_id%type
                              ,p_delete_field_ids t_number_array) is
  begin
    if p_client_id is null then
      raise_application_error(common_pack.c_error_code_invalid_input_parameter,
                              common_pack.c_error_msg_empty_object_id);
    end if;
  
    if p_delete_field_ids is null
       or p_delete_field_ids is empty then
      raise_application_error(common_pack.c_error_code_invalid_input_parameter,
                              common_pack.c_error_msg_empty_collection);
    end if;

    -- попытка заблокировать клиента (защита от параллельных изменений)
    client_api_pack.try_lock_client(p_client_id);
	
	allow_changes();
  
    delete client_data cd
     where cd.client_id = p_client_id
       and cd.field_id in
           (select value(t) from table(p_delete_field_ids) t);
           
    disallow_changes();
  
  exception
    when others then
      disallow_changes();
      raise;
  end;

  procedure is_changes_through_api is
  begin
    if not g_is_api and not common_pack.is_manual_change_allowed() then
      raise_application_error(common_pack.c_error_code_manual_changes,
                              common_pack.c_error_msg_manual_changes);
    end if;
  end;

end;
/
