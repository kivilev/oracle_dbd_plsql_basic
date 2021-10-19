/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 21. Курсоры
  
  Описание скрипта:  Неявные курсоры в цикле (explicit)

*/

---- Пример 1. Простой запрос
begin
  for v_rec in (select * 
	                from employees 
								 where rownum <= 10) loop
    dbms_output.put_line(v_rec.employee_id || ': ' || v_rec.first_name || ': ' ||  v_rec.salary);
  end loop;
end;
/

---- Пример 2. Параметризированный запрос
declare
  -- процедура печати
  procedure print(pi_employee_id employees.employee_id%type)
    is
  begin
    -- цикл по курсору
    for v_rec in (select t.employee_id
                       , t.first_name||' '||t.last_name full_name
                       , t.salary
                    from employees t 
                   where t.employee_id = pi_employee_id) loop

      dbms_output.put_line(v_rec.employee_id || ': ' || v_rec.full_name || ': ' ||  v_rec.salary);

    end loop;
  end;
  
begin
  print(100);
  
	dbms_output.put_line('---'); 
  
	print(101);  
end;
/

