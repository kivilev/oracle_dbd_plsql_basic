/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 17. Использование пакетов
	
  Описание скрипта: создания прокси-оберток
  
  delete from currency;

*/

create or replace package support_currency_pack is

  -- Purpose : Прокси-пакет, урезающий функционал

  -- Create new row
  procedure create_currency(p_curr_id  currency.curr_id%type
                           ,p_iso_code currency.iso_code%type);

end;
/

create or replace package body support_currency_pack is

  -- Create new row
  procedure create_currency(p_curr_id currency.curr_id%type, p_iso_code currency.iso_code%type) is
  begin
    currency_pack.create_currency(p_curr_id => p_curr_id, p_iso_code => p_iso_code);
  end;

end;
/

-- даем грант на вызов этого пакет какому-то другому пользователю или роли
grant execute on support_currency_pack to d_kivilev;

select * from currency;


---- Тестируем в учетке d_kivilev
-- ошибка
begin
  hr.currency_pack.create_currency(p_curr_id => 840, p_iso_code => 'USD');
  hr.currency_pack.create_currency(p_curr_id => 810, p_iso_code => 'RUR');  
end;
/

-- ок
begin
  hr.support_currency_pack.create_currency(p_curr_id => 840, p_iso_code => 'USD');
  hr.support_currency_pack.create_currency(p_curr_id => 810, p_iso_code => 'RUR');  
end;
/
