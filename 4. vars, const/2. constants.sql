/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 4. Данные программы

  Описание скрипта: примеры создания констант
*/ 


declare
  c_currency_usd_id constant number(3) := 840;
  c_currency_rub_id constant number(3) := 643;
begin
  dbms_output.put_line(c_currency_usd_id);
  dbms_output.put_line(c_currency_rub_id);
  
  -- c_currency_rub_id := 110; -- ошибка, не можем изменить значение константы
end;
/
