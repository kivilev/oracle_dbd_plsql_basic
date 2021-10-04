/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 16. Пакеты
	
  Описание скрипта: пример создания пакетов

*/

---- Пример 1. Спецификация + тело

-- 1. Спецификация (определение):
create or replace package my_pack is

  -- Определение констант
  c_usd_code constant char(3 char) := 'USD';
	c_rub_code constant char(3 char) := 'RUR';

  -- Процедура проверки значения на предмет валютного кода (определение)
  procedure check_currency_code(pi_value char);

end;
/

-- 2. Тело пакета (реализация):
create or replace package body my_pack is
   
	-- Процедура проверки значения на предмет валютного кода (реализация)
	procedure check_currency_code(p_currency_code char)
	is
	begin
	   if p_currency_code in (c_usd_code, c_rub_code) then
	      dbms_output.put_line('передан допустимый код валюты :)'); 
	   else
	      dbms_output.put_line('передан не допустимый код валюты :('); 
	   end if;
	end;

end;
/

-- Тестируем функционал 
begin
  my_pack.check_currency_code('USD'); -- вызываем процедуру пакета
  my_pack.check_currency_code('EUR'); -- вызываем процедуру пакета  
  my_pack.check_currency_code(my_pack.c_rub_code); -- можно использовать константу пакета
end;
/


---- Пример 2. Создание только спефикации

-- 1. Спецификация (определение):
create or replace package my2_pack is

  -- Определение констант
  c_usd_code constant char(3 char) := 'USD';
	c_rub_code constant char(3 char) := 'RUR';

end;
/

-- Тестируем функционал 
begin
  dbms_output.put_line('Долларовый код: ' || my2_pack.c_usd_code); -- можно использовать константу пакета
  dbms_output.put_line('Рублевый код: ' || my2_pack.c_rub_code); -- можно использовать константу пакета
end;
/



