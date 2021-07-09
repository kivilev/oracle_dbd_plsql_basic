------ Пример 1. Объявление записей

-- Пример 1.1. Создание типа t_my_rec и переменной с этим типом
declare
  type t_my_rec is record(
     id   number(30)
    ,name varchar2(200 char));

  v_my_rec t_my_rec;
begin
  null;
end;
/

-- Пример 1.2. Создание типа t_my_rec и переменной с этим типом
-- поле pos с ограничением и значением по умолчанию
-- поле note со значением по умолчанию
declare
  type t_my_rec is record(
     pos  number(30) not null := 100
    ,note varchar2(200 char) := 'hello world');

  v_my_rec t_my_rec;
begin
  null;
end;
/
