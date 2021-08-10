------- 4. Вызовы процедур и функций (без параметров)

-- Пример 1. Процедура на уровне схемы + вызов из PL/SQL блока
create or replace procedure demo_proc
is
begin
  dbms_output.put_line('It''s demo proc call');
end;
/

-- вызов
begin
   demo_proc();
end;
/

-- Пример 2. Функция уровня PL/SQL-блока + вызов
declare
  v_res number(10);

  function my_func return number
  is
  begin
    dbms_output.put_line('  It''s my_func call'); 
    return 999;
  end;
 
begin
  -- вызов 1
  v_res := my_func(); -- вызов
  dbms_output.put_line('Function result call 1: '|| v_res); -- вывод результата

  -- вызов 2
  dbms_output.put_line('Function result call 2: '|| my_func()); -- вызов + вывод результата  
end;
/

-- Пример 3. Неправильный вызов функции
declare
  v_res number(10);

  function my_func return number
  is
  begin
    return 999;
  end;
 
begin  
  my_func(); -- неправильный вызов функции
end;
/


