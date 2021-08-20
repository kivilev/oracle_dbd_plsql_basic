/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 15. Процедуры и функции
	
  Описание скрипта: пример табличных функций как источник данных

*/

-- Создадим коллекцию
create or replace type t_numbers is table of number(20);
/

-- Создадим функцию
create or replace function my_table_func return t_numbers
is
begin
  return t_numbers(100, 200, 300, 400);
end;
/

-- Обратимся к функции в SQL

select * from table(my_table_func()); -- < 12c 

select * from my_table_func(); -- >= 12c

