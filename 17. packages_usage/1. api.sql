/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 16. Использование пакетов
	
  Описание скрипта: использование пакетов для создания API

*/

-- табличка с валютами
drop table my_currency;
create table my_currency
(
  curr_id  number(10),
  iso_code char(3 char)
);

alter table my_currency add constraint my_currency_pk primary key (curr_id);


create or replace package my_currency_pack is

  -- Purpose : Api for my_currency table

  -- Create new row
  procedure create_my_currency
  (
    p_curr_id  my_currency.curr_id%type
   ,p_iso_code my_currency.iso_code%type
  );

  -- Update row
  procedure update_my_currency
  (
    p_curr_id      my_currency.curr_id%type
   ,p_new_iso_code my_currency.iso_code%type
  );

  -- Delete row
  procedure delete_my_currency(p_curr_id my_currency.curr_id%type);

end my_currency_pack;
/

create or replace package body my_currency_pack is

  -- Create new row
  procedure create_my_currency
  (
    p_curr_id  my_currency.curr_id%type
   ,p_iso_code my_currency.iso_code%type
  ) is
  begin
    insert into my_currency
      (curr_id
      ,iso_code)
    values
      (p_curr_id
      ,p_iso_code);
  exception
    when dup_val_on_index then
      raise_application_error(-20100,
                              'Валюта с кодом "' || p_curr_id || '" уже есть');
  end;

  -- Update row
  procedure update_my_currency
  (
    p_curr_id      my_currency.curr_id%type
   ,p_new_iso_code my_currency.iso_code%type
  ) is
  begin
    update my_currency c
       set c.iso_code = p_new_iso_code
     where c.curr_id = p_curr_id;
  end;

  -- Delete row
  procedure delete_my_currency(p_curr_id my_currency.curr_id%type) is
  begin
    delete my_currency c where c.curr_id = p_curr_id;
  end;

end my_currency_pack;
/

---- Тестируем
begin
  my_currency_pack.create_my_currency(p_curr_id => 840, p_iso_code => 'USD');
  my_currency_pack.create_my_currency(p_curr_id => 810, p_iso_code => 'RUR');  
end;
/

select * from my_currency;
