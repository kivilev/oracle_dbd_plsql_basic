/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 6. Типы данных

  Описание скрипта: примеры с оператором IF
*/

---- Пример 1. Простой IF
declare
  v_num number(1) := 1;
begin
  if v_num = 1 then
    dbms_output.put_line('v_num равно 1');     
  end if;
end;
/

---- Пример 2. Условие IF с веткой иначе
declare
  v_num number(1) := 1;
begin
  if v_num = 2 then
    dbms_output.put_line('v_num равно 2'); 
  else
    dbms_output.put_line('v_num не равно 2'); 
  end if;
end;
/

---- Пример 3. Множество веток ветвления
declare
  v_num number(1) := 1;
begin
  if v_num = 2 then
    dbms_output.put_line('v_num равно 2');  
  elsif v_num = 3 then
    dbms_output.put_line('v_num равно 3');  
  elsif v_num = 1 then
    dbms_output.put_line('v_num равно 1');  
  else
    dbms_output.put_line('v_num равно чему-то');
  end if;
end;
/

---- Пример 4. IF Ленивый оператор
declare
  function f1 return boolean
  is
  begin
    dbms_output.put_line('f1');
    return true; 
  end;
  
  function f2 return boolean
  is
  begin
    dbms_output.put_line('f2');
    return true; 
  end;

begin
  if f1() or f2() then -- f2 не выполнился, т.к. для OR уже хвататает выполнения условий
    dbms_output.put_line('Условие1'); 
  end if;
  
  if f1() and f2() then -- f2 выполнится, т.к. для AND нужно вычислить все условия
    dbms_output.put_line('Условие2'); 
  end if;
end;
/

