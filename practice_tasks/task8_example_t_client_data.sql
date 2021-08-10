-- Создание объекта для передачи пары "id_поля/значение"
create or replace type t_client_data is object
(
  field_id number(10),
  field_value varchar2(200 char)  
);
/