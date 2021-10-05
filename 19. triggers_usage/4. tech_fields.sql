/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 19. Использование триггеров
  
  Описание скрипта: управление тех полями

  delete from client t where t.client_id = 555;
  commit;
*/

--- Триггер, который изменяет технические поля
create or replace trigger client_b_iu_tech
before -- до
insert or update
on client -- на таблице client
for each row -- для каждой стркои
declare
  v_current_dtime client.update_dtime_tech%type := systimestamp;
begin
  -- для INSERT
  if inserting then
    :new.create_dtime_tech := v_current_dtime;
  end if;

  -- поле с датой обновления изменяется всегда при изменениях
  :new.update_dtime_tech := v_current_dtime;
end;
/

---- выполним операции над клиентом
-- вставка
insert into client(client_id,is_active,is_blocked,blocked_reason)
values(555, 1, 0, null);

select systimestamp, t.* from client t where t.client_id = 555;


-- обновление
update client cl
  set cl.is_blocked = 1
     ,cl.blocked_reason = 'Тестовая блокировка'
  where cl.client_id  = 555;

select systimestamp, t.* from client t where t.client_id = 555;
