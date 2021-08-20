/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 14. Использование SQL в PL/SQL
	
  Описание скрипта: примеры управления транзакциями в PL/SQL

*/

---- Пример 1. Управление транакциями
begin
  savepoint sp1;
  
	-- что-то делаем
	
  rollback to sp1;
  commit; 
end;
/
