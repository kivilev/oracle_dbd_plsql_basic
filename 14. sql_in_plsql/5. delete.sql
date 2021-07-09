------- Пример 5. DELETE в PL/SQL

-- создадим таблицу
create table example_12_5(
id   number(3),
name varchar2(200 char)
);

-- вставим три строки
insert into example_12_5 values (1, 'name1');
insert into example_12_5 values (2, 'name2');
insert into example_12_5 values (3, 'name3');
insert into example_12_5 values (4, 'name4');
insert into example_12_5 values (5, 'name5');
commit;

select * from example_12_5;

-- 1. Возврашаем одно поле в переменную после DELETE
declare
  v_del_name example_12_3.name%type;
begin
  -- обновляем 1 строку  
  delete from example_12_5 t
   where t.id = 1
  returning t.name into v_del_name;
 
  dbms_output.put_line('Del name: '|| v_del_name); 
end;
/

select * from example_12_5;


-- 2. Возврашаем одно поле нескольких удаленных строк в коллекцию после DELETE
declare
  type t_names is table of example_12_5.name%type; -- создаем тип коллекций
  v_names t_names;
begin
  -- удаляем 2 строки
  delete from example_12_5 t
   where t.id in (2, 3)
  returning t.name bulk collect into v_names;

  -- выводим элементы коллекций
  if v_names is not empty then
    for i in v_names.first..v_names.last loop
      dbms_output.put_line('Del name: '||v_names(i));
    end loop;
  end if;
end;
/

-- 3. Возврашаем два поля нескольких удаленных строк в коллекции после DELETE
declare
  type t_ids is table of example_12_5.id%type; -- создаем тип коллекций
  type t_names is table of example_12_5.name%type; -- создаем тип коллекций
  v_ids   t_ids;
  v_names t_names;
begin
   -- удаляем 2 строки
  delete from example_12_5 t
   where t.id in (4, 5)
  returning t.id, t.name bulk collect into v_ids, v_names;
  
  -- выводим элементы коллекций
  if v_names is not empty then
    for i in v_names.first..v_names.last loop
      dbms_output.put_line('Del id: '||v_ids(i));
      dbms_output.put_line('Del name: '||v_names(i));
    end loop;
  end if;
end;
/

