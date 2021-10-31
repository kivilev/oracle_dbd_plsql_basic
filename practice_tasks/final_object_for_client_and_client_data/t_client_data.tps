/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Описание скрипта: пример задания 8. Objects
*/

-- Создание объекта для передачи пары "id_поля/значение"
create or replace type t_client_data is object
(
  field_id number(10),
  field_value varchar2(200 char)  
);
/