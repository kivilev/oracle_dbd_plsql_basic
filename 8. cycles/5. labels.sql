/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 8. Циклы

  Описание скрипта: примеры с метками в циклах
*/

---- Пример 1. Два цикла с метками
begin

  <<main_loop>>
  for i in 1 .. 10 loop

    dbms_output.put_line('i: ' || i);

    <<inner_loop>>
    for j in 1 .. 2 loop
      dbms_output.put_line('  j: ' || j);
      
      if i = 3 then -- когда i будет равно 3 выйдет из главного цикла
        exit main_loop;
      end if;
    end loop;
  
  end loop main_loop;

end;
/
