/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 19. Использование триггеров
  
  Описание скрипта: проверка данных

  delete from payment_detail t where t.payment_id = 777;
  delete from payment t where t.payment_id = 777;
  delete from client t where t.client_id = 555;
  commit;
*/

---- Создадим пакет с функционалом по валидации
create or replace package validation_pack is
  
  -- Описание: пакет по валидации значений

  -- проверка деталей платежа
  procedure check_payment_detail_field_value(p_field_id    payment_detail.field_id%type
                                            ,p_field_value payment_detail.field_value%type);

end;
/

create or replace package body validation_pack is

  procedure check_payment_detail_field_value(p_field_id    payment_detail.field_id%type
                                            ,p_field_value payment_detail.field_value%type) is
  begin
    dbms_output.put_line('Валидация поля. p_field_id: ' || p_field_id ||
                         '. p_field_value: ' || p_field_value);
  
    -- Проверка поля "IP"
    if p_field_id = 2
       and
       (length(p_field_value) < 7 or length(p_field_value) > 15 or regexp_count(p_field_value, '\.') != 3) then
    
      dbms_output.put_line('Значение "'|| p_field_value ||'" в поле "IP" невалидно');
      -- возбуждение исключения
    end if;
  
    -- и другие проверки ...
  end;

begin
  -- здесь кэшируем правила из настроечной таблицы
  null;
end;
/

--- Триггер, который валидирует значения перед вставкой и обновлением
create or replace trigger pament_detail_b_iu_validation
before -- до
insert or update of field_value  -- на вставку или обновление поля field_value
on payment_detail -- на таблице payment_detail
for each row -- для каждой стркои
when(old.field_value <> new.field_value or old.field_value is null or new.field_value is null)-- только когда меняется значение
begin
  validation_pack.check_payment_detail_field_value(:new.field_id, :new.field_value);
end;
/


-- создадим клиента и платеж, без них детали платежа вставить не получится
insert into client(client_id,is_active,is_blocked,blocked_reason,create_dtime_tech,update_dtime_tech)
values(555, 1, 0, null, sysdate, sysdate);

insert into payment(payment_id, create_dtime, summa, currency_id, from_client_id, to_client_id,
                    status, status_change_reason, create_dtime_tech, update_dtime_tech)
values (777, sysdate, 0, 634, 555, 555, 0, null, sysdate, sysdate);

commit;

-- вставка атрибута - валидное
insert into payment_detail(payment_id, field_id, field_value)
values(777, 2, '127.0.0.1');

update payment_detail t
   set field_value = '127.1.0.100'
  where payment_id = 777 and field_id = 2;

rollback;

-- вставка атрибута - невалидное
insert into payment_detail(payment_id, field_id, field_value)
values(777, 2, '127.0.0');
rollback;

