/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 15. Процедуры и функции
	
  Описание скрипта: параметры PL/SQL-модулей

*/

---- Пример 1. Режимы передачи параметров + позиционный вызов
declare
  v_param1 number := 1;
  v_param2 number := 2;
  v_param3 number := 3;

  ---- локальная процедура
  procedure prc
  (
    p_param1 in number -- вх
   ,p_param2 out number -- вых
   ,p_param3 in out number -- вх + вых
  ) is
  begin
    -- выводим значения фактических параметров
    dbms_output.put_line('Передано в процедуру:');
    dbms_output.put_line('  p_param1: ' || p_param1); -- будет = 1, т.к. тип IN
    dbms_output.put_line('  p_param2: ' || p_param2); -- будет пусто, т.к. тип OUT
    dbms_output.put_line('  p_param3: ' || p_param3); -- будет = 3, т.к. тип IN OUT
  
    --p_param1 := 100; нельзя изменять IN параметр (не скомпилируется)
    p_param2 := p_param3 + 100; -- 3 + 100 будет 103
    p_param3 := 300; -- будет 300
  end;

begin
  -- позиционный вызов (передаем значения в формальные параметры по позициям)
  prc(v_param1, v_param2, v_param3);

  dbms_output.put_line('Вернувшееся значение в v_param2: ' || v_param2); -- 103
  dbms_output.put_line('Вернувшееся значение в v_param3: ' || v_param3); -- 300
end;
/


---- Пример 2. Default-значения + разные типы вызовов
declare
  v_param1 number := 1;
  v_param2 number := 2;
  v_param3 number := 3;

  procedure prc
  (
    p_param1 in number default 0
   ,p_param2 in number
   ,p_param3 out number
  ) is
  begin
    dbms_output.put_line('p1: ' || p_param1 || '. p2: ' || p_param2 ||
                         '. p3: ' || p_param3);
    p_param3 := 300;
  end;

begin
  -- позиционный вызов
  prc(v_param1, v_param2, v_param3);

  -- что делать, если хочется вызвать с p_param1 = default? использовать вызов по имени.
  prc(p_param2 => v_param2, p_param3 => v_param3);

  dbms_output.put_line('param1: ' || v_param1);
  dbms_output.put_line('param2: ' || v_param2);
  dbms_output.put_line('param3: ' || v_param3);
end;
/

---- Пример 3. Еще один пример с default значениями.
alter session set NLS_DATE_LANGUAGE = RUSSIAN;
alter session set NLS_DATE_FORMAT = 'dd.MON.YYYY';

declare
  -- процедура с default значениями
  procedure prc( p_param1 in number 
                ,p_param2 in number := 200
                ,p_param3 in date := date '1983-07-14') is
  begin
    dbms_output.put_line('p1: '||p_param1 ||'. p2: '||p_param2||'. p3: '||p_param3 ); 
  end;
  
begin

  -- один обязательный
  prc(1);

  -- два параметра
  prc(1, 2);

  -- все три параметра
  prc(1, 2, date'1984-01-21');
  
  -- позиционный вызов
  prc(p_param3 => date'1984-01-21', p_param1 => -1);
  
end;
/


---- Пример 4. Функция, которая возвращает значения и в вых параметрах и в return
-- Внимание! это ошибка проектирования. Так делать нельзя.
declare
  v_param1 number := 1;
  v_param2 number := 2;
  v_param3 number := 3;
  v_param4 number;

  -- процедура с default значениями
  function my_fun
  (
    p_param1 in number -- режим IN - OK
   ,p_param2 in out number -- режим IN OUT - жуть!
   ,p_param3 out number -- режим OUT - жуть!
  ) return number is
  begin
    dbms_output.put_line('p1: ' || p_param1 || '. p2: ' || p_param2 ||
                         '. p3: ' || p_param3);
    p_param2 := -1;
    p_param3 := -2;
    return - 3;
  end;

begin
  v_param4 := my_fun(v_param1, v_param2, v_param3);

  dbms_output.put_line('loc param1: ' || v_param1);
  dbms_output.put_line('loc param2: ' || v_param2);
  dbms_output.put_line('loc param3: ' || v_param3);
  dbms_output.put_line('loc param4: ' || v_param4);
end;
/
