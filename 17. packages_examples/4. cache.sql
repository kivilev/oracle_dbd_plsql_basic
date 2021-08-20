/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 16. Использование пакетов
	
  Описание скрипта: использование пакета для кэширования

*/

drop table my_currency;
create table my_currency
(
  curr_id  number(10),
  iso_code char(3 char)
);

-- загрузили данными
insert into my_currency values (643, 'RUB');  
insert into my_currency values (810, 'RUR');
insert into my_currency values (840, 'USD');
commit;


--- Создаем спецификацию пакета
create or replace package example_cache_my_currency_pack is
  -- внутренний тип
  type t_curr_code is table of my_currency.iso_code%type index by pls_integer;

  -- функция возвращающая код
  function get_code_by_curr_id(pi_curr_id my_currency.curr_id%type) return my_currency.iso_code%type;

end;
/

--- Создаем тело пакета
create or replace package body example_cache_my_currency_pack is

  g_my_currency_array t_curr_code; -- глобальня приватная переменная

  -- кэшируем справочник
  procedure init_currencies is
  begin
    if g_my_currency_array.count() = 0 then -- если коллекция без элементов, значит еще ни разу не кэшировали
      dbms_output.put_line('кэшируем...');

      for i in (select * from my_currency) loop -- в цикле заполняем коллекцию
        g_my_currency_array(i.curr_id) := i.iso_code;
      end loop;
    end if;
  end;


  -- функция возвращающая код
  function get_code_by_curr_id(pi_curr_id my_currency.curr_id%type) return my_currency.iso_code%type
  is
    v_out my_currency.iso_code%type := null;
  begin
    init_currencies(); -- вызываем заполнение валюты

    if g_my_currency_array.exists(pi_curr_id) then
      v_out := g_my_currency_array(pi_curr_id);
    end if;
    return v_out;
  end;
  
end;
/


------ Тестируем
begin
   dbms_output.put_line('643: '||example_cache_my_currency_pack.get_code_by_curr_id(643) );     
end;
/

begin
  dbms_output.put_line('1: '  ||example_cache_my_currency_pack.get_code_by_curr_id(1) );  
end;
/

begin
  dbms_output.put_line('840: '  ||example_cache_my_currency_pack.get_code_by_curr_id(840) );  
end;
/

