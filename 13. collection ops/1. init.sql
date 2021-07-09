------- Пример 1. Инициализация коллекций

-- 1. Инициализация пустой коллекции
declare
  type t_array is table of number(30);
  v_array t_array := t_array();
begin
  null;
end;
/


-- 2. Инициализация коллекции с элементами
declare
  type t_array is table of number(30);
  v_array t_array := t_array(100, 200, 300, 777, 1000);
begin
  null;
end;
/
