/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 16. Пакеты
	
  Описание скрипта: демонстрация концепции пакетов

*/

---- Пример 1. Сокрытие данных, модулей

-- 1. Спецификация (определение):
create or replace package currency_checker_pack is

  -- Определение констант
  c_usd_code constant char(3 char) := 'USD';
  c_rub_code constant char(3 char) := 'RUR';

  -- Функция проверки значения на предмет валютного кода (определение)
  function check_currency_code(p_currency_code_for_check char) return number;

end;
/

-- 2. Тело пакета (реализация):
create or replace package body currency_checker_pack is

  g_print_enable boolean := true; -- скрытая глобальная переменная пакета. Выводить в буфер вывода или нет.

  procedure print(p_str varchar2) -- скрытая от всех процедура вывода в буфер вывода
  is
  begin
    if g_print_enable then -- в зависимости от глобальной переменной выводим или нет
      dbms_output.put_line('print: '||p_str);
    end if;
  end;

	-- Функция проверки значения на предмет валютного кода (реализация)
  function check_currency_code(p_currency_code_for_check char) return number  
	is
	begin
	   if p_currency_code_for_check in (c_usd_code, c_rub_code) then
	      print(p_currency_code_for_check || ' - допустимый код валюты :)'); -- вызов внутр процедуры
        return 1;
	   else
	      print(p_currency_code_for_check || ' - не допустимый код валюты :('); -- вызов внутр процедуры
        return 0;
	   end if;
	end; 

end;
/

select status, t.object_type, t.* from user_objects t where t.object_name = 'CURRENCY_CHECKER_PACK';

-- Тестируем функционал 
begin
  dbms_output.put_line( currency_checker_pack.check_currency_code('USD') ); -- вызываем функцию пакета
  dbms_output.put_line( currency_checker_pack.check_currency_code('EUR') ); -- вызываем функцию пакета  
  dbms_output.put_line( currency_checker_pack.check_currency_code(currency_checker_pack.c_rub_code) ); -- можно использовать константу пакета
end;
/

