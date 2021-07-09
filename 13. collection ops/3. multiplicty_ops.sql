------- Пример 2. Операции над множеством

-- Пример 1. Равенство коллекций
declare
  type t_arr is table of number(30);
  v_arr1 t_arr := t_arr(100, 200, 300);
  v_arr2 t_arr := t_arr(200, 300, 400);
  v_arr3 t_arr := t_arr(100, 200, 300);
  v_arr4 t_arr := t_arr(100, 200, 300, null);
begin
  if v_arr1 = v_arr2 then -- коллекции с разными элементами -> "не равна"
    dbms_output.put_line('v_arr1 равна v_arr2');
  else
    dbms_output.put_line('v_arr1 НЕ равна v_arr2');
  end if;

  if v_arr1 = v_arr3 then -- коллекции с одинаковыми элементами -> "равна"
    dbms_output.put_line('v_arr1 равна v_arr3');
  else
    dbms_output.put_line('v_arr1 НЕ равна v_arr3');
  end if;

  if v_arr4 = v_arr4 then -- сравним саму же себя, т.к. есть null результат -> "не равна"
    dbms_output.put_line('v_arr4 равна v_arr4');
  else
    dbms_output.put_line('v_arr4 НЕ равна v_arr4');
  end if;

end;
/

-- Пример 2. SET - удаление дубликатов (преобразование в уникальное множество)
declare
  type t_arr is table of number(30);
  v_arr1 t_arr := t_arr(100, 200, 300, 300, 300, null, null);
begin
  dbms_output.put_line('Count before set: ' || v_arr1.count()); 
  
  v_arr1 := set(v_arr1);
  
  dbms_output.put_line('Count after set: ' || v_arr1.count()); 
end;
/

-- Пример 3. Проверка на уникальность.
declare
  type t_arr is table of number(30);
  v_arr1 t_arr := t_arr(100, 200, 300, 300);
  v_arr2 t_arr := t_arr(100, 200, 300, 400);
  v_arr3 t_arr := t_arr(100, 200, 300, 400, null, null);  
begin
  if v_arr1 is a set then
    dbms_output.put_line('v_arr1 уникальное множество'); 
  else
    dbms_output.put_line('v_arr1 НЕ уникальное множество');      
  end if;
  
  if v_arr2 is a set then
    dbms_output.put_line('v_arr2 уникальное множество'); 
  else
    dbms_output.put_line('v_arr2 НЕ уникальное множество');      
  end if;
  
  if v_arr3 is a set then
    dbms_output.put_line('v_arr3 уникальное множество'); 
  else
    dbms_output.put_line('v_arr3 НЕ уникальное множество');      
  end if;
  
end;
/

-- Пример 4. Проверка на пустоту
declare
  type t_arr is table of number(30);
  v_arr1 t_arr := t_arr(); -- пустая, но проинициализированная
  v_arr2 t_arr; -- пустая и не проинициализированная
begin
  if v_arr1 is empty then
    dbms_output.put_line('v_arr1 пустая'); 
  end if;

  -- dbms_output.put_line(v_arr2.count()); -- будет ошибка
  if v_arr2 is not empty then -- особенность. в режиме Not проверяет как на инициализацию так и на пустоту
    dbms_output.put_line('v_arr2 НЕ пустая'); 
  else
    dbms_output.put_line('v_arr2 пустая'); 
  end if;

end;
/


-- Пример 5. Является ли значение членом множества
declare
  type t_arr is table of number(30);
  v_arr1 t_arr := t_arr(100, 200, 300, 400, null);
begin
  if 100 member of v_arr1 then
    dbms_output.put_line('"100" есть в коллекции'); 
  end if;
  
  if null member of v_arr1 then
    dbms_output.put_line('"null" есть в коллекции');     
  else
    dbms_output.put_line('"null" нет в коллекции');     
  end if;
  
  if null not member of v_arr1 then -- Добавили NOT
    dbms_output.put_line('"null" есть в коллекции');     
  else
    dbms_output.put_line('"null" нет в коллекции');     
  end if;
  
end;
/



