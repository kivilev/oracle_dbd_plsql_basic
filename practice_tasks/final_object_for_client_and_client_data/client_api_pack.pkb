create or replace package body client_api_pack is

  g_is_api boolean := false; -- флажок изменения через API

  -- включение флажка изменения через API
  procedure allow_changes is
  begin
    g_is_api := true;
  end;

  -- выключение флажка изменения через API
  procedure disallow_changes is
  begin
    g_is_api := false;
  end;

  function create_client(p_client_data t_client_data_array)
    return client.client_id%type is
    v_client_id client.client_id%type;
  begin
    allow_changes(); -- разрещаем изменения
  
    -- создание записи в таблице "клиент"
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
    returning client_id into v_client_id; -- возвращается новый ID из client_seq
  
    -- создаем клиентские данные
    client_data_api_pack.insert_or_update_data(v_client_id, p_client_data);
  
    disallow_changes(); -- запрещаем изменения
  
    -- возвращаем ID созданного клиента
    return v_client_id;
  
  exception
    when others then
      disallow_changes();
      raise;
  end;

  procedure block_client(p_client_id    client.client_id%type
                        ,p_block_reason client.blocked_reason%type) is
  begin
    allow_changes(); -- разрещаем изменения
  
    -- проверяем ID клиента
    if p_client_id is null then
      raise_application_error(c_invalid_param_code, c_client_id_empty_msg);
    end if;
  
    -- проверяем причину
    if p_block_reason is null then
      raise_application_error(c_invalid_param_code,
                              c_block_reason_empty_msg);
    end if;
  
    -- обновляем клиента
    update client cl
       set cl.is_blocked     = c_blocked
          ,cl.blocked_reason = p_block_reason
     where cl.client_id = p_client_id
       and cl.is_active = c_active;
  
    -- проверяем было ли обновление
    if sql%rowcount = 0 then
      raise_application_error(c_client_not_found_code,
                              c_client_not_found_msg);
    end if;
  
    disallow_changes(); -- запрещаем изменения  
  
  exception
    when others then
      disallow_changes();
      raise;
  end;

  procedure unblock_client(p_client_id client.client_id%type) is
  begin
    allow_changes(); -- разрещаем изменения
  
    if p_client_id is null then
      raise_application_error(c_invalid_param_code, c_client_id_empty_msg);
    end if;
  
    -- обновляем клиента
    update client cl
       set cl.is_blocked     = c_not_blocked
          ,cl.blocked_reason = null
     where cl.client_id = p_client_id
       and cl.is_active = c_active;
  
    -- проверяем было ли обновление
    if sql%rowcount = 0 then
      raise_application_error(c_client_not_found_code,
                              c_client_not_found_msg);
    end if;
  
    disallow_changes(); -- запрещаем изменения
  
  exception
    when others then
      disallow_changes();
      raise;
  end;

  procedure deactivate_client(p_client_id client.client_id%type) is
  begin
    allow_changes(); -- разрещаем изменения
  
    -- обновляем клиента
    update client cl
       set cl.is_active = c_inactive
     where cl.client_id = p_client_id
       and cl.is_active = c_active;
  
    -- проверяем было ли обновление    
    if sql%rowcount = 0 then
      raise_application_error(c_client_not_found_code,
                              c_client_not_found_msg);
    end if;
  
    disallow_changes(); -- запрещаем изменения    
  
  exception
    when others then
      disallow_changes();
      raise;
  end;

  procedure lock_client_for_update(p_client_id client.client_id%type) is
    v_client client.client_id%type;
  begin
    select cl.client_id
      into v_client
      from client cl
     where cl.client_id = p_client_id
       and cl.is_active = c_active
       for update nowait;
  exception
    when e_object_locked then
      raise_application_error(c_object_locked_code,
                              c_object_locked_code_msg);
    when no_data_found then
      raise_application_error(c_object_locked_code, c_client_not_found_msg);
  end;


  procedure is_changes_through_api is
  begin
    -- если флажок не стоит, значит изменения происходят не в API
    if not g_is_api then
      raise_application_error(c_manual_change_code,
                              c_manual_change_code_msg);
    end if;
  end;

end;
/
