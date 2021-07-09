/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  Дата: 20.03.2021

  Описание скрипта: примеры со строковыми типами
*/ 

---- Пример 1. Объявление переменных с типами char, varchar2
declare
  v_str_char char(10 char) := 'Hello';
  v_str_v2   varchar2(10 char) := 'Hello';
begin
  dbms_output.put_line('v_str_char = ' || v_str_char); -- будет дополнено пробелами
  dbms_output.put_line('v_str_v2 = ' || v_str_v2); -- будет выведено как записали
end;
/

---- Пример 2. По умолчанию значение равно NULL. При этом пустая строка не равна NULL.
declare
  v_null_char char(10 char); -- по умолчанию null
  v_empty_char char(10 char) := '';
begin
  dbms_output.put_line(v_null_char);-- выведет "ничего"

  if v_null_char is null then
    dbms_output.put_line('v_null_char равна null'); 
  end if;
    if v_empty_char is null then
    dbms_output.put_line('v_empty_char равна null'); 
  end if;
end;
/

---- Пример 3. Особенность указания длины в byte и char
declare
  v_str_byte varchar2(6);
begin
  v_str_byte := 'Privet'; -- отработает отлично. 6 байт. Помещаются.
  v_str_byte := 'Привет'; -- отработает с ошибкой. 6 символов => 12 байт. Не помещаются (character string buffer too small)
end;
/

declare
  v_str_char varchar2(6 char);
begin
  v_str_char := 'Privet'; -- отработает отлично. 6 байт. Помешаются.
  v_str_char := 'Привет'; -- отработает отлично. 6 символов => 12 байт. Помещается, т.к. длина указан в символах.
end;
/

---- Пример 4. Сравнение между собой
declare
  v_str_char char(20 char) := 'Hello World';
  v_str_v2   varchar2(20 char) := 'Hello World';
begin
  if v_str_v2 = v_str_char then -- условие не выполнится, так сравнивать нельзя
    dbms_output.put_line('char равен varchar2');
  end if;
  
  if v_str_v2 = trim(v_str_char) then -- условие выполнится, мы удалили пробелы
    dbms_output.put_line('trim');
  end if;
  
  if rpad(v_str_v2, 20) = v_str_char then -- условие выполнится, мы дополнили пробелами v2
    dbms_output.put_line('rpad');
  end if;
  
end;
/
