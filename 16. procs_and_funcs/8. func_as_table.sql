------- 7. Табличные функции как источник данных

-- 1) Создадим коллекцию
create or replace type t_numbers is table of number(20);
/

-- 2) Создадим функцию
create or replace function my_table_func return t_numbers
is
begin
  return t_numbers(100, 200, 300, 400);
end;
/


-- 3) Обратимся к функции в SQL

select * from table(my_table_func()); -- < 12c 

select * from my_table_func(); -- >= 12c
