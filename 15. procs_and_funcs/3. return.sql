/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 15. Процедуры и функции
	
  Описание скрипта: примеры return

*/

---- Пример 1. Процедура без return
create or replace procedure some_proc1
is
begin
  dbms_output.put_line('Процедура без return. OK'); 
end;
/

---- Пример 2. Процедура c return
-- Если тек время до полудня, то ничего не делаем. Если после, то запускаем тяжелый процесс.
create or replace procedure some_proc2
is
begin
  if sysdate between trunc(sysdate) and trunc(sysdate) + 1/2 then
    dbms_output.put_line('Время до полудня. Ничего не делаем'); 
    return; -- выход из процедуры, нет необходимости что-то делать дальше
  end if;
  
  dbms_output.put_line('Время после полудня. Запускаем тяжелый процесс...');
  -- что-то делаем
end;
/


---- Пример 3. Функция с возвратом результата типа boolean

-- Вариант 1. Возвращает true, если время до полудня. false - если после полудня
-- так бы написали функцию индусы
create or replace function is_before_midday return boolean is
begin
  if sysdate between trunc(sysdate) and trunc(sysdate) + 1/2 then -- если время до полудня
    return true; -- возвращаем true
  else
    return false;-- возвращаем false
  end if;
end;
/

-- Вариант 2. Можно записать еще короче, используя то что условие вернет либо true, либо false.
-- так бы написали функцию грамотные разработчики
create or replace function is_before_midday return boolean is
begin
  return sysdate between trunc(sysdate) and trunc(sysdate) + 1/2; -- если время до полудня
end;
/


---- Пример 4. Функция созданная без return.
-- растяпа-разработчик забыл указать return
create or replace function func_wo_return return number
is
begin
  null;
end;
/

select status, t.* from user_objects t where t.OBJECT_NAME = 'FUNC_WO_RETURN';

-- ORA-06503: PL/SQL: Function returned without value
select func_wo_return() from dual;

