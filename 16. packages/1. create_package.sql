/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 16. Пакеты
	
  Описание скрипта: пример создания пакетов

*/


----- Пример 1. Создание пакета, состоящего из пустой спецификации. Это допустимо.

-- 1. Спецификация (определение):
create or replace package currency_checker_pack is

end;
/

select status, t.object_type, t.* from user_objects t where t.object_name = 'CURRENCY_CHECKER_PACK';



---- Пример 2. Наполнение спецификации

-- 1. Спецификация (определение):
create or replace package currency_checker_pack is

  -- Определение констант
  c_usd_code constant char(3 char) := 'USD';
	c_rub_code constant char(3 char) := 'RUR';

end;
/

select status, t.object_type, t.* from user_objects t where t.object_name = 'CURRENCY_CHECKER_PACK';


-- Тестируем функционал 
begin
  dbms_output.put_line('Долларовый код: ' || currency_checker_pack.c_usd_code); -- можно использовать константу пакета
  dbms_output.put_line('Рублевый код: ' || currency_checker_pack.c_rub_code); -- можно использовать константу пакета
end;
/


---- Пример 3. Добавляем тело пакета с логикой

-- 1. Спецификация (определение):
create or replace package currency_checker_pack is

  -- Определение констант
  c_usd_code constant char(3 char) := 'USD';
	c_rub_code constant char(3 char) := 'RUR';

  -- Процедура проверки значения на предмет валютного кода (определение)
  procedure check_currency_code(p_currency_code_for_check char);

end;
/

-- 2. Тело пакета (реализация):
create or replace package body currency_checker_pack is

  -- Процедура проверки значения на предмет валютного кода (реализация)
  procedure check_currency_code(p_currency_code_for_check char) is
  begin
    if p_currency_code_for_check in (c_usd_code, c_rub_code) then
      dbms_output.put_line(p_currency_code_for_check || ' - допустимый код валюты :)');
    else
      dbms_output.put_line(p_currency_code_for_check || ' - не допустимый код валюты :(');
    end if;
  end;

end;
/

select status, t.object_type, t.* from user_objects t where t.object_name = 'CURRENCY_CHECKER_PACK';

-- Тестируем наш пакет 
begin
  currency_checker_pack.check_currency_code('USD'); -- вызываем процедуру пакета
  currency_checker_pack.check_currency_code('EUR'); -- вызываем процедуру пакета
  currency_checker_pack.check_currency_code(currency_checker_pack.c_rub_code); -- можно использовать константу пакета
end;
/

