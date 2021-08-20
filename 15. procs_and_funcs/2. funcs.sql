/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 15. Процедуры и функции
	
  Описание скрипта: примеры создания функций (пока без вызова)

*/

---- Пример 1. Фукнция без параметров. Уровень: схема.
create or replace function schema_func() return number 
is
begin
  dbms_output.put_line('Функция на уровне схемы')
  return 999;
end;
/


---- Пример 2. Локальная функция без параметров. Уровень: PLSQL-блок.
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

