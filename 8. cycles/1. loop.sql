/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 7. Условия и переходы

  Описание скрипта: примеры с LOOP (простой цикл)
*/

---- Пример 1. Бесконечный цикл (отвалится по ошибке из-за переполнения буфера вывода)
declare
  v_i number(30) := 0;
begin
  loop
    v_i := v_i + 1;
    dbms_output.put_line(v_i);
  end loop;
end;
/

---- Пример 2. Цикл с выходом
declare
  v_i    number(30) := 0;
  v_stop number(30) := 10;
begin
  loop
    v_i := v_i + 1;
    dbms_output.put_line('v_i: '||v_i);

    exit when v_i = v_stop; 
  end loop;
end;
/

---- Пример 3. Цикл с выходом через IF
declare
  v_i    number(30) := 0;
  v_stop number(30) := 10;
begin
  loop
    v_i := v_i + 1;
    dbms_output.put_line('v_i: '||v_i);

    if v_i = v_stop then
      exit;  
    end if;
  end loop;
end;
/

