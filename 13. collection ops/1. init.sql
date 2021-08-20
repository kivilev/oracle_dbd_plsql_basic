/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 13. Операции с коллекциями
	
  Описание скрипта: примеры инициализации коллекций
*/

---- Пример 1. Инициализация пустой коллекции
declare
  type t_array is table of number(30);
  v_array t_array := t_array();
begin
  null;
end;
/


---- Пример 2. Инициализация коллекции с элементами
declare
  type t_array is table of number(30);
  v_array t_array := t_array(100, 200, 300, 777, 1000);
begin
  null;
end;
/
