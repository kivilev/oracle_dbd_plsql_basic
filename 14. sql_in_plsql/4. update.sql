/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 14. Использование SQL в PL/SQL
	
  Описание скрипта: примеры UPDATE в PL/SQL

*/

-- Создадим вспомогательную табличку
create table example_12_4(
id   number(3),
name varchar2(200 char)
);

-- вставим три строки
insert into example_12_4 values (1, 'name1');
insert into example_12_4 values (2, 'name2');
insert into example_12_4 values (3, 'name3');
commit;

select * from example_12_4;

---- Пример 1. Возврашаем одно поле в переменную после UPDATE
declare
  v_upd_name example_12_4.name%type;
begin
  -- обновляем 1 строку  
  update example_12_4 t 
     set t.name = t.name || '_upd1'
   where t.id = 1
  returning t.name into v_upd_name;
 
  dbms_output.put_line('Upd name: '|| v_upd_name); 
end;
/

select * from example_12_4;


---- Пример 2. Возврашаем одно поле нескольких обновленных строк в коллекцию после UPDATE
declare
  type t_names is table of example_12_4.name%type; -- создаем тип коллекций
  v_names t_names;
begin
  -- обновляем 2 строки
  update example_12_4 t 
     set t.name = t.name || '_upd2'
   where t.id in (1, 2)
  returning t.name bulk collect into v_names;

  -- выводим элементы коллекций
  if v_names is not empty then
    for i in v_names.first..v_names.last loop
      dbms_output.put_line('Upd name: '||v_names(i));
    end loop;
  end if;
end;
/

---- Пример 3. Возврашаем два поля нескольких обновленных строк в коллекции после UPDATE
declare
  type t_ids is table of example_12_4.id%type; -- создаем тип коллекций
  type t_names is table of example_12_4.name%type; -- создаем тип коллекций
  v_ids   t_ids;
  v_names t_names;
begin
  -- обновляем 2 строки
  update example_12_4 t 
     set t.name = t.name || '_upd3'
   where t.id in (1, 2)
  returning t.id, t.name bulk collect into v_ids, v_names;
  
  -- выводим элементы коллекций
  if v_names is not empty then
    for i in v_names.first..v_names.last loop
      dbms_output.put_line('Upd id: '||v_ids(i));
      dbms_output.put_line('Upd name: '||v_names(i));
    end loop;
  end if;
end;
/

