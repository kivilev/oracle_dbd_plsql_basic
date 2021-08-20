/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 12. Коллекции
	
  Описание скрипта: примеры определения вложенных таблиц
*/

---- Пример 1. Вложенная таблица с элементами типа number, определение на уровне схемы
create or replace type t_numbers  is  table  of  number(30,0);
/
declare
  v_array t_numbers; -- переменная типа вложенная таблица
begin
  null; 
end;
/

---- Пример 2. Вложенная таблица с элементами типа date, определение на уровне PL/SQL-блока
declare
  type t_dates is table of date; -- определяем тип
  v_array t_dates; -- переменная типа вложенная таблица
begin
  null; 
end;
/

---- Пример 3. Вложенная таблица с элементами типа boolean, определение на уровне PL/SQL-блока 
declare
  type t_booleans is table of boolean;-- определяем тип
  v_array t_booleans; -- переменная типа вложенная таблица
begin
  null;
end;
/

---- Пример 4. Попытка создать вложенную таблицу на уровне схемы с не SQL-типом -> ошибка
create or replace type t_booleans is table of boolean;
/

show errors;

