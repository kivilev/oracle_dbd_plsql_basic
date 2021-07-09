------ Пример 2. Использование в PL/SQL

-- Создадим наш объект
create or replace type t_my_object is object
(
   id  number(30),
   name varchar2(200 char)
);
/

-- Пример 2.1. Создание объекта и инициализация значениями
declare
  v_obj1 t_my_object := t_my_object(777, 'Объект 1'); -- заполнение при создании
  v_obj2 t_my_object;
begin
  -- v_obj2.name := 'Объект 2'; -- будет ошибка, т.к. объект не создавался
  v_obj2 := t_my_object(888, 'Объект 2'); -- создание по ходу выполнения программы

  dbms_output.put_line('v_obj1. id: '||v_obj1.id ||'. name: '||v_obj1.name); 
  dbms_output.put_line('v_obj2. id: '||v_obj2.id ||'. name: '||v_obj2.name);    
end;
/

-- Пример 2.2. NULL и объекты
declare
  v_obj1 t_my_object := t_my_object(777, 'Объект 1'); -- заполнение при создании
begin
  -- не надо перечислять поля и каждое сравнивать с null
  if v_obj1 is null then
    dbms_output.put_line('It''s null!'); 
  end if;
end;
/

-- Пример 2.3. Сравнение объектов
declare
  v_obj1 t_my_object := t_my_object(777, 'Объект');
  v_obj2 t_my_object := t_my_object(777, 'Объект');
begin
/*  -- нужно определять методы map, order
  if v_obj1 = v_obj2 then
    dbms_output.put_line('objects are equals'); 
  end if;
*/
  if ((v_obj1.id = v_obj2.id) or (v_obj1.id is null and v_obj2.id is null)) and
     ((v_obj1.name = v_obj2.name) or (v_obj1.name is null and v_obj2.name is null)) then
    dbms_output.put_line('objects are equals'); 
  end if;
end;
/


-- Пример 2.4. Использование в качестве параметров и возвращаемого результата
declare
  v_main_obj t_my_object := t_my_object(777, 'Объект');
    
  -- именованный PL/SQL-блок (функция) с входным параметром типа t_my_object И результатом t_my_object
  function func_inner(p_param t_my_object) return t_my_object
  is
    v_var t_my_object := p_param; -- сразу присваиваем значение от вх параметра
  begin
    v_var.id := v_var.id + 1000; -- прибавдяем + 1000
    return v_var; -- возвращаем
  end;
 
begin
  dbms_output.put_line('v_main_obj: '||v_main_obj.id ||' - '|| v_main_obj.name);

  v_main_obj := func_inner(v_main_obj);-- вызываем внутренню функцию
  
  dbms_output.put_line('v_main_obj: '||v_main_obj.id ||' - '|| v_main_obj.name);
end;
/


-- Пример 2.5. Использование в DML и select
declare
  v_part_employee t_my_object;
begin
  -- сохраняем в объект часть строки
  select t_my_object(t.employee_id, t.first_name||' '||t.last_name) -- обязательно объект создается через конструктор
    into v_part_employee
    from employees t 
   where t.employee_id = 100;
  
  dbms_output.put_line('v_part_employee: '||v_part_employee.id||'. name: '||v_part_employee.name); 

  -- меняем объект
  v_part_employee.id := 888;
  v_part_employee.name := 'My name';
  
  -- записываем в таблицу (через перечисление полей). В данном случае поля объекта используюсят как источник данных
  insert into employees(employee_id, last_name, email, hire_date,job_id) 
  values (v_part_employee.id, v_part_employee.name, 'email@email.ru', sysdate, 'IT_PROG');
end;
/
-- смотрим, новую строчку
select t.*
  from employees t 
 where t.employee_id in (888);

