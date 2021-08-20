/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 15. Процедуры и функции
	
  Описание скрипта: опережающее объявление модулей

*/

---- Исходный код с ошибкой
declare
  procedure B is
  begin
    dbms_output.put_line('B');
    A();
  end;
  
  procedure A is
  begin
    dbms_output.put_line('A'); 
  end;

begin
  B();
end;
/

---- Решение 1. Перенести A выше B (логическая расстановка)
declare
  procedure A is
  begin
    dbms_output.put_line('A'); 
  end;

  procedure B is
  begin
    dbms_output.put_line('B');
    A();
  end;

begin
  B();
end;
/

---- Решение 2. Опережающее объявление
declare
 
  procedure A; -- объявление модуля без реализации
  
  procedure B is
  begin
    dbms_output.put_line('B');
    A();
  end;
  
  procedure A is
  begin
    dbms_output.put_line('A'); 
  end;

begin
  B();
end;
/
