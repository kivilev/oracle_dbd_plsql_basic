/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  Дата: 20.03.2021

  Описание скрипта: примеры с типами дата/время
*/

---- Пример 1. Объявление переменных с типом date
declare
  v_date_sysdate date := sysdate; -- текушая дата/время
  v_date_1407    date := date '1983-07-14';-- удобный способ задавать дату
  v_date_def     date; -- по умолчанию null
begin
  -- Если выводить как есть, то вывод будет соответствовать региональным настройкам
  dbms_output.put_line('v_date_sysdate (по умолчанию) => ' || v_date_sysdate); -- не выводится время
  dbms_output.put_line('v_date_sysdate (с форматом) => ' || to_char(v_date_sysdate, 'dd.mm.yyyy hh24:mi:ss')); -- добавляем формат вывода

  dbms_output.put_line('v_date_1407 (по умолчанию) => ' || v_date_1407);
  dbms_output.put_line('v_date_1407 (с форматом) => ' || to_char(v_date_1407, 'dd.mm.yyyy hh24:mi:ss'));
  
  dbms_output.put_line('v_date_def  => ' || v_date_def);
end;
/

---- Пример 2. Объявление переменных с типом timestamp
declare
  v_ts_systs timestamp := systimestamp; -- текушая дата/время
  v_ts_1407  timestamp := timestamp '1983-07-14 12:22:33.777777'; -- удобный способ задать timestamp
  v_ts_def   timestamp; -- по умолчанию null
begin
  -- Если выводить как есть, то вывод будет соответствовать региональным настройкам
  dbms_output.put_line('v_ts_systs (по умолчанию) => ' || v_ts_systs); -- формат по умолчанию
  dbms_output.put_line('v_ts_systs (с форматом) => ' || to_char(v_ts_systs, 'dd.mm.yyyy hh24:mi:ss.ff6')); -- добавляем формат вывода

  dbms_output.put_line('v_ts_1407 (по умолчанию) => ' || v_ts_1407);
  dbms_output.put_line('v_ts_1407 (с форматом) => ' || to_char(v_ts_1407, 'dd.mm.yyyy hh24:mi:ss.ff6'));
  
  dbms_output.put_line('v_ts_def   => ' || v_ts_def);
  
end;
/

---- Пример 3. Конвертация из строк в date/timestamp
declare
  v_v2_2101 varchar2(30 char) := '21.01.1984 13:00:49';
  v_date    date;
  v_v2_1407 varchar2(30 char) := '14.07.1983 12:22:33.777777';
  v_ts      timestamp;
  v_v2_iso  varchar2(30 char) := '1983-07-14T12:22:33';
  v_date2   date;
begin
  v_date  := to_date(v_v2_2101, 'dd.mm.yyyy hh24:mi:ss');
  v_ts    := to_timestamp(v_v2_1407, 'dd.mm.yyyy hh24:mi:ss.ff6');
  v_date2 := to_date(v_v2_iso, 'yyyy-mm-dd"T"hh24:mi:ss');
end;
/
