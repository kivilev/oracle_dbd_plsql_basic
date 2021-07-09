/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  Дата: 08.04.2021

  Лекция 4. Данные программы

  Описание скрипта: примеры создания переменных
*/ 

declare
  v_var0  number;
  v_var1  number not null := 100;
  v_var2  number := 200;
begin
  dbms_output.put_line('v_var0: '||v_var0);
  dbms_output.put_line('v_var1: '||v_var1);
  dbms_output.put_line('v_var2: '||v_var2);  

  v_var0 := 777;  
  dbms_output.put_line('v_var0: '||v_var0);
  
  -- v_var1 := null; -- ошибка, т.к. зачение переменной не может быть null  
end;
/
