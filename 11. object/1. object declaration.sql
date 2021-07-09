----- Пример 1. Создание объектов

-- Пример 1.1. Создание объекта на уровне схемы (только там и можно)
create or replace type t_my_obj1  is object (
  id      number(30), 
  name    varchar2(200 char),
  enabled number(1)
);
/

declare
  v_my_obj t_my_obj1; -- объявление переменной с типом объект t_my_obj1
begin
   null; 
end;
/


-- Пример 1.2. В отличии от записей модификаторы типов использовать нельзя
create or replace type t_my_obj2  is object (
  id      employees.employee_id%type, -- модификаторы использовать нельзя. Объект будет с ошибкой.
  name    varchar2(200 char),
  enabled boolean
);
/


-- Пример 1.3. Нельзя использовать типы в полях, которых нет в SQL. Например, boolean
create or replace type t_my_obj1  is object (
  id      number(30), 
  name    varchar2(200 char),
  enabled boolean -- ошибка, такого типа в SQL нет
);
/
