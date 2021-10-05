/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 16. Пакеты
	
  Описание скрипта: демонстрация концепции пакетов

*/

---- Создание справочника "Валюты"
drop table currency;
create table currency
(
  currency_id number(3) not null,
  alfa3       char(3 char) not null,
  description varchar2(100 char) not null
);

insert into currency values(634, 'RUB', 'Российский рубль');
insert into currency values(840, 'USD', 'Доллар США');
commit;


-- Спецификация (определение):
create or replace package common_pack is
  
    

end;
/

-- Тело пакета (реализация):
create or replace package body currency_checker_pack is

  type t_currency_codes is table of char(3 char);
  g_currency_codes t_currency_codes; -- глобальная переменная для сохранения данных
  g_last_update date; -- когда было последнее обновление
  g_update_interval interval day to second := interval '10' second;
 
  -- кэшируем данные таблицы в локальную коллекцию
  procedure update_cache is
    v_current_dtime g_last_update%type := sysdate;
  begin
    -- проверяем а не пора ли кэшировать
    if g_last_update is null or g_last_update <= v_current_dtime - g_update_interval then

      dbms_output.put_line('кэшируем коллекцию: '||to_char(sysdate, 'dd.mm.YYYY hh24:mi:ss'));

      -- сохраняем в коллекцию
      select c.alfa3
        bulk collect into g_currency_codes
        from currency c;

      g_last_update := v_current_dtime;-- обновляем дату кэширования
    end if;
  end;

	-- Процедура проверки значения на предмет валютного кода (реализация)
	procedure check_currency_code(p_currency_code_for_check char)
	is
	begin
    update_cache();-- каждый раз пробуем кэшировать

    if p_currency_code_for_check member of g_currency_codes  then
      dbms_output.put_line(p_currency_code_for_check || ' - допустимый код валюты :)');
    else
      dbms_output.put_line(p_currency_code_for_check || ' - не допустимый код валюты :(');
    end if;
	end;

end;
/

-- Тестируем функционал 
begin
  dbms_output.put_line('Текущее время: '||to_char(sysdate, 'dd.mm.YYYY hh24:mi:ss'));
  currency_checker_pack.check_currency_code('USD'); -- вызываем процедуру пакета
  currency_checker_pack.check_currency_code('EUR'); -- вызываем процедуру пакета  
  currency_checker_pack.check_currency_code('RUB'); -- можно использовать константу пакета
end;
/

