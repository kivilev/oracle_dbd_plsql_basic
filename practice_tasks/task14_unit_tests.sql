/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  Дата: 08.04.2021

  Описание скрипта: пример задания 14. Создание примитивных тестов
*/

/*
  Автор: Кивилев Д.С.
	Описание: позитивные тесты на API для сущностей "Клиент" и "Клиентские данные"
            негативные тесты на API для сущностей "Клиент" и "Клиентские данные"
*/

select t.status
      ,t.*
  from user_objects t
 where t.object_type in ('PACKAGE BODY', 'PACKAGE');


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
  v_client_id := client_api_pack.create_client(p_client_data => v_client_data);
  dbms_output.put_line('ID созданного клиента: ' || v_client_id);
  commit;
end;
/

select * from client cl order by cl.client_id desc;

----- Проверка блокировки клиента
declare
  v_client_id client.client_id%type := 21;
begin
  client_api_pack.block_client(p_client_id    => v_client_id,
               p_block_reason => 'Блокировка в тесте');
  commit;
end;
/

select * from client cl order by cl.client_id desc;

----- Проверка разблокировки клиента
declare
  v_client_id client.client_id%type := 21;
begin
  client_api_pack.unblock_client(p_client_id => v_client_id);
  commit;
end;
/

select * from client cl order by cl.client_id desc;


----- Проверка деактивации клиента
declare
  v_client_id client.client_id%type := 21;
begin
  client_api_pack.deactivate_client(p_client_id => v_client_id);
  commit;
end;
/

select * from client cl order by cl.client_id desc;

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
  client_data_api_pack.insert_or_update_data(p_client_id => v_client_id, p_client_data => v_client_data);
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
  client_data_api_pack.delete_data(p_client_id => v_client_id, p_delete_field_ids => v_delete_field_ids);
end;
/

-- после
select cd.*
      ,f.name
  from client_data cd
  join client_data_field f on f.field_id = cd.field_id
 where cd.client_id = 4 -- какой-то клиент
 order by cd.field_id;


------ Проверка, что прямой insert выполнять не допустимов (негативный сценарий)

-- смотрите буфер вывода
insert into client
  (client_id
  ,is_active
  ,is_blocked
  ,blocked_reason)
values
  (client_seq.nextval
  ,1
  ,0
  ,null);

rollback;


