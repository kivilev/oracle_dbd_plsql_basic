create or replace package client_data_api_pack is

  -- Author  : D.KIVILEV
  -- Created : 26.04.2021 22:54:52
  -- Purpose : API для сущности "Данные клиента"

  c_manual_change_code     constant number(10) := -20103;
  c_manual_change_code_msg constant varchar2(200 char) := 'Нельзя изменять данные напрямую, только через API';

  -- вставка данных, если нет или обновление, если есть
  procedure insert_or_update_data(p_client_id   client.client_id%type
                                 ,p_client_data t_client_data_array);

  -- удаление данных по id полей
  procedure delete_data(p_client_id client.client_id%type
                       ,p_field_ids t_number_array);

  -- проверка, выполняются ли изменения через API (вызывается в триггере)
  procedure is_changes_through_api;

end;
/
create or replace package body client_data_api_pack is

  g_api boolean := false; -- флажок изменения через API


  -- включение флажка изменения через API
  procedure allow_changes is
  begin
    g_api := true;
  end;

  -- выключение флажка изменения через API
  procedure disallow_changes is
  begin
    g_api := false;
  end;

  procedure insert_or_update_data(p_client_id   client.client_id%type
                                 ,p_client_data t_client_data_array) is
  begin
    -- перед изменениями данных надо заблокировать клиента, чтобы никто параллельно не смог менять данные
    client_api_pack.lock_client_for_update(p_client_id);
    
    allow_changes();
  
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

  procedure delete_data(p_client_id client.client_id%type
                       ,p_field_ids t_number_array) is
  begin
    -- перед изменениями данных надо заблокировать клиента, чтобы никто параллельно не смог менять данные
    client_api_pack.lock_client_for_update(p_client_id);
    
    allow_changes();

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
    if not g_api then
      raise_application_error(c_manual_change_code,
                              c_manual_change_code_msg);
    end if;
  end;

end;
/
