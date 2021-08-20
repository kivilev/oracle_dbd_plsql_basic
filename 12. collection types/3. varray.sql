/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 12. Коллекции
	
  Описание скрипта: примеры определения массива переменной длины(varray)
*/

---- Пример 1. Varray с элементами типа number, определение на уровне схемы
create or replace type t_numbers_v  is  varray(3)  of  number(30,0);
/
declare
  v_array t_numbers; -- переменная типа вложенная таблица
begin
  null; 
end;
/

---- Пример 2. Varray с элементами типа date, определение на уровне PL/SQL-блока
declare
  type t_dates_v is varray(30) of date; -- определяем тип
  v_array t_dates_v; -- переменная типа вложенная таблица
begin
  null; 
end;
/

---- Пример 3. Varray с элементами типа boolean, определение на уровне PL/SQL-блока 
declare
  type t_booleans_v is varray(10) of boolean;-- определяем тип
  v_array t_booleans_v; -- переменная типа вложенная таблица
begin
  null;
end;
/

---- Пример 4. Попытка создать varray на уровне схемы с не SQL-типом -> ошибка
create or replace type t_booleans_v is varray(10) of boolean;
/

show errors;

