/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 15. Процедуры и функции
	
  Описание скрипта: пример функций в SQL 

*/

---- Пример 1. Функция на уровне схемы
create or replace function trim_low(p_str varchar2) return varchar2
is
begin
  return trim(lower(p_str)); 
end;
/

-- используем в SQL
select trim_low('Хелло! ') result 
  from dual;


---- Пример 2. Функция возвращающая не SQL-тип (boolean)
create or replace function is_good_day return boolean
is
begin
  return true;
end;
/

-- пробуем использовать в SQL => ORA-00902: invalid datatype
select is_good_day() result 
  from dual;

