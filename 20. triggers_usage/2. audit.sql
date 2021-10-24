/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 20. Использование триггеров
  
  Описание скрипта: аудит изменения данных

  delete from client_data t where t.client_id = 555;
  delete from payment_detail t
   where t.payment_id in (select t.payment_id
                            from payment t
                           where t.from_client_id = 555
                              or t.to_client_id = 555);
  delete from payment t where t.from_client_id = 555 or t.to_client_id = 555;
  delete from client t where t.client_id = 555;
  delete from client_aud;
  drop table client_aud;
*/

---- Создадим таблицу аудита для клиента
create table client_aud (
  -- поля для аудита (их может быть гораздо больше)
  operation_type     char(1) not null,
  os_user            varchar2(128 char) not null,  
  audit_dtime        timestamp default systimestamp not null,
  -- бизнес поля
  client_id          number(30) not null,
  new_is_active      number(1),
  old_is_active      number(1),
  new_is_blocked     number(1),
  old_is_blocked     number(1),
  new_blocked_reason varchar2(1000 char),
  old_blocked_reason varchar2(1000 char)
);

alter table client_aud add constraint client_aud_chk check (operation_type in ('I', 'U', 'D'));


--- Триггер, который логирует измененные значения
create or replace trigger client_a_iud_audit
after -- после
insert or update or delete
on client -- на таблице client
for each row -- для каждой стркои
declare
  v_operation_type client_aud.operation_type%type;
  v_client_id      client.client_id%type;
  v_os_user        user_objects.object_name%type;
begin
  -- доп информация
  v_operation_type := case when inserting then 'I' when updating then 'U' else 'D' end; -- тип операции
  v_os_user := sys_context('userenv', 'OS_USER'); -- OS user
  v_client_id := nvl(:new.client_id, :old.client_id); -- ID клиента для любой операции
  
  -- вставка в аудит
  insert into client_aud(operation_type,
                         os_user,
                         audit_dtime,
                         client_id,
                         new_is_active,
                         old_is_active,
                         new_is_blocked,
                         old_is_blocked,
                         new_blocked_reason,
                         old_blocked_reason)
 values (v_operation_type, v_os_user, systimestamp, v_client_id, :new.is_active, :old.is_active,
        :new.is_blocked, :old.is_blocked, :new.blocked_reason, :old.blocked_reason);
end;
/

---- выполним операции над клиентом
-- вставка
insert into client(client_id,is_active,is_blocked,blocked_reason,create_dtime_tech,update_dtime_tech)
values(555, 1, 0, null, sysdate, sysdate);

select * from client_aud t order by t.audit_dtime desc;

-- обновление
update client cl
  set cl.is_blocked = 1
     ,cl.blocked_reason = 'Тестовая блокировка'
  where cl.client_id  = 555;     

select * from client_aud t order by t.audit_dtime desc;

-- удаление
delete from client t where t.client_id = 555;

select * from client_aud t order by t.audit_dtime desc;

