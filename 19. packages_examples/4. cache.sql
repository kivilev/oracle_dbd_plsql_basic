------- Пример использования. Кэширование

drop table currency;
create table currency
(
  curr_id  number(10),
  iso_code char(3 char)
);

-- загрузили данными
insert into currency values (643, 'RUB');  
insert into currency values (810, 'RUR');
insert into currency values (840, 'USD');
commit;


--- Создаем спецификацию пакета
create or replace package example_cache_currency_pack is
  -- внутренний тип
  type t_curr_code is table of currency.iso_code%type index by pls_integer;

  -- функция возвращающая код
  function get_code_by_curr_id(pi_curr_id currency.curr_id%type) return currency.iso_code%type;

end;
/

--- Создаем тело пакета
create or replace package body example_cache_currency_pack is

  g_currency_array t_curr_code; -- глобальня приватная переменная

  -- кэшируем справочник
  procedure init_currencies is
  begin
    if g_currency_array.count() = 0 then -- если коллекция без элементов, значит еще ни разу не кэшировали
      dbms_output.put_line('кэшируем...');

      for i in (select * from currency) loop -- в цикле заполняем коллекцию
        g_currency_array(i.curr_id) := i.iso_code;
      end loop;
    end if;
  end;


  -- функция возвращающая код
  function get_code_by_curr_id(pi_curr_id currency.curr_id%type) return currency.iso_code%type
  is
    v_out currency.iso_code%type := null;
  begin
    init_currencies(); -- вызываем заполнение валюты

    if g_currency_array.exists(pi_curr_id) then
      v_out := g_currency_array(pi_curr_id);
    end if;
    return v_out;
  end;
  
end;
/


------ Тестируем
begin
   dbms_output.put_line('643: '||example_cache_currency_pack.get_code_by_curr_id(643) );     
end;
/

begin
  dbms_output.put_line('1: '  ||example_cache_currency_pack.get_code_by_curr_id(1) );  
end;
/

begin
  dbms_output.put_line('840: '  ||example_cache_currency_pack.get_code_by_curr_id(840) );  
end;
/

