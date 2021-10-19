/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 22. Динамический SQL
  
  Описание скрипта: пример команды execute immediate

*/

-- вспомогательная таблица
drop table demo;
create table demo
(
 id number,
 name varchar2(200 char)
);

---- Пример 1. Вставка 10 записей
declare
begin
  for i in 1..10 loop
    -- здесь мы меняем динамически значение, а не сам запрос - это ок
    execute immediate 'insert into demo values(:id, :name)' using i, 'name_'||i;
  end loop;
end;
/
select * from demo;

-- Вариант со статическим SQL
begin
  for i in 1..10 loop    
    insert into demo values(i, 'name_'||i);
  end loop;
end;
/

---- Пример 2. Получаем результат в коллекцию (рекорд). Условие тоже из коллекции (number)
create or replace type t_numbers is table of number;
/

declare
  v_ids t_numbers := t_numbers(1, 2, 3);

  type t_arr is table of demo%rowtype;    
  v_result t_arr;
begin
  execute immediate 'select * 
                       from demo 
                      where id in (select value(t) 
                                     from table(:ids) t)'
     bulk collect into v_result
    using v_ids;
  
  if v_result is not empty then
    for i in v_result.first..v_result.last loop
      dbms_output.put_line('i= '||i||'. id: '||v_result(i).id||'. name: '|| v_result(i).name);
    end loop;
  end if;

end;
/

---- Пример 3. Получаем результат в две переменные.
declare
  v_id    demo.id%type; 
  v_name  demo.name%type;
begin
  execute immediate 'select id, name from demo where id = :v_id'
     into v_id, v_name
    using 5;
  
  dbms_output.put_line('id: '||v_id||'. name: '||v_name); 
end;
/


---- Пример 4. Вызываем PL/SQL-блок
create or replace procedure demo_prc(p_id in demo.id%type, p_name out demo.name%type)
is
begin
  select t.name
    into p_name
    from demo t
  where t.id = p_id;
end;
/

declare
  v_id   demo.id%type := 10;
  v_name demo.name%type;
begin
  execute immediate 'begin
                         demo_prc(:id, :name);
                     end;'
    using in v_id, out v_name;
  
  dbms_output.put_line('id: '||v_id||'. name: '||v_name);
end;
/

--- Пример 5. Усечение таблицы - DDL
declare
   procedure clear_tab(pi_table_name user_objects.object_name%type)
   is
   begin
     execute immediate 'truncate table '||pi_table_name;
   end;
begin
   clear_tab('demo');
end;
/
select * from demo;
