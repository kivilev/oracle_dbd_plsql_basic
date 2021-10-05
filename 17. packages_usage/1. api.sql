/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 17. Использование пакетов
	
  Описание скрипта: использование пакетов для создания API

*/

-- табличка с валютами
drop table currency;
create table currency
(
  curr_id  number(10), -- цифровой код валюты
  iso_code char(3 char) -- символьный код валюты
);

alter table currency add constraint currency_pk primary key (curr_id);


create or replace package currency_pack is

  -- Purpose : Api for currency table

  -- Create new row
  procedure create_currency(p_curr_id  currency.curr_id%type
                           ,p_iso_code currency.iso_code%type);

  -- Update row
  procedure update_currency(p_curr_id      currency.curr_id%type
                           ,p_new_iso_code currency.iso_code%type);

  -- Delete row
  procedure delete_currency(p_curr_id currency.curr_id%type);

end;
/

create or replace package body currency_pack is

  -- Create new row
  procedure create_currency(p_curr_id  currency.curr_id%type
                           ,p_iso_code currency.iso_code%type) is
  begin
    insert into currency
      (curr_id
      ,iso_code)
    values
      (p_curr_id
      ,p_iso_code);
  end;
  
  -- Update row
  procedure update_currency(p_curr_id      currency.curr_id%type
                           ,p_new_iso_code currency.iso_code%type) is
  begin
    update currency c
       set c.iso_code = p_new_iso_code
     where c.curr_id = p_curr_id;
  end;
  
  -- Delete row
  procedure delete_currency(p_curr_id currency.curr_id%type) is
  begin
    delete currency c where c.curr_id = p_curr_id;
  end;

end;
/

---- Тестируем создание
begin
  currency_pack.create_currency(p_curr_id => 840, p_iso_code => 'USD');
  currency_pack.create_currency(p_curr_id => 810, p_iso_code => 'RUR');  
end;
/

select * from currency;

---- Тестируем обновление
begin
  currency_pack.update_currency(p_curr_id => 810, p_new_iso_code => 'РУБ');
end;
/
select * from currency;


---- Тестируем удаление
begin
  currency_pack.delete_currency(p_curr_id => 810);
end;
/

select * from currency;

