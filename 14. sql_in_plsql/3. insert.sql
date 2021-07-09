------- Пример 3. INSERT в PL/SQL

create table example_12_3(
id   number(3),
name varchar2(200 char)
);

create sequence example_12_3_seq;

-- 1. Возврашаем одно поле из INSERT
declare
  v_new_id example_12_3.id%type;
begin
  insert into example_12_3 
  values (example_12_3_seq.nextval, example_12_3_seq.nextval||'_name')
  returning id into v_new_id;
  
  dbms_output.put_line('New id: '|| v_new_id); 
end;
/

-- 2. Возврашаем два поля в две переменные из INSERT
declare
  v_new_id   example_12_3.id%type;
  v_new_name example_12_3.name%type;
begin
  insert into example_12_3 
  values (example_12_3_seq.nextval, example_12_3_seq.nextval||'_name')
  returning id, name into v_new_id, v_new_name;
  
  dbms_output.put_line('New id: '|| v_new_id); 
  dbms_output.put_line('New name: '|| v_new_name); 
end;
/
