/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 18. Триггеры
	
  Описание скрипта: примеры обычных DML-триггеров
*/

-- вспомогательная табличка
drop table my_tab;
create table my_tab
(
  id   number(10) not null,
  name varchar2(100 char)  not null 
);

---- Пример 1. AFTER на вставку данных (построчный)
create or replace trigger my_tab_a_i
after  -- после
insert -- вставка
on my_tab -- на таблице my_tab
for each row -- срабатывать для каждой строки в DML команде
begin
  dbms_output.put_line('Была добавлена строка. Событие ПОСЛЕ');
end;
/

-- вставлем сразу 4е строки, смотрим вывод
insert into my_tab 
select level, 'name'||level from dual connect by level <= 4;


---- Пример 2. Обычный BEFORE-триггер INSERT или UPDATE (построчный)
create or replace trigger my_tab_b_iu
before -- до
insert or update  -- на вставку или обновление
on my_tab -- на таблице my_tab
for each row -- для каждой стркои
begin
  dbms_output.put_line('Создаем/меняем строку. Событие ДО');
end;
/

-- вставлем сразу 4е строки, смотрим вывод
insert into my_tab 
select level, 'name'||level from dual connect by level <= 5;



---- Пример 3. Обычный BEFORE-триггер на операцию DELETE в целом.
-- запрещает удалять записи
create or replace trigger my_tab_b_d_stmt
before -- до
delete -- удаление
on my_tab -- на таблице my_tab
begin
  raise_application_error(-20101, 'Удалять нельзя!'); -- это пользовательское исключение
end;
/

-- проверяем
delete my_tab; -- ошибка
delete my_tab t where t.id = 0; -- ошибка, хотя такой строки даже нет


