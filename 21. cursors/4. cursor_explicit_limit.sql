/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 21. Курсоры
  
  Описание скрипта:  Явные курсоры (explicit) + limit

*/

---- Пример 1. Параметризованный курсор с выборкой в коллекцию
declare
  -- параметр курсора - p_num_rows
  cursor cur_emps(p_num_rows number) is
    select e.employee_id, e.first_name||' '||e.last_name full_name, e.salary
      from employees e
     where rownum <= p_num_rows;

  type t_array is table of cur_emps%rowtype;
  v_array t_array;
begin
  open cur_emps(10); -- открытие
  
  -- проход по полученным строкам
  loop
    fetch cur_emps bulk collect into v_array limit 3;
    dbms_output.put_line('Count current array: '||v_array.count());

    -- работа с коллекцией
    if v_array is not empty THEN
      for i in v_array.first..v_array.last LOOP
        dbms_output.put_line('id: '||v_array(i).employee_id||'. salary: '||v_array(i).salary);      
      end loop;
    end if;

    exit when cur_emps%notfound;
  end loop;

  close cur_emps; -- закрытие
  
exception
  when others then
    if cur_emps%isopen then
      close cur_emps; -- обязательно нужно закрывать курсор
    end if;
    raise;    
end;
/


