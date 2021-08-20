/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 20. Исключения
	
  Описание скрипта: примеры обработки неименованных системных исключений
*/

-- Создадим вспомогательную табличку
drop table demo1;
create table demo1
(
  id number not null
);

-- для начала, попробуем сделать вставку не в PL/SQL -> получим ошибку
insert into demo1 values (null); 

---- Пример 1. Пытаемся вставить null-значение (others + sqlcode)
begin
  insert into demo1 values (null);     
exception 
  when others then -- Так себе путь
    if sqlcode = -01400 then
      dbms_output.put_line('Возможно, конечно, так обрабатывать, но шляпа :)');    
    else --! момент, если это не добавить, то другие исключения будут пропадать
      raise;
    end if;
end;
/

---- Пример 2. Пытаемся вставить null-значение (exception + pragma)
declare
  e_null exception;
  pragma exception_init(e_null, -01400);
begin
  insert into demo1 values (null);
exception 
  when e_null then
    dbms_output.put_line('Путь джедая по обработке ошибок.');
end;
/


