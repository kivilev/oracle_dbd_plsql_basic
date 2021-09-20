/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 10. Записи
	
  Описание скрипта: примеры с операциями над записями
*/

---- Пример 1. Инициализация, обращение к полям
declare
  type t_my_rec is record(
     id   number(30) := 100
    ,name varchar2(200 char) := 'hello world'
  );

  v_my_rec t_my_rec;
begin
  dbms_output.put_line(v_my_rec.id);
  dbms_output.put_line(v_my_rec.name);
  
  v_my_rec.name := 'good day!';
  dbms_output.put_line(v_my_rec.name);
end;
/

---- Пример 2. Записи и NULL
declare
  type t_my_rec is record(
     id   number(30) := 999
    ,name varchar2(200 char) := 'hello world'
  );

  v_my_rec t_my_rec;
begin
  dbms_output.put_line(v_my_rec.id ||' - '|| v_my_rec.name);

  v_my_rec := null; -- записываем null во все поля
  
  dbms_output.put_line(v_my_rec.id ||' - '|| v_my_rec.name);
  
  -- if v_my_rec is null then -- так нельзя, будет ошибка
  if v_my_rec.id is null and v_my_rec.name is null then
    dbms_output.put_line('Запись содержит только null-значения'); 
  end if;
  
end;
/

---- Пример 3. Сравнение записей
declare
  type t_my_rec is record(
     id   number(30) := 999
    ,name varchar2(200 char) := 'hello world'
  );
  v_my_rec  t_my_rec;
  v_my_rec2 t_my_rec;
begin
  dbms_output.put_line('v_my_rec: '||v_my_rec.id ||' - '|| v_my_rec.name);
  dbms_output.put_line('v_my_rec2: '||v_my_rec.id ||' - '|| v_my_rec.name);
  
  -- if v_my_rec = v_my_rec2 then -- так писать нельзя будет ошибка
  -- правильно сравнивать по полям, не забываем про null
  if ((v_my_rec.id = v_my_rec2.id) or (v_my_rec.id is null and v_my_rec2.id is null)) and
     ((v_my_rec.name = v_my_rec2.name) or (v_my_rec.name is null and v_my_rec2.name is null)) then
  
    dbms_output.put_line('Записи одинаковые'); 
  
  end if;
  
end;
/

---- Пример 4. Вложенность записей
declare
  type t_my_rec is record(
     id   number(30) := 999
    ,name varchar2(200 char) := 'hello world'
  );
  
  type t_my_super_rec is record(
     rec_field t_my_rec
    ,note      varchar2(200 char)
  );

  v_my_rec t_my_super_rec;
begin
  v_my_rec.note           := 'my note!';
  v_my_rec.rec_field.name := 'Gagarin in the space'; --обращение к полю вложенной записи

  dbms_output.put_line('v_my_rec.note: ' || v_my_rec.note);
  dbms_output.put_line('v_my_rec.rec_field.name: ' ||
                       v_my_rec.rec_field.name);
end;
/

---- Пример 5. Использование в качестве параметров и возвращаемого результата
declare
  type t_my_rec is record(
     id   number(30) := 999
    ,name varchar2(200 char) := 'hello world'
  );
  v_main_rec t_my_rec;
    
  -- именованный PL/SQL-блок (функция) с входным параметром типа t_my_rec И результатом t_my_rec
  function func_inner(p_param t_my_rec) return t_my_rec
  is
    v_var t_my_rec := p_param; -- сразу присваиваем значение от вх параметра
  begin
    v_var.id := v_var.id + 1000; -- прибавляем + 1000
    return v_var; -- возвращаем
  end;
 
begin
  dbms_output.put_line('v_my_rec: '||v_main_rec.id ||' - '|| v_main_rec.name);

  v_main_rec := func_inner(v_main_rec);-- вызываем внутренню функцию
  
  dbms_output.put_line('v_my_rec: '||v_main_rec.id ||' - '|| v_main_rec.name);
end;
/

---- Пример 6. Использование в DML и select
declare
  v_employee_row employees%rowtype; -- запись = строке таблицы
begin
  -- сохраняем в запись всю строку из таблицы
  select * 
    into v_employee_row
    from employees t 
   where t.employee_id = 100;
  
  dbms_output.put_line('v_employee_row: '||v_employee_row.employee_id||'. salary: '||v_employee_row.salary); 
  
  -- меняем запись
  v_employee_row.employee_id := 777;
  v_employee_row.email := 'email@email.com';
  v_employee_row.salary := v_employee_row.salary + 100000;
  
  -- записываем в таблицу
  insert into employees values v_employee_row;
  
end;
/

-- смотрим, строку-источник и новую строчку
select t.employee_id, t.email, t.salary 
  from employees t 
 where t.employee_id in (100, 777);

