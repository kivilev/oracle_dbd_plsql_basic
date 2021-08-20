/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 3. Специальные символы, идентификаторы, литералы

  Описание скрипта: примеры NULL - литералов
*/ 

---- Пример 1. Пустое или неопределенное значение
declare
  v_str varchar2(20 char) := 'Hello world';
begin
  v_str := null;
  dbms_output.put_line(v_str); -- будет выведена пустая строка
end;
/


---- Пример 2. Ничегонеделание. Пустое дествие
begin
  null;
end;
/
