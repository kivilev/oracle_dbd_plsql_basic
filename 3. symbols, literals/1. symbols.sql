/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 3. Специальные символы, идентификаторы, литералы

  Описание скрипта: специальные символы в PL/SQL
*/ 

---- Пример 1. ";" - завершает команду
begin
  dbms_output.put_line('Hello World 1');
end;
/


---- Пример 2. ":=" - присваивает значение в переменную
declare 
  v_str varchar2(20 char) := 'Hello world 2!';
begin
  dbms_output.put_line(v_str);
end;
/


---- Пример 3. "**" - возведение в степень. 2^3 => 8
begin
  dbms_output.put_line(2**3);
end;
/


---- Пример 4. "--" - однострочный комментарий
begin
  -- выводим строчку Hello World
  dbms_output.put_line('Hello World 4 ');
end;
/


---- Пример 5. "/**/" - многострочный комментарий
begin
  /* 
     Автор: Кивилев ДС 
	 Программа по выводу строки "Hello World"
  */
  dbms_output.put_line('Hello World 5');
end;
/
