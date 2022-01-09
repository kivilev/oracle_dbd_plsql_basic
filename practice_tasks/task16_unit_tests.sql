-- Заготовка под Unit-тесты
-- ФИО

-- Проверка "Создание клиента"
declare
  v_client_data t_client_data_array := t_client_data_array(t_client_data(1, 'email@email.com'),
                                                             t_client_data(2, '+7999000000'),
                                                             t_client_data(3, '1000000000'));
  v_client_id client.client_id%type;                                                             
  v_create_dtime_tech client.create_dtime_tech%type;
  v_update_dtime_tech client.update_dtime_tech%type;  
begin
  v_client_id := client_api_pack.create_client(p_client_data => v_client_data);  
  dbms_output.put_line('Client id: '|| v_client_id);
  
  select cl.create_dtime_tech, cl.update_dtime_tech
    into v_create_dtime_tech, v_update_dtime_tech
    from client cl 
   where cl.client_id = v_client_id;
  
  -- проверка работы триггера
  if v_create_dtime_tech != v_update_dtime_tech then
    raise_application_error(-20998, 'Технические даты разные!');
  end if;
  
  commit;
end;
/

select * from client cl where cl.client_id = 41;
select * from client_data cl where cl.client_id = 41 order by cl.field_id;


-- Проверка "Блокировка клиента"
declare
  v_client_id client.client_id%type := 41;
  v_reason client.blocked_reason%type := 'Тестовая блокировка клиента';
  v_create_dtime_tech client.create_dtime_tech%type;
  v_update_dtime_tech client.update_dtime_tech%type;    
begin
  client_api_pack.block_client(p_client_id => v_client_id, p_reason => v_reason);
  
  select cl.create_dtime_tech, cl.update_dtime_tech
    into v_create_dtime_tech, v_update_dtime_tech
    from client cl 
   where cl.client_id = v_client_id;
  
  -- проверка работы триггера
  if v_create_dtime_tech = v_update_dtime_tech then
    raise_application_error(-20998, 'Технические даты одинаковые!');
  end if;
  
end;
/

select * from client cl where cl.client_id = 41;

-- Проверка "Разблокировка клиента"
declare
  v_client_id client.client_id%type := 41;
begin
  client_api_pack.unblock_client(p_client_id => v_client_id);  
end;
/

select * from client cl where cl.client_id = 41;

-- Проверка "Деактивация клиента"
declare
  v_client_id client.client_id%type := 41;
begin
  client_api_pack.deactivate_client(p_client_id => v_client_id); 
end;
/

select * from client cl where cl.client_id = 41;

-- Проверка "Вставка/обновление клиентских данных"
select cd.*
      ,f.name
  from client_data cd
  join client_data_field f on f.field_id = cd.field_id
 where cd.client_id = 41  -- какой-то клиент
 order by cd.field_id;

declare
  v_client_id   client.client_id%type := 41;
  v_client_data t_client_data_array := t_client_data_array(t_client_data(2,
                                                                         '+7000000000'),
                                                           t_client_data(4,
                                                                         '14.07.1983'));
begin
  client_data_api_pack.insert_or_update_client_data(p_client_id => v_client_id, p_client_data => v_client_data);
end;
/

select cd.*
      ,f.name
  from client_data cd
  join client_data_field f on f.field_id = cd.field_id
 where cd.client_id = 41  -- какой-то клиент
 order by cd.field_id;

-- Проверка "Удаление клиентских данных" 
declare
  v_client_id   client.client_id%type := 41;
  v_delete_field_ids t_number_array := t_number_array(2, 3);                                                           
begin
  client_data_api_pack.delete_client_data(p_client_id => v_client_id, p_delete_field_ids => v_delete_field_ids);
end;
/

select cd.*
      ,f.name
  from client_data cd
  join client_data_field f on f.field_id = cd.field_id
 where cd.client_id = 41  -- какой-то клиент
 order by cd.field_id;


-- Проверка функционала по глобальному разрешению. Операция удаления клиента
declare
  v_client_id   client.client_id%type := -1;
begin
  common_pack.enable_manual_changes();
      
  delete from client cl where cl.client_id = v_client_id;
  
  common_pack.disable_manual_changes();
  
exception
  when others then
    common_pack.disable_manual_changes();
    raise;    
end;
/

-- Проверка функционала по глобальному разрешению. Операция изменения клиента
declare
  v_client_id   client.client_id%type := -1;
begin
  common_pack.enable_manual_changes();
  
  update client cl
     set cl.is_active = cl.is_active
   where cl.client_id = v_client_id;
  
  common_pack.disable_manual_changes();
  
exception
  when others then
    common_pack.disable_manual_changes();
    raise;    
end;
/

-- Проверка функционала по глобальному разрешению. Операция изменения клиентских данных
declare
  v_client_id   client.client_id%type := -1;
begin
  common_pack.enable_manual_changes();
  
  update client_data cl
     set cl.field_value = cl.field_value
   where cl.client_id = v_client_id;
  
  common_pack.disable_manual_changes();
  
exception
  when others then
    common_pack.disable_manual_changes();
    raise;
end;
/

---- Негативные тесты

-- Проверка "Создание клиента"
declare
  v_client_data t_client_data_array;
  v_client_id client.client_id%type;             
begin
  v_client_id := client_api_pack.create_client(p_client_data => v_client_data);

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');  
exception
  when common_pack.e_invalid_input_parameter then
    dbms_output.put_line('Создание клиента. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

-- Проверка "Блокировка клиента"
declare
  v_client_id client.client_id%type := 41;
  v_reason client.blocked_reason%type;
begin
  client_api_pack.block_client(p_client_id => v_client_id, p_reason => v_reason);

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');  
exception
  when common_pack.e_invalid_input_parameter then
    dbms_output.put_line('Блокировка клиента. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/
select * from client cl where cl.client_id = 41;

-- Проверка "Разблокировка клиента"
declare
  v_client_id client.client_id%type;
begin
  client_api_pack.unblock_client(p_client_id => v_client_id);  

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');  
exception
  when common_pack.e_invalid_input_parameter then
    dbms_output.put_line('Разблокировка клиента. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

-- Проверка "Деактивация клиента"
declare
  v_client_id client.client_id%type;
begin
  client_api_pack.deactivate_client(p_client_id => v_client_id);

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');  
exception
  when common_pack.e_invalid_input_parameter then
    dbms_output.put_line('Деактивация клиента. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

-- Проверка "Удаление клиентских данных"
declare
  v_client_id   client.client_id%type := 41;
  v_client_data t_client_data_array;
begin
  client_data_api_pack.insert_or_update_client_data(p_client_id => v_client_id, p_client_data => v_client_data);

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');
exception
  when common_pack.e_invalid_input_parameter then
    dbms_output.put_line('Удаление клиентских данных. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

-- Проверка "Удаление клиентских данных" 
declare
  v_client_id   client.client_id%type := 41;
  v_delete_field_ids t_number_array;
begin
  client_data_api_pack.delete_client_data(p_client_id => v_client_id, p_delete_field_ids => v_delete_field_ids);

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');  
exception
  when common_pack.e_invalid_input_parameter then
    dbms_output.put_line('Удаление клиентских данных. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

---- Негативные тесты (триггеры)

-- Проверка запрета удаления клиента через delete
declare
  v_client_id   client.client_id%type := -1;
begin
  delete from client cl where cl.client_id = v_client_id;

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');  
exception
  when common_pack.e_delete_forbidden then
    dbms_output.put_line('Удаление клиента. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

-- Проверка запрета вставки в client не через API
declare
  v_client_id   client.client_id%type := -1;
begin
  insert into client(client_id,
                     is_active,
                     is_blocked,
                     blocked_reason)
  values (v_client_id, client_api_pack.c_active, client_api_pack.c_not_blocked, null);

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');  
exception
  when common_pack.e_manual_changes then
    dbms_output.put_line('Вставка в таблицу client не через API. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

-- Проверка запрета обновления в client не через API
declare
  v_client_id   client.client_id%type := -1;
begin
  update client cl
     set cl.is_active = cl.is_active
   where cl.client_id = v_client_id;

  raise_application_error(-20999, 'Unit-тест или API выполнены не верно');  
exception
  when common_pack.e_manual_changes then
    dbms_output.put_line('Обновление таблицы client не через API. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

-- Вставка не через API (вставка) - клиентских данных
declare
  v_client_id   client.client_id%type := -1;
  v_field_id    client_data.field_id%type := -1;
begin
  insert into client_data(client_id,
                          field_id,
                          field_value)
  values
    (v_client_id
    ,v_field_id
    ,null);
  
	raise_application_error(-20999, 'Unit-тест или API выполнены не верно');		
exception
  when common_pack.e_manual_changes then
    dbms_output.put_line('Вставка в таблицу client_data не через API. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

-- Изменение не через API (обновление) - клиентских данных
declare
  v_client_id   client.client_id%type := -1;
begin
  update client_data cl
     set cl.field_value = cl.field_value
   where cl.client_id = v_client_id;
  
	raise_application_error(-20999, 'Unit-тест или API выполнены не верно');	 
exception
  when common_pack.e_manual_changes then
    dbms_output.put_line('Обновление таблицы client_data не через API. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

-- Удаление не через API (обновление) - клиентских данных
declare
  v_client_id   client.client_id%type := -1;
begin
  delete client_data cl     
   where cl.client_id = v_client_id;
  
	raise_application_error(-20999, 'Unit-тест или API выполнены не верно');	 
exception
  when common_pack.e_manual_changes then
    dbms_output.put_line('Удаление из таблицы client_data не через API. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/
