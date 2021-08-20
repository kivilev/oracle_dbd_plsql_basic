/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 5. Область действия и видимость
  
  Описание скрипта: обычные и уточненные идентификаторы
*/

---- Пример 1. Обычные идентификаторы
declare
  v_var1 number(3) := 100;
begin
  dbms_output.put_line('v_var1: '||v_var1); -- уточнение не нужно
  
  declare
    v_var2 number(3) := 999;
  begin
    dbms_output.put_line('v_var1: '||v_var1); -- уточнение не нужно
    dbms_output.put_line('v_var2: '||v_var2);    
  end;  

end;
/

---- Пример 2. Уточненные идентификаторы (не работает в PL/SQL Developer'e)
<<main_block>>
declare
  v_var1 number(3) := 100;
begin
  dbms_output.put_line('v_var1: '||v_var1); -- уточнение не нужно
  
  <<local_block>>
  declare
	v_var1 number(3) := 999;
  begin
	dbms_output.put_line('v_var1 with label (main_block): '||main_block.v_var1); -- обязательно нужно уточнить
	dbms_output.put_line('v_var1 (local_block): '||v_var1); -- уточнение не нужно
	dbms_output.put_line('v_var1 with label (local_block): '||local_block.v_var1); -- уточним, ради тренировки
  end;  

end main_block;
/


