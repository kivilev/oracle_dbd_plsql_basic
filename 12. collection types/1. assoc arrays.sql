------ Пример 1. Определение ассоциативных массивов

-- Пример 1.1. Определение ассоц массива из number, ключ число (pls_integer)
declare
  type t_ass_arr is table of number(30) index by pls_integer;
  v_array t_ass_arr;
begin
  null;
end;
/

-- Пример 1.2. Определение ассоц массива из boolean, ключ строка (varchar2)
declare
  type t_ass_arr is table of boolean index by varchar2(100 char);
  v_array t_ass_arr;
begin
  null;
end;
/

-- Пример 1.3. Определение ассоц массива из записей (строк таблицы employees), ключ строка
declare
  type t_ass_arr is table of employees%rowtype index by varchar2(30 char);
  v_array t_ass_arr;
begin
  null;
end;
/

-- Пример 1.4. Попытка определить ассоц массива на уровне схемы -> ошибка
create or replace type t_ass_array_error is table of number(3) index by pls_integer;
/

show errors;
