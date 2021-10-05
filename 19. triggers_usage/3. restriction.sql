/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 19. Использование триггеров
  
  Описание скрипта: управление тех полями

  delete from client t where t.client_id = 555;
  commit;
*/

--- Триггер, который предотвращает удаление
create or replace trigger client_b_d_restriction
before -- до
delete 
on client -- на таблице client
declare
begin
  dbms_output.put_line('Нельзя удалить клиента. Можно только деактивировать.');
  -- raise_application_error(-20100, 'Нельзя удалить клиента. Можно только деактивировать.');
end;
/

---- попробуем удалить
delete from client t where t.client_id = 555;

