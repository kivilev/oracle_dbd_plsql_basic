/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 16. Пакеты
	
  Описание скрипта: демонстрация концепции пакетов

*/

---- Пример 1. Инициализация

-- 1. Спецификация (определение):
create or replace package currency_checker_pack is

  -- Определение констант
  c_usd_code constant char(3 char) := 'USD';
  c_rub_code constant char(3 char) := 'RUR';

  -- Процедура проверки значения на предмет валютного кода (определение)
  procedure check_currency_code(p_currency_code char);

end;
/

-- 2. Тело пакета (реализация):
create or replace package body currency_checker_pack is

  type t_currency_codes is table of char(3 char);
  g_currency_codes t_currency_codes;-- при создании происходит 1 раз инициализация

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
  g_currency_codes := t_currency_codes(c_usd_code, c_rub_code);
end;
/

-- Тестируем функционал 
begin
  currency_checker_pack.check_currency_code('USD'); -- вызываем процедуру пакета
  currency_checker_pack.check_currency_code('EUR'); -- вызываем процедуру пакета  
  currency_checker_pack.check_currency_code('RUR'); -- можно использовать константу пакета
end;
/


---- Пример 2. Постоянство в течении сеанса
create or replace package session_cache_pack is

  -- Просто переменные (изначально пустые)
  g_os_user   varchar2(200 char); -- OS user
	g_business_role     varchar2(200 char); -- Бизнес роль
  
end;
/

-- Тестируем
begin
  -- поставим точку сохранения
  savepoint sp1;
  
  dbms_output.put_line('До установки. Os user: '|| session_cache_pack.g_os_user ||'. Бизнес роль: ' ||session_cache_pack.g_business_role);

  session_cache_pack.g_os_user := 'd_kivilev'; -- сохранили в переменную пакета имя OS юзера
  session_cache_pack.g_business_role := 'Developer'; -- сохранили в переменную пакета Бизнес-роль

  dbms_output.put_line('Посе установки. Os user: '|| session_cache_pack.g_os_user ||'. Бизнес роль: ' ||session_cache_pack.g_business_role);
  
  -- переменной пакета все равно на транзакции
  rollback to sp1;-- откатимся на sp1.
  commit;
  
  dbms_output.put_line('После изменения транзакции. Os user: '|| session_cache_pack.g_os_user ||'. Бизнес роль: ' ||session_cache_pack.g_business_role);
end;
/

-- Сбросим состояние пакета его компиляцией
alter package session_cache_pack compile;

-- Проверим
begin
  dbms_output.put_line('После сброка состояния пакета. Os user: '|| session_cache_pack.g_os_user ||'. Бизнес роль: ' ||session_cache_pack.g_business_role);
end;
/

