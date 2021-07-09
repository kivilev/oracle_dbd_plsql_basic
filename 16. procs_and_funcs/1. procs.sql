------- 1. Создание процедур (пока без вызова)

-- Пример 1. Процедура без параметров. Уровень: схема.
create or replace procedure proc1
is
begin
  dbms_output.put_line('Процедура на уровне схемы'); 
end;
/

-- Пример 2. Локальная процедура без параметров. Уровень: PLSQL-блок.
declare
  
  procedure local_proc1 
  is
  begin
    dbms_output.put_line('Процедура на уровне PL/SQL-блока.'); 
  end;

begin
  null;
end;
/

