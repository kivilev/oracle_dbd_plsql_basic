/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 2. Блоки

  Описание скрипта: примеры трех типов PL/SQL-блоков
*/ 

---- Пример 1. Неименованный блок
declare
  v_str varchar2(20 char) := 'Hello world!';
begin
  dbms_output.put_line(v_str);
end;
/


---- Пример 2. Именнованный блок на уровне схемы
create or replace procedure hello_world
is
  v_str varchar2(20 char) := 'Hello world!';
begin
  dbms_output.put_line(v_str);
end;
/

-- вызов процедуры
begin
  hello_world();
end;
/


---- Пример 3. Именнованный внутри другого блока
declare
  
  -- процедура внутри анонимного блока
  procedure hello_world_inner
  is
    v_str varchar2(20 char) := 'Hello world!';
  begin
    dbms_output.put_line(v_str);
  end;
  
begin
  hello_world_inner();
end;
/
