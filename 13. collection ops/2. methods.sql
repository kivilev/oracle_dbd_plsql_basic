/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 13. Операции с коллекциями
	
  Описание скрипта: примеры встроенных методов коллекций
*/

----- Пример 1. first, last - индексы первого и последнего элементов
declare
  type t_arr is table of number(30);
  v_arr t_arr := t_arr(777, 888, 999, 1111);
begin
  dbms_output.put_line('Index first: ' || v_arr.first); -- 1
  dbms_output.put_line('Index last: ' || v_arr.last); -- 4

  dbms_output.put_line('Value first: ' || v_arr(v_arr.first)); -- 777
  dbms_output.put_line('Value last: ' || v_arr(v_arr.last)); -- 1111
end;
/

----- Пример 2. prior, next - индексы предыдщуего или следуюещо элементов от переданного индекса
declare
  type t_arr is table of number(30);
  v_arr         t_arr := t_arr(777, 888, 999, 1111);
  v_prior_index pls_integer;
  v_next_index  pls_integer;
begin
  v_prior_index := v_arr.prior(2);
  v_next_index  := v_arr.next(2);
  dbms_output.put_line('Index prior: ' || v_prior_index); -- 1
  dbms_output.put_line('Index next: ' || v_next_index); -- 3

  dbms_output.put_line('Value prior: ' || v_arr(v_prior_index)); -- 777
  dbms_output.put_line('Value next: ' || v_arr(v_next_index)); -- 999
end;
/

----- Пример 3. exists - проверка на существование элемента
declare
  type t_arr is table of number(30);
  v_arr t_arr := t_arr(777, 10, 100);
begin
  if v_arr.exists(1) then
    dbms_output.put_line('1й элемент существует'); -- +
  else
    dbms_output.put_line('1й элемент НЕ существует');     
  end if;
  
  if v_arr.exists(100) then
    dbms_output.put_line('100й элемент существует'); 
  else
    dbms_output.put_line('100й элемент НЕ существует'); -- + 
  end if;
end;
/

----- Пример 4. extend - расширение коллекции
declare
  type t_arr is table of number(30);
  v_arr t_arr := t_arr();
begin
  v_arr.extend(1); -- если убрать, то на следующей строке будет ошибка
  v_arr(1) := 888;
  dbms_output.put_line(v_arr(v_arr.first)); -- 888
end;
/

----- Пример 5. count - количество элементов в коллекции
declare
  type t_arr is table of number(30);
  v_arr t_arr := t_arr(1, 10, 100);
begin
  dbms_output.put_line('Количество элементов: ' || v_arr.count); -- 3
end;
/

----- Пример 6. limit - максимальный размер массива varray
declare
  type t_arr is varray(10) of number(30);
  v_arr t_arr := t_arr();
begin
  dbms_output.put_line('Количество элементов: ' || v_arr.count); -- 0  
  dbms_output.put_line('Максимальный размер varray: ' || v_arr.limit()); -- 10  
end;
/

----- Пример 7. delete - удаление элементов из коллекции по индексы
declare
  type t_arr is table of number(30);
  v_arr t_arr := t_arr(777, 10, 100);
begin
  dbms_output.put_line('Количество элементов: ' || v_arr.count); -- 3
  dbms_output.put_line('1й элемент коллекции: '||v_arr(1)); -- 777
  
  v_arr.delete(1);-- удаляем элемент с позиции "1"
  
  if v_arr.exists(1) then
    dbms_output.put_line('1й элемент существует');
  else
    dbms_output.put_line('1й элемент НЕ существует'); -- +   
  end if;
  
  v_arr.delete(); -- удаляем все элементы
  
  dbms_output.put_line('Количество элементов: ' || v_arr.count); -- 0
end;
/

----- Пример 8. trim - усечение varray с конца 
declare
  type t_arr is varray(10) of number(30);
  v_arr t_arr := t_arr(777, 888, 999);
begin
  dbms_output.put_line('Количество элементов: ' || v_arr.count); -- 3 
  
  v_arr.trim(1);
  
  dbms_output.put_line('Количество элементов: ' || v_arr.count); -- 2
end;
/

