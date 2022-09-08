/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 2. Блоки
	
  Описание скрипта: примеры  именнованных блоков
*/ 

---- Пример 1. Именованный блок с одним исполняемым разделом
create or replace procedure hello_world_51
is
begin
  dbms_output.put_line('Hello world!');
end;
/

call hello_world_51;


---- Пример 2. Именованный блок с разделом объявлений и исполняемым разделом
create or replace procedure hello_world_52
is
  v_str varchar2(100 char) := 'Hello world!';
begin
  dbms_output.put_line (v_str);
end;
/

call hello_world_52;


---- Пример 3. Именованный блок с разделами объявления, исполняемым и обработки ошибок
create or replace procedure hello_world_53
is
  v_str varchar2(100 char) := 'Hello world!';
  v_n   number;
begin  
  dbms_output.put_line(v_str);
  v_n := 10/2;
exception 
  when others then
    dbms_output.put_line ('Возникла ошибка: '||sqlerrm);
end;
/

call hello_world_53;


---- Пример 4. Именованный блок определенный в другом PL/SQL-блоке(анонимном) с исполняемым разделом
declare

  procedure hello_world_inner_54
  is
  begin
    dbms_output.put_line('Hello world!');
  end;

begin
  hello_world_inner_54();
end;
/


---- Пример 5. Именованный блок определенный в другом PL/SQL-блоке(именованном)
-- с разделами объвяления и исполнения
create or replace procedure hello_world_55
is
  
  procedure hello_world_inner_55
  is
    v_str varchar2(100 char) := 'Hello world!';
  begin
    dbms_output.put_line(v_str);
  end;
	
begin
  hello_world_inner_55();
end;
/

call hello_world_55();

