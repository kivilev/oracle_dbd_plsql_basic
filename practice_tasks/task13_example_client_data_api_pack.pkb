create or replace package body client_data_api_pack is

  -- Добавление/изменение клиентских данных
  procedure insert_or_update_data(p_client_id   client.client_id%type
                                 ,p_client_data t_client_data_array) is
    v_message       varchar2(200 char) := 'Клиентские данные вставлены или обновлены по списку id_поля/значение';
    v_current_dtime date := sysdate;
  begin
  
    if p_client_id is null then
      dbms_output.put_line('ID клиента не может быть пустым');
    end if;
  
    if p_client_data is not empty then
      for i in p_client_data.first .. p_client_data.last loop
        if (p_client_data(i).field_id is null) then
          dbms_output.put_line('ID поля в данных не может быть пустым');
        end if;
        if (p_client_data(i).field_value is null) then
          dbms_output.put_line('Значение в данных не может быть пустым');
        end if;
      
        dbms_output.put_line('Field_id: ' || p_client_data(i).field_id ||
                             '. Value: ' || p_client_data(i).field_value);
      end loop;
    else
      dbms_output.put_line('Коллекция не содержит данных');
    end if;
  
    dbms_output.put_line(v_message || '. ID: ' || p_client_id);
    dbms_output.put_line(to_char(v_current_dtime,
                                 '"date:"yyyymmdd" time:"hh24:mi'));
  
    -- вставка или обновление
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
  end;

  -- Удаление клиентских данных
  procedure delete_data(p_client_id        client.client_id%type
                       ,p_delete_field_ids t_number_array) is
    v_message       varchar2(200 char) := 'Клиентские данные удалены по списку id_полей';
    v_current_dtime timestamp := systimestamp;
  begin
    if p_client_id is null then
      dbms_output.put_line('ID клиента не может быть пустым');
    end if;
  
    if p_delete_field_ids is empty then
      dbms_output.put_line('Коллекция не содержит данных');
    end if;
  
    dbms_output.put_line(v_message || '. ID: ' || p_client_id);
    dbms_output.put_line(to_char(v_current_dtime, 'ff4'));
    dbms_output.put_line('Количество удаляемых полей: ' ||
                         p_delete_field_ids.count());
  
    -- удаляем клиентские данные
    delete client_data cd
     where cd.client_id = p_client_id
       and cd.field_id in
           (select value(t) from table(p_delete_field_ids) t);
  
  end;

end;
/
