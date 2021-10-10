/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 19. Триггеры
	
  Описание скрипта: примеры составных триггеров
*/

-- вспомогательная табличка
drop table my_tab;
create table my_tab
(
  id   number(10) not null,
  name varchar2(100 char)  not null 
);

---- Пример 1. Составной триггер. Регистрирует имя юзера, который менял строки.
create or replace trigger my_tab_iu_c
for update or insert -- для вставки или обновления
on my_tab -- на таблицу my_tab
compound trigger -- составной
  g_user varchar2(100 char);

  -- до операции
  before statement is begin
    dbms_output.put_line('=== before statement');    
    g_user := sys_context('userenv','os_user'); -- один раз получаем имя OS юзера
    dbms_output.put_line('Получили OS user: '|| g_user); 
  end before statement;

  -- до операции построчно
  before each row is begin
    dbms_output.put_line(chr(9)||'== before row. Операцию выполняет: '||g_user);
  end before each row;  

  -- после операции построчно
  after each row is begin
    dbms_output.put_line(chr(9)||'== after row. Операцию выполнял: '||g_user); 
  end after each row;

  -- после операции
  after statement is begin
    dbms_output.put_line('=== after statement'); 
  end after statement;

end;
/

-- проверяем
insert into my_tab 
select level, 'str'||level 
  from dual connect by level <= 3;
  
select * from my_tab;
