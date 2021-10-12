-- Заготовка под Unit-тесты
-- ФИО

-- Проверка "Создание клиента"
declare
  v_client_data t_client_data_array := t_client_data_array(t_client_data(1, 'email@email.com'),
                                                             t_client_data(2, '+7999000000'),
                                                             t_client_data(3, '1000000000'));
  v_client_id client.client_id%type;                                                             
begin
  v_client_id := client_api_pack.create_client(p_client_data => v_client_data);  
  dbms_output.put_line('Client id: '|| v_client_id);
  commit;
end;
/

select * from client cl where cl.client_id = 41;
select * from client_data cl where cl.client_id = 41 order by cl.field_id;


-- Проверка "Блокировка клиента"
declare
  v_client_id client.client_id%type := 41;
  v_reason client.blocked_reason%type := 'Тестовая блокировка клиента';
begin
  client_api_pack.block_client(p_client_id => v_client_id, p_reason => v_reason);
  
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


---- Негативные тесты

-- Проверка "Создание клиента"
declare
  v_client_data t_client_data_array;
  v_client_id client.client_id%type;             
begin
  v_client_id := client_api_pack.create_client(p_client_data => v_client_data);  
exception
  when client_api_pack.e_invalid_input_parameter then
    dbms_output.put_line('Создание клиента. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

-- Проверка "Блокировка клиента"
declare
  v_client_id client.client_id%type := 41;
  v_reason client.blocked_reason%type;
begin
  client_api_pack.block_client(p_client_id => v_client_id, p_reason => v_reason);
exception
  when client_api_pack.e_invalid_input_parameter then
    dbms_output.put_line('Блокировка клиента. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/
select * from client cl where cl.client_id = 41;

-- Проверка "Разблокировка клиента"
declare
  v_client_id client.client_id%type;
begin
  client_api_pack.unblock_client(p_client_id => v_client_id);  
exception
  when client_api_pack.e_invalid_input_parameter then
    dbms_output.put_line('Разблокировка клиента. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

-- Проверка "Деактивация клиента"
declare
  v_client_id client.client_id%type;
begin
  client_api_pack.deactivate_client(p_client_id => v_client_id); 
exception
  when client_api_pack.e_invalid_input_parameter then
    dbms_output.put_line('Деактивация клиента. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

-- Проверка "Удаление клиентских данных"
declare
  v_client_id   client.client_id%type := 41;
  v_client_data t_client_data_array;
begin
  client_data_api_pack.insert_or_update_client_data(p_client_id => v_client_id, p_client_data => v_client_data);
exception
  when client_api_pack.e_invalid_input_parameter then
    dbms_output.put_line('Удаление клиентских данных. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/

-- Проверка "Удаление клиентских данных" 
declare
  v_client_id   client.client_id%type := 41;
  v_delete_field_ids t_number_array;
begin
  client_data_api_pack.delete_client_data(p_client_id => v_client_id, p_delete_field_ids => v_delete_field_ids);
exception
  when client_api_pack.e_invalid_input_parameter then
    dbms_output.put_line('Удаление клиентских данных. Исключение возбуждено успешно. Ошибка: '|| sqlerrm); 
end;
/
