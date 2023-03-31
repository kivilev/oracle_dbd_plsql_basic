/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Описание скрипта: пример задания 12. Создание примитивных тестов
*/

/*
  Автор: Кивилев Д.С.
	Описание: позитивные тесты для API для сущностей "Клиент" и "Клиентские данные"
*/

select t.status
      ,t.*
  from user_objects t
 where t.object_type in ('FUNCTION', 'PROCEDURE');


----- Проверка создания клиента
declare
  v_client_data t_client_data_array := t_client_data_array(t_client_data(1,
                                                                         'email@email.com'),
                                                           t_client_data(2,
                                                                         '+7999000000'),
                                                           t_client_data(3,
                                                                         '10000000'));
  v_client_id   client.client_id%type;
begin
  v_client_id := create_client(p_client_data => v_client_data);
  dbms_output.put_line('ID созданного клиента: ' || v_client_id);
  commit;
end;
/

select * from client cl where cl.client_id = 1;
select * from client_data cd where cd.client_id = 1 order by cd.field_id;


----- Проверка блокировки клиента
declare
  v_client_id client.client_id%type := 5;
begin
  block_client(p_client_id    => v_client_id,
               p_block_reason => 'Блокировка в тесте');
end;
/

select * from client cl where cl.client_id = 1;

----- Проверка разблокировки клиента
declare
  v_client_id client.client_id%type := 5;
begin
  unblock_client(p_client_id => v_client_id);
end;
/

select * from client cl where cl.client_id = 1;


----- Проверка деактивации клиента
declare
  v_client_id client.client_id%type := 5;
begin
  deactivate_client(p_client_id => v_client_id);
end;
/

select * from client cl where cl.client_id = 1;

----- Проверка вставки/изменения данных
-- до
select cd.*
      ,f.name
  from client_data cd
  join client_data_field f on f.field_id = cd.field_id
 where cd.client_id = 4  -- какой-то клиент
 order by cd.field_id;

declare
  v_client_id     client.client_id%type := 4;
  v_client_data   t_client_data_array := t_client_data_array(t_client_data(2,
                                                                           '+7000000000'),
                                                             t_client_data(4,
                                                                           '14.07.1983'));
begin
  insert_or_update_client_data(p_client_id => v_client_id, p_client_data => v_client_data);
end;
/

-- после
select cd.*
      ,f.name
  from client_data cd
  join client_data_field f on f.field_id = cd.field_id
 where cd.client_id = 4 -- какой-то клиент
 order by cd.field_id;

------ Проверка удаления данных
declare
  v_client_id     client.client_id%type := 4;
  v_delete_field_ids t_number_array := t_number_array(2, 3);
begin
  delete_client_data(p_client_id => v_client_id, p_delete_field_ids => v_delete_field_ids);
end;
/

-- после
select cd.*
      ,f.name
  from client_data cd
  join client_data_field f on f.field_id = cd.field_id
 where cd.client_id = 4 -- какой-то клиент
 order by cd.field_id;

