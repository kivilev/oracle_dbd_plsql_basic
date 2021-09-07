/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 8. Циклы

  Описание скрипта: примеры с FOR (Классический цикл)
*/

---- Пример 1. Обычный итерационный цикл от 1 до 10
begin
  for i in 1 .. 10 loop
    dbms_output.put_line('i: ' || i);
  end loop;
end;
/

---- Пример 2. Реверсивный цикл от 10 до 1
begin
  for i in reverse 1..10 loop
    dbms_output.put_line('i: ' || i);
  end loop; 
end;
/

---- Пример 3. Реверсивный цикл. Неправильное указание диапазона
begin
  for i in reverse 10..1 loop
    dbms_output.put_line('i: ' || i);
  end loop; 
end;
/
