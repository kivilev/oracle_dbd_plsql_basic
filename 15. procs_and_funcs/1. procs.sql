/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 15. Процедуры и функции
	
  Описание скрипта: примеры создания процедур (пока без вызова)

*/

---- Пример 1. Процедура без параметров. Уровень: схема.
create or replace procedure proc1
is
begin
  dbms_output.put_line('Процедура на уровне схемы'); 
end;
/

select status, t.* from user_objects t where t.object_name = 'PROC1';


---- Пример 2. Локальная процедура без параметров. Уровень: PLSQL-блок.
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

