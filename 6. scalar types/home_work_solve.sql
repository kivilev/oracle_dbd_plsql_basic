/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  Дата: 20.03.2021

  Описание скрипта: решения для домашнего задания
*/

-- 1. Создайте переменные типа number
declare
  v_var1 number(3,0) := 123;
  v_var2 number(3) := 123;
  v_var3 number(5,-2) := 123456.22;
  v_var4 number(4,2) := 12.33;
  v_var5 number(30) := 123456;
begin
  dbms_output.put_line(v_var1); 
  dbms_output.put_line(v_var2);  
  dbms_output.put_line(v_var3);     
  dbms_output.put_line(v_var4); 
  dbms_output.put_line(v_var5);       
end;
/

-- 2. Создайте переменные типа varchar2
declare
  v_hello_world_v2 varchar2(100 char) := 'Hello World!';
  v_hello_world_char char(100 char) := 'Hello World!'; -- Разница в том, что эта строка добита пробелами до 100 символов
begin
   dbms_output.put_line(v_hello_world_v2);
   dbms_output.put_line(v_hello_world_char);
end;
/
