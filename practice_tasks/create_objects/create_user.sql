/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  
  Описание скрипта: создание пользователя/схемы для размещения объектов и экспериментов
	
	! Вместо PSB подставьте имя, которое подходит под вашу ситуацию
*/

-- drop user psb cascade;

create user psb
 identified by booble34 -- здесь указывается пароль
  default tablespace users
  temporary tablespace temp
  profile default
  quota unlimited on users;
  
grant resource to psb;
grant connect to psb;
grant debug connect session to psb;
