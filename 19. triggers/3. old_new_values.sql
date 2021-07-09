------- 2. OLD/NEW - значения

drop table my_tab;
create table my_tab
(
  id   number(10) not null,
  name varchar2(100 char)  not null 
);

--- Пример 1. AFTER на вставку данных (построчный)
create or replace trigger my_tab_a_i
after  -- после
insert -- вставка
on my_tab -- на таблице my_tab
for each row -- срабатывать для каждой строки в DML команде
begin
  dbms_output.put_line('Была добавлена строка. Событие ПОСЛЕ. Id: '||:new.id||'. Name: '||:new.name);
end;
/

-- вставлем сразу 4е строки, смотрим вывод
insert into my_tab 
select level, 'name'||level 
  from dual connect by level <= 4;


--- Пример 2. Обычный BEFORE-триггер INSERT или UPDATE (построчный)
create or replace trigger my_tab_b_iu
before -- до
insert or update  -- на вставку или обновление
on my_tab -- на таблице my_tab
for each row -- для каждой строки
begin
  -- опредяем что за операция выполняется
  if updating then
    dbms_output.put_line('Меняем строку. Событие ДО. Id: '||:new.id||'. '|| :old.name ||' => '||:new.name);
  elsif inserting then
    dbms_output.put_line('Добавляем строку. Событие ДО. Id: '||:new.id||'. Name: '||:new.name);

    if :new.id = 555 then -- маленький трюк по изменению данных
      :new.name := 'Подменное имя';
    end if;
    
  end if;
  
end;
/

-- вставим
insert into my_tab(id, name) values (555, 'name555'); -- имя поменяется
insert into my_tab(id, name) values (777, 'name777'); -- произойдет нормальная вставка

select * from my_tab;


-- обновим
update my_tab t
   set t.name = t.name || '_hello'
 where t.id in (1, 2);



--- Пример 3. Обычный BEFORE-триггер на команду DELETE (построчный). Запрещает удалять записи с определенными ID
create or replace trigger my_tab_b_d_stmt
before -- до
delete -- удаление
on my_tab -- на таблице my_tab
for each row -- для каждой строки
when(old.id in (555, 777)) -- срабатывать когда будет попытка удалить запись с ID = 555 или 777
begin
  raise_application_error(-20101, 'Нельзя удалить запись с ID = '|| :old.id ||' !'); -- это пользовательское исключение
end;
/

-- проверяем
delete my_tab t where t.id = 1; -- нет ошибки
delete my_tab t where t.id = 555; -- ошибка
delete my_tab t where t.id = 777; -- ошибка


