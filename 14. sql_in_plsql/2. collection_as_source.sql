/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 14. Использование SQL в PL/SQL
	
  Описание скрипта: примеры коллекции как источник данных

*/

---- Пример 1. Коллекция из скаляра как источник данных
create or replace type t_numbers is table of number(10);
/

declare
  v_arr t_numbers := t_numbers(555, 666, 777);
  v_max number;
  v_min number;
begin
  select min(t.column_value), max(value(t))
    into v_min, v_max
    from table(v_arr) t;
  
  dbms_output.put_line('Минимальное значение: '||v_min); 
  dbms_output.put_line('Максимальное значение: '||v_max); 
end;
/

---- Пример 2. Коллекция из объекта как источник данных
create or replace type t_obj is object (n1 number(10), v1 varchar2(20 char));
/
create or replace type t_obj_arr is table of t_obj;
/

declare
  v_arr  t_obj_arr := t_obj_arr(t_obj(1, 'obj1'), t_obj(2, 'obj2'), t_obj(3, 'obj3'));
  v_max1 number(10);
  v_min1 varchar2(20 char);
begin
  select min(value(t).v1), max(value(t).n1)
    into v_min1, v_max1
    from table(v_arr) t;
  
  dbms_output.put_line('Минимальное значение v1: '||v_min1); 
  dbms_output.put_line('Максимальное значение n1: '||v_max1); 
end;
/
