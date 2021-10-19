/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 22. Динамический SQL
  
  Описание скрипта: сравнение скорости выполнения трех разных подходов

*/

-- вспомогательная таблица
drop table demo;
create table demo
(
 id number,
 name varchar2(200 char)
);
alter table demo add constraint demo_pk primary key (id);

-- вставляем 1M записей
insert into demo 
select level, 'n'||level from dual connect by level <= 1e6;
commit;

-- Сравниваем динамический и статический SQL
declare
  t1 number;
  t2 number;
  t3 number;
  t4 number;
  N  number := 10000;
  type t_arr is table of demo.id%type;
  v_ids  t_arr := t_arr();
  v_cnt   number;
begin
  -- генерим случайные IDшки.
  for i in 1..N loop
    v_ids.extend(1);
    v_ids(v_ids.last) := trunc(dbms_random.value(1, 1000000));
  end loop;

  -- Статический 
  t1 := dbms_utility.get_time();
  for i in 1..v_ids.count() loop
    select /*+ static_ver */ count(*) into v_cnt from demo where id = v_ids(i);
  end loop;

  -- Динамический с связными переменными
  t2 := dbms_utility.get_time(); 
  for i in 1..v_ids.count() loop
    execute immediate 'select /*+ dynam_ver_bind */ count(*) from demo d where id = :id' into v_cnt using v_ids(i);
  end loop;

  -- Динамический без связных переменных
  t3 := dbms_utility.get_time(); 
  for i in 1..v_ids.count() loop
    execute immediate 'select /*+ dynam_ver_not_bind */ count(*) from demo d where id = '|| v_ids(i) into v_cnt;
  end loop;
  
  t4 := dbms_utility.get_time();
  dbms_output.put_line('Static: '||(t2-t1)/100||'. Dynamic(bind): '||(t3-t2)/100||'. Dynamic(not bind): '||(t4-t3)/100); 
  
end;
/

----- DBA
-- Сброс кэша
-- alter system flush shared_pool;

-- Просмотр версий курсоров
select t.sql_text
  from v$sql t
 where lower(t.sql_text) like '%dynam_ver_not_bind%'
      -- отсеиваем лишнее
   and lower(t.sql_text) not like '%v$sql%'
   and lower(t.sql_text) not like '%declare%';

