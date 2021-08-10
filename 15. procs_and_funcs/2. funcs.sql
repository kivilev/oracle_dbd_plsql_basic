------- 1. Создание функций (пока без вызова)

-- Пример 1. Фукнция без параметров. Уровень: схема.
create or replace function schema_func() return number 
is
begin
  dbms_output.put_line('Функция на уровне схемы')
  return 999;
end;
/


-- Пример 2. Локальная функция без параметров. Уровень: PLSQL-блок.
declare

  -- локальная функция
  function local_func return number is
  begin
    dbms_output.put_line('Фукнция на уровне PL/SQL-блока.');  
    return 1000;
  end;
  
begin
  null;
end;
/

