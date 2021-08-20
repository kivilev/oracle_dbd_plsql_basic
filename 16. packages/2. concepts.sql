/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 16. Пакеты
	
  Описание скрипта: демонстрация концепции пакетов

*/

---- Пример 1. Сокрытие информации

-- 1. Спецификация (определение):
create or replace package my_pack is

  -- Определение констант
  c_usd_code constant char(3 char) := 'USD';
  c_rub_code constant char(3 char) := 'RUR';

  -- Процедура проверки значения на предмет валютного кода (определение)
  procedure check_currency_code(p_currency_code char);

end;
/

-- 2. Тело пакета (реализация):
create or replace package body my_pack is

  g_print_enable boolean := true; -- скрытая глобаальная переменная пакета

  procedure print(p_str varchar2) -- скрытая от всех процедура
  is
  begin
    if g_print_enable then 
      dbms_output.put_line('print: '||p_str);
    end if;
  end;

	-- Процедура проверки значения на предмет валютного кода (реализация)
	procedure check_currency_code(p_currency_code char)
	is
	begin
	   if p_currency_code in (c_usd_code, c_rub_code) then
	      print('передан допустимый код валюты :)');
	   else
	      print('передан не допустимый код валюты :(');
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


---- Пример 2. Инициализация

-- 1. Спецификация (определение):
create or replace package my_pack is

  -- Процедура проверки значения на предмет валютного кода (определение)
  procedure check_currency_code(p_currency_code char);

end;
/

-- 2. Тело пакета (реализация):
create or replace package body my_pack is

  type t_currency_codes is table of char(3 char);
  g_currency_codes t_currency_codes := t_currency_codes('USD', 'RUR'); -- при создании происходит 1 раз инициализация

	-- Процедура проверки значения на предмет валютного кода (реализация)
	procedure check_currency_code(p_currency_code char)
	is
	begin
	   if p_currency_code member of g_currency_codes then
	      dbms_output.put_line('передан допустимый код валюты :)');
	   else
	      dbms_output.put_line('передан не допустимый код валюты :(');
	   end if;
	end; 

begin
  dbms_output.put_line('это блок инициализации. выполнится 1 раз.');
  -- g_currency_codes := t_currency_codes('USD', 'RUR'); -- можно было здесь инициализировать
end;
/


-- Тестируем функционал 
begin
  my_pack.check_currency_code('USD'); -- вызываем процедуру пакета
  my_pack.check_currency_code('EUR'); -- вызываем процедуру пакета  
  my_pack.check_currency_code('RUR'); -- можно использовать константу пакета
end;
/


---- Пример 3. Постоянство в течении сеанса
create or replace package my3_pack is

  -- Определение констант
  c_usd_code constant char(3 char) := 'USD';
  c_rub_code constant char(3 char) := 'RUR';
  
  -- Просто переменная (изначально пустая)
  g_os_user   varchar2(200 char);
  
end;
/

-- Тестируем
begin
  dbms_output.put_line('Os user (до): '|| my3_pack.g_os_user);

  my3_pack.g_os_user := sys_context('userenv', 'os_user'); -- сохранили в переменную пакета имя OS юзера

  dbms_output.put_line('Os user (присвоили): '|| my3_pack.g_os_user);

  commit;
  rollback;

  dbms_output.put_line('Os user (после изменения транзакций): '|| my3_pack.g_os_user);  
end;
/

-- Сбросим состояние пакета
alter package my3_pack compile;

