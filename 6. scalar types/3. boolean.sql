/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  Дата: 20.03.2021

  Описание скрипта: примеры с логическим типом boolean
*/

---- Пример 1. Объявление переменных с типом boolean
declare
  v_var_false boolean := false;
  v_var_true  boolean := true;
  v_var_null  boolean := null; 
  v_var_def   boolean; -- по умолчанию будет null
begin
  dbms_output.put_line('v_var_false = ' || sys.diutil.bool_to_int(v_var_false));-- просто так не вывести
  dbms_output.put_line('v_var_true  = ' || sys.diutil.bool_to_int(v_var_true));
  dbms_output.put_line('v_var_null  = ' || sys.diutil.bool_to_int(v_var_null));
  dbms_output.put_line('v_var_def   = ' || sys.diutil.bool_to_int(v_var_def));
end;
/

---- Пример 2. Конвертация из number в boolean
declare
  v_flag boolean;
begin
  v_flag := sys.diutil.int_to_bool(1); -- 1 => true
  if v_flag
  then
    dbms_output.put_line('v_flag = true');
  end if;

  v_flag := sys.diutil.int_to_bool(0); -- 0 => false
  if not v_flag
  then
    dbms_output.put_line('v_flag = false');
  end if;

end;
/
