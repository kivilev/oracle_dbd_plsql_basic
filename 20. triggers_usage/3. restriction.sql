/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 20. Использование триггеров
	
  Описание скрипта: запрет прямых DML-команд через API + триггер

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

  -- Проверка выполняется ли через API
  procedure api_restriction;

end;
/

create or replace package body currency_pack is

  g_is_api boolean := false;

  -- Create new row
  procedure create_currency(p_curr_id  currency.curr_id%type
                           ,p_iso_code currency.iso_code%type) is
  begin
    g_is_api := true;
    insert into currency(curr_id, iso_code)values(p_curr_id, p_iso_code);
    g_is_api := false;
  exception 
    when others then  
      g_is_api := false;
      raise;
  end;

  -- Update row
  procedure update_currency(p_curr_id      currency.curr_id%type
                           ,p_new_iso_code currency.iso_code%type) is
  begin
    g_is_api := true;
    update currency c
       set c.iso_code = p_new_iso_code
     where c.curr_id = p_curr_id;
    g_is_api := false;
  exception 
    when others then  
      g_is_api := false;
      raise;      
  end;


  -- Delete row
  procedure delete_currency(p_curr_id currency.curr_id%type) is
  begin
    g_is_api := true;
    delete currency c where c.curr_id = p_curr_id;
    g_is_api := false;
  exception 
    when others then  
      g_is_api := false;
      raise;      
  end;


  procedure api_restriction
  is
  begin
    if not g_is_api then
      raise_application_error(-20101,'Данные можно менять только через API');
    end if;
  end;

end;
/

create or replace trigger currency_b_iud_api_restriction
before -- до
insert or update or delete -- все операции
on currency -- на таблице currency
declare
begin
  currency_pack.api_restriction();
end;
/


-- Создание через API - все отлично
begin
  currency_pack.create_currency(p_curr_id => 840, p_iso_code => 'USD');
end;
/

select * from currency;

-- Создание через API - все отлично
insert into currency(curr_id, iso_code)values(634, 'RUR');

