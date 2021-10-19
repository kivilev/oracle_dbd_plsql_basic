/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 21. Курсоры
  
  Описание скрипта:  примеры явных курсоров (explicit)

*/

---- Пример 1. Простой SQL. Построчная выборка
declare
  cursor cur_emps is
    select e.employee_id, e.first_name||' '||e.last_name full_name, e.salary
      from employees e
     where rownum <= 10;
  v_rec cur_emps%rowtype;
begin
  open cur_emps; -- открытие
  
  -- проход по полученным строкам
  loop
    fetch cur_emps into v_rec;
    exit when cur_emps%notfound;
    
    dbms_output.put_line(v_rec.employee_id||'. '||v_rec.full_name||' - ' ||v_rec.salary ||'$'); 

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

---- Пример 2. Проход по курсору в FOR
declare
  cursor cur_emps is
    select e.employee_id
          ,e.first_name || ' ' || e.last_name full_name
          ,e.salary
      from employees e
     where rownum <= 10;
begin
  -- проход по полученным строкам
  for v_rec in cur_emps loop
    dbms_output.put_line(v_rec.employee_id||'. '||v_rec.full_name||' - ' ||v_rec.salary ||'$'); 
  end loop;

end;
/


---- Пример 3. Параметризованный курсор + проход через FOR
declare
  -- параметр курсора - p_num_rows
  cursor cur_emps(p_num_rows number) is
    select e.employee_id, e.first_name||' '||e.last_name full_name, e.salary
      from employees e
     where rownum <= p_num_rows;
begin
 
  -- проход по полученным строкам
  for v_rec in cur_emps(5) loop
     dbms_output.put_line(v_rec.employee_id||'. '||v_rec.full_name||' - ' ||v_rec.salary ||'$'); 
  end loop;

end;
/
