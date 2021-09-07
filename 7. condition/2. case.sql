/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 7. Условия и переходы

  Описание скрипта: примеры с оператором CASE
*/

---- Пример 1. Простой CASE
declare
  v_val  number(30) := 100;
  v_res  number(30) := 1;
begin
  case v_val
     when 10 then
       dbms_output.put_line('v_val = 10');
     when 20 then
       dbms_output.put_line('v_val = 20');
       v_res := v_val + 1;
     when 100 then
       dbms_output.put_line('v_val = 100');
       v_res := v_val + 1000;
     else
       dbms_output.put_line('else'); 
  end case;
  
  dbms_output.put_line('v_res = '||v_res); 
end;
/

---- Пример 2. Поисковый CASE
declare
  v_val  number(30) := 100;
  v_str  varchar2(20 char) := 'Условие2';
  v_res  number(30) := 1; 
begin
  case 
     when v_val = 10 then
       dbms_output.put_line('v_val = 10');
     when v_val = 20 then
       dbms_output.put_line('v_val = 20');
       v_res := v_val + 1;
     when v_val = 100 and v_str = 'Условие2' then
       dbms_output.put_line('v_val = 100');
       v_res := v_val + 1000;
     else
       dbms_output.put_line('else'); 
  end case;
  
  dbms_output.put_line('v_res = '||v_res); 
end;
/

---- Пример 3. Выражение CASE
declare
  v_val  number(30) := 100;
  v_str  varchar2(20 char) := 'Условие2';
  v_res  number(30) := 1; 
begin
  v_res := (case 
     when v_val = 10 then
       10
     when v_val = 20 then
       20
     when v_val = 100 and v_str = 'Условие2' then
       v_val + 1000
     else
       777
  end);
  
  dbms_output.put_line('v_res = '||v_res); 
end;
/

---- Пример 4. Выражение + поисковый CASE
declare
  v_val  varchar2(30 char) := 'Значение1';
  v_res  number(30) := 1; 
begin
  v_res := (case v_val 
     when 'Что-то1' then
       100
     when 'Что-то2' then
       200
     else
       777
  end);
  
  dbms_output.put_line('v_res = '||v_res); 
end;
/

