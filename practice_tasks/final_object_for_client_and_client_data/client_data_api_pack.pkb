create or replace package body client_data_api_pack is

  g_is_api boolean := false; -- флажок изменения через API

  -- проверка, корректные ли данные к нам пришли
  procedure check_client_data_for_empty_value(p_client_data t_client_data_array) is
  begin
    if p_client_data is not empty then
      -- не пустая коллекция -> проверим каждый элемент
      for i in p_client_data.first .. p_client_data.last loop
        -- тип поля не может быть пустым
        if (p_client_data(i).field_id is null) then
          raise_application_error(c_invalid_param_code,
                                  c_empty_field_id_in_client_data);
        end if;
        -- значение в поле не может быть пустым
        if (p_client_data(i).field_value is null) then
          raise_application_error(c_invalid_param_code,
                                  c_empty_value_in_client_data);
        end if;
      end loop;
    else
      -- пустая коллекция
      raise_application_error(c_invalid_param_code, c_empty_data_list);
    end if;
  end;

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

  procedure insert_or_update_data(p_client_id   client.client_id%type
                                 ,p_client_data t_client_data_array) is
  begin
    allow_changes(); -- разрещаем изменения
  
    -- проверяем ID клиента
    if p_client_id is null then
      raise_application_error(c_invalid_param_code,
                              client_api_pack.c_client_id_empty_msg);
    end if;
  
    -- проверяем данные клиента
    check_client_data_for_empty_value(p_client_data);
  
    -- перед изменениями данных надо заблокировать клиента, чтобы никто параллельно не смог менять данные
    client_api_pack.lock_client_for_update(p_client_id);
  
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
  
    disallow_changes(); -- запрещаем изменения    
  
  exception
    when others then
      disallow_changes();
      raise;
  end;

  procedure delete_data(p_client_id        client.client_id%type
                       ,p_delete_field_ids t_number_array) is
  begin
    allow_changes(); -- разрещаем изменения
  
    if p_field_ids is empty then
      -- пустая коллекция
      raise_application_error(c_invalid_param_code, c_empty_data_list);
    end if;
  
    -- проверяем ID клиента
    if p_client_id is null then
      raise_application_error(c_invalid_param_code,
                              client_api_pack.c_client_id_empty_msg);
    end if;
  
    -- перед изменениями данных надо заблокировать клиента, чтобы никто параллельно не смог менять данные
    client_api_pack.lock_client_for_update(p_client_id);
  
    -- удаляем клиентские данные
    delete client_data cd
     where cd.client_id = p_client_id
       and cd.field_id in (select value(t) from table(p_field_ids) t);
  
    disallow_changes(); -- запрещаем изменения
  
  exception
    when others then
      disallow_changes();
      raise;
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
