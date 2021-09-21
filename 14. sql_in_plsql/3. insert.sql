/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 14. Использование SQL в PL/SQL
	
  Описание скрипта: примеры INSERT в PL/SQL

*/

-- Создадим вспомогательную табличку
create table example_12_3(
id   number(3),
name varchar2(200 char)
);
-- и последовательность для генерации ID
create sequence example_12_3_seq;

---- Пример 1. Возврашаем одно поле из INSERT
declare
  v_new_id example_12_3.id%type;
begin
  insert into example_12_3 
  values (example_12_3_seq.nextval, example_12_3_seq.currval||'_name')
  returning id into v_new_id;
  
  dbms_output.put_line('New id: '|| v_new_id); 
end;
/

---- Пример 2. Возврашаем два поля в две переменные из INSERT
declare
  v_new_id   example_12_3.id%type;
  v_new_name example_12_3.name%type;
begin
  insert into example_12_3 
  values (example_12_3_seq.nextval, example_12_3_seq.currval||'_name')
  returning id, name into v_new_id, v_new_name;
  
  dbms_output.put_line('New id: '|| v_new_id); 
  dbms_output.put_line('New name: '|| v_new_name); 
end;
/
