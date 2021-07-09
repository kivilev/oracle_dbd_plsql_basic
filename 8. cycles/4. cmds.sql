------- 4. Команды exit, continue

-- Пример 1. При выполнении условия цикл завершается
declare
  v_i number(10) := 1;
begin
  loop
    if (v_i = 10)
    then
      exit;
    end if;
  
    v_i := v_i + 1;
    dbms_output.put_line('v_i: ' || v_i);
  end loop;
end;
/

-- Пример 2. Тело цикла выполняется только для нечетных значений. Четные пропускаются.
begin

  for i in 1 .. 10 loop
    if mod(i, 2) = 0 -- остаток от деления
    then
      continue;
    end if;
  
    dbms_output.put_line('i: ' || i);
  end loop;

end;
/
