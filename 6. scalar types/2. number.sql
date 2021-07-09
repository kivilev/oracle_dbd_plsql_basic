/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  Дата: 20.03.2021

  Описание скрипта: примеры с числами
*/

---- Пример 1. Объявление переменных с типами number, pls_integer
declare
  v_num3      number(3) := 999;
  v_num3_2    number(3, 2) := 9.99;
  v_num3_min1 number(3, -1) := 999;
  v_pls       pls_integer := 222.2;
begin
  dbms_output.put_line('number(3) = ' || v_num3);
  dbms_output.put_line('number(3,2) = ' || v_num3_2);
  dbms_output.put_line('number(3,-1) = ' || v_num3_min1);
  dbms_output.put_line('pls_integer = ' || v_pls);
end;
/

---- Пример 2. По умолчанию присваивает null
declare
  v_num3 number(3); -- значение будет равно null
  v_sum  number(3) := 10;
begin
  dbms_output.put_line('v_num3 = ' || v_num3);
  dbms_output.put_line('v_sum = ' || v_sum);

  v_sum := v_sum + v_num3; -- 10 + null => null. внимательно! могут быть ошибки

  dbms_output.put_line('new v_sum = ' || v_sum);
end;
/

---- Пример 3. Преобразование строки в number
declare
  v_str1 varchar2(20 char) := '30.2';
  v_str2 varchar2(20 char) := '50';
  v_str3 varchar2(20 char) := '$250.32'; -- с знаком валюты
  v_str4 varchar2(20 char) := '10,100.22'; -- с разделителями тысяч
  v_num  number(10,2);
begin
  v_num := to_number(v_str1, '99999.99'); -- для дробных может понадобиться маска, т.к. есть различия в знаке дробной части мб точка или зпт
  dbms_output.put_line('v_num = ' || v_num); 
  
  v_num := to_number(v_str2);
  dbms_output.put_line('v_num = ' || v_num); 
  
  v_num := to_number(v_str3, '$99999.99');
  dbms_output.put_line('v_num = ' || v_num); 

  v_num := to_number(v_str4, '999,999,999.99');
  dbms_output.put_line('v_num = ' || v_num);   
end;
/
