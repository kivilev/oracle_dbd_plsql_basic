/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  Дата: 24.03.2021
  
  Лекция 5. Область действия и видимость
  
  Описание скрипта: столбец в SQL совпадает с переменной.
*/

-- Подготовка. Создадим табличку и вставим четыре записи
drop table my_tab;
create table my_tab(
  mt_id number
);

insert into my_tab values (1);
insert into my_tab values (2);
insert into my_tab values (3);
insert into my_tab values (4);
commit;

---- Пример 1. Неверная работа функционала.
declare
  mt_id   number := 2;
  v_count number;
begin
  select count(*) into v_count 
    from my_tab t 
   where t.mt_id = mt_id; -- 1 = 1

  dbms_output.put_line(v_count); -- выведет "4".
end;
/

---- Пример 2. Правильная работа функционала. Уточняем через метку блока
<<insert_block>>  
declare
  mt_id   number := 2;
  v_count number;
begin
  select count(*)
    into v_count
    from my_tab t
   where t.mt_id = insert_block.mt_id;

  dbms_output.put_line(v_count); -- выведет "1".
end;
/

---- Пример 3. Правильная работа функционала. Называем переменную с префиксом v_
declare
  v_mt_id number := 2;
  v_count number;
begin
  select count(*) into v_count 
    from my_tab t 
   where t.mt_id = v_mt_id;

  dbms_output.put_line(v_count); -- выведет "1".
end;
/
