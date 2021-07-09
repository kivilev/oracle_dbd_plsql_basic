------ Пример 3. Обход коллекций

-- Пример 1. Обход разряженных коллекций (дырки есть)
declare
  type t_assoc_arr is table of number(30) index by varchar2(20 char);
  v_arr t_assoc_arr;
  v_key varchar2(20 char);
begin
  v_arr('key1') := 555;
  v_arr('key2') := 777;
  v_arr('key3') := 888;
  
  v_key := v_arr.first;
  while v_key is not null loop
    dbms_output.put_line('Key: ' || v_key || '. Value: '|| v_arr(v_key)); 
	  v_key := v_arr.next(v_key);  
  end loop;

end;
/

-- Пример 2. Обход плотных коллекций (без дырок)
declare
  type t_arr is table of number(30);
  v_arr t_arr := t_arr(777, 888, 999);
begin
  if v_arr is not empty then
    for i in v_arr.first .. v_arr.last loop
      dbms_output.put_line('Index: ' || i || '. Value: '|| v_arr(i));
    end loop;
  end if;
end;
/

-- Пример 3. Обход разряженных коллекций типа nested tables (с дырками)
--           для ассоциативного массива этот способ не подойдет
declare
  type t_arr is table of number(30);
  v_arr t_arr := t_arr(777, 888, 999, 1000);
begin
  v_arr.delete(3);
  
  if v_arr is not empty then
    for i in v_arr.first .. v_arr.last loop
      if v_arr.exists(i) then
        dbms_output.put_line('Index: ' || i || '. Value: '|| v_arr(i));
      end if;
    end loop;
  end if;
end;
/
