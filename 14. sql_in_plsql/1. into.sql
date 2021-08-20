/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 14. Использование SQL в PL/SQL
	
  Описание скрипта: примеры сохранения результатов выполнения SELECT 

*/

---- Пример 1. Выбор в переменную
declare
  v_num number(10);
begin
  select 777
    into v_num
    from dual;
  dbms_output.put_line('Значение переменной: '||v_num); 
end;
/

---- Пример 2. Выбор в коллекцию
declare
  type t_arr is table of user_objects.object_id%type;
  v_arr t_arr;
begin
  select t.object_id
    bulk collect into v_arr
    from user_objects t
   where rownum <= 2;
  dbms_output.put_line('Значение 1-го элемента: '||v_arr(1)); 
  dbms_output.put_line('Значение 2-го элемента: '||v_arr(2));
end;
/

---- Пример 3. Ошибка выборки в переменную при отсутствии строки (no data found)
declare
  v_num number(10);
begin
  select 777
    into v_num
    from dual 
   where 1 = 0;
end;
/

---- Пример 4. Ошибка выборки в переменную при отсутствии строки (too many rows - exact fetch returns more than requested number of rows)
declare
  v_num user_objects.object_id%type;
begin
  select t.object_id
    into v_num
    from user_objects t
   where rownum <= 2;
end;
/
