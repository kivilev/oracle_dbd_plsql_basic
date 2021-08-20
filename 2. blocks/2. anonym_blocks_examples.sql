/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  
	Лекция 2. Блоки
  
	Описание скрипта: примеры анонимных блоков с разными частями
*/ 

---- Пример 1. Анонимный блок с обязательным исполняемым разделом
begin
  dbms_output.put_line ('Hello world!');
end;
/


---- Пример 2. Анонимный блок с разделом объявлений и исполняемым разделом
declare
  v_str varchar2(100 char) := 'Hello world!';
begin
  dbms_output.put_line (v_str);
end;
/


---- Пример 3. Анонимный блок с разделами объявления, исполняемым и обработки ошибок
declare
  v_str varchar2(100 char) := 'Hello world!';
  v_n   number;
begin  
  dbms_output.put_line(v_str);
  v_n := 10/2;
exception 
  when others then
    dbms_output.put_line ('Возникла ошибка: '||sqlerrm);
end;
/
