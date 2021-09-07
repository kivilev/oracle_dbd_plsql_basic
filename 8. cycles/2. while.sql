/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 8. Циклы

  Описание скрипта: примеры с WHILE (пока выполняется условие)
*/

---- Пример 1. Инкремент
declare
  v_i    number(30) := 0;
begin
  while v_i <= 10 loop
    v_i := v_i + 1;
    dbms_output.put_line('v_i: ' || v_i);
  end loop;
end;
/

---- Пример 2. Boolean
declare
  v_i    number(30) := 0;
  v_flag boolean := true;
begin
  while v_flag loop
    v_i := v_i + 1;
    dbms_output.put_line('v_i: ' || v_i);
    
    if v_i = 10 then
      dbms_output.put_line('flag := false. Выход из цикла.'); 
      v_flag := false;
    end if;
  end loop;
end;
/
