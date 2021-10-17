create or replace package body client_api_pack is

  g_is_api boolean := false; -- признак выполняется ли изменения через API

  procedure allow_changes is
  begin
    g_is_api := true;
  end;

  procedure disallow_changes is
  begin
    g_is_api := false;
  end;

  function create_client(p_client_data t_client_data_array)
    return client.client_id%type is
    v_message       varchar2(200 char) := 'Клиент создан';
    v_current_dtime date := sysdate;
    v_client_id     client.client_id%type;
  begin
  
    if p_client_data is not empty then
    
      for i in p_client_data.first .. p_client_data.last loop
      
        if (p_client_data(i).field_id is null) then
          raise_application_error(c_error_code_invalid_input_parameter,
                                  c_error_msg_empty_field_id);
        end if;
      
        if (p_client_data(i).field_value is null) then
          raise_application_error(c_error_code_invalid_input_parameter,
                                  c_error_msg_empty_field_value);
        end if;
      
        dbms_output.put_line('Field_id: ' || p_client_data(i).field_id ||
                             '. Value: ' || p_client_data(i).field_value);
      end loop;
    else
      raise_application_error(c_error_code_invalid_input_parameter,
                              c_error_msg_empty_collection);
    end if;
  
    dbms_output.put_line(v_message || '. Статус: ' || c_active ||
                         '. Блокировка: ' || c_not_blocked);
    dbms_output.put_line(to_char(v_current_dtime, 'yyyy-mm-dd hh24:mi:ss'));
  
    allow_changes();
  
    -- создание клиента
    insert into client
      (client_id
      ,is_active
      ,is_blocked
      ,blocked_reason)
    values
      (client_seq.nextval
      ,c_active
      ,c_not_blocked
      ,null)
    returning client_id into v_client_id;
  
    dbms_output.put_line('Client_id of new client: ' || v_client_id);
  
    -- добавление клиентских данных
    client_data_api_pack.insert_or_update_client_data(p_client_id   => v_client_id,
                                                      p_client_data => p_client_data);
  
    disallow_changes();
  
    return v_client_id;
  
  exception
    when others then
      disallow_changes();
      raise;
  end;

  -- Блокировка клиента
  procedure block_client(p_client_id client.client_id%type
                        ,p_reason    client.blocked_reason%type) is
    v_message       varchar2(200 char) := 'Клиент заблокирован';
    v_current_dtime timestamp := systimestamp;
  begin
    if p_client_id is null then
      raise_application_error(c_error_code_invalid_input_parameter,
                              c_error_msg_empty_object_id);
    end if;
  
    if p_reason is null then
      raise_application_error(c_error_code_invalid_input_parameter,
                              c_error_msg_empty_reason);
    end if;
  
    dbms_output.put_line(v_message || '. Блокировка: ' || c_blocked ||
                         '. Причина: ' || p_reason || '. ID: ' ||
                         p_client_id);
    dbms_output.put_line(to_char(v_current_dtime,
                                 'yyyy-mm-dd hh24:mi:ss.ff'));
  
    allow_changes();
    -- обновление клиента
    update client cl
       set cl.is_blocked     = c_blocked
          ,cl.blocked_reason = p_reason
     where cl.client_id = p_client_id
       and cl.is_active = c_active;
    disallow_changes();
  
  exception
    when others then
      disallow_changes();
      raise;
  end;

  -- Разблокировка клиента
  procedure unblock_client(p_client_id client.client_id%type) is
    v_message       varchar2(200 char) := 'Клиент разблокирован. Блокировка: ';
    v_current_dtime timestamp := systimestamp;
  begin
    if p_client_id is null then
      raise_application_error(c_error_code_invalid_input_parameter,
                              c_error_msg_empty_object_id);
    end if;
  
    dbms_output.put_line(v_message || c_not_blocked || '. ID: ' ||
                         p_client_id);
    dbms_output.put_line(to_char(v_current_dtime,
                                 'mm/dd/yyyy hh24:mi:ss.ff'));
  
    allow_changes();
    -- обновление клиента
    update client cl
       set cl.is_blocked     = c_not_blocked
          ,cl.blocked_reason = null
     where cl.client_id = p_client_id
       and cl.is_active = c_active;
    disallow_changes();
  
  exception
    when others then
      disallow_changes();
      raise;
  end;

  -- Клиент деактивирован
  procedure deactivate_client(p_client_id client.client_id%type) is
    v_message       varchar2(200 char) := 'Клиент деактивирован. Статус активности: ';
    v_current_dtime date := sysdate;
  begin
    if p_client_id is null then
      raise_application_error(c_error_code_invalid_input_parameter,
                              c_error_msg_empty_object_id);
    end if;
  
    dbms_output.put_line(v_message || c_inactive || '. ID: ' ||
                         p_client_id);
    dbms_output.put_line(to_char(v_current_dtime, 'yyyy_mm_dd_hh24'));
  
    allow_changes();
  
    -- обновление клиента
    update client cl
       set cl.is_active = c_inactive
     where cl.client_id = p_client_id
       and cl.is_active = c_active;
  
    disallow_changes();
  
  exception
    when others then
      disallow_changes();
      raise;
  end;

  procedure is_changes_through_api is
  begin
    if not g_is_api then
      raise_application_error(c_error_code_manual_changes,
                              c_error_msg_manual_changes);
    end if;
  end;

end;
/
