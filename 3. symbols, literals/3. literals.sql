/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  Дата: 08.04.2021

  Лекция 3. Специальные символы, идентификаторы, литералы

  Описание скрипта: примеры литералов
*/ 

---- Пример 1. Числовые литералы
declare
  v_n1 number := 1000; -- 1000 это и есть литерал
begin
  if v_n1 = 500 then -- 500 это литерал
    null;
  end if;

end;
/


---- Пример 2. Строковый и boolean литералы
declare
  v_str varchar2(200 char) := 'Hello World'; -- "Hello World" это строковый литерал
  v_print boolean := true; -- "true" - это литерал типа boolean
begin
  if v_print then
    dbms_output.put_line('Good luck'); -- "Good luck" это строковый литерал
  end if;
end;
/


--- Пример 3. Кавычки в строковом литерале
begin
  dbms_output.put_line('co''nnect'); -- одна кавычка, будет выведено "co'nnect"
  dbms_output.put_line('con''''nect'); -- две кавычки, будет выведено "co''nnect" 
  dbms_output.put_line(q'{Ку'ч'а' 'к'а'вычек}'); -- отображается так как задано между {}.
end;
/
