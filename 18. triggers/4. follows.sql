/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 18. Триггеры
	
  Описание скрипта: FOLLOWS - порядок следования
*/

-- вспомогательная табличка
drop table my_tab;
create table my_tab
(
  id   number(10) not null,
  name varchar2(100 char)  not null 
);

---- Пример 1. Три триггера AFTER. Сделаем 3 -> 2 -> 1

create or replace trigger my_tab_a_i_THREE
after  -- после
insert -- вставка
on my_tab -- на таблице my_tab
begin
  dbms_output.put_line('my_tab_a_i_THREE');
end;
/

create or replace trigger my_tab_a_i_ONE
after  -- после
insert -- вставка
on my_tab -- на таблице my_tab
follows my_tab_a_i_TWO
begin
  dbms_output.put_line('my_tab_a_i_ONE');
end;
/

create or replace trigger my_tab_a_i_TWO
after  -- после
insert -- вставка
on my_tab -- на таблице my_tab
follows my_tab_a_i_THREE
begin
  dbms_output.put_line('my_tab_a_i_TWO');
end;
/

insert into my_tab(id, name) values (1, 'name1');
