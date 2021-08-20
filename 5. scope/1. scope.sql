/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 5. Область действия и видимость
  
  Описание скрипта: пример области действия данных
*/

---- Пример 1.

declare

  v_var1 number := 777; -- переменная видна везде

  procedure proc_inner(p_param number) -- параметр виден только в процедуре
   is
    v_var2 number := 888; -- переменная видна только в процедуре
  begin
    dbms_output.put_line('v_var1 (proc): ' || v_var1);
    dbms_output.put_line('v_var2 (proc): ' || v_var2);
    dbms_output.put_line('p_param (proc): ' || p_param);
  end;

begin
  dbms_output.put_line('v_var1: ' || v_var1);
  proc_inner(v_var1 + 1000);

  -- dbms_output.put_line('v_var2: '|| v_var2); -- будет ошибка, область действия только в процедуре
  -- dbms_output.put_line('p_param: '|| p_param); -- будет ошибка, область действия только в процедуре
end;
/
