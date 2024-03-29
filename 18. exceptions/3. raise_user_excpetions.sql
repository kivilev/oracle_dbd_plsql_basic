/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 18. Исключения
	
  Описание скрипта: примеры возбуждения исключений
*/

---- Пример 1. Возбуждение системного именованного исключения
begin
  raise no_data_found;
end;
/

---- Пример 2. Возбуждение пользовательского исключения
declare
  e_my exception;
begin
  raise e_my;
end;
/

---- Пример 3. Возбуждение пользовательского исключения
begin
  raise_application_error(-20101, 'АААА ошибка!!');
end;
/
