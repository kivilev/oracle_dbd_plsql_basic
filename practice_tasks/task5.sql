/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Описание скрипта: пример задания 5. 
   - добавить ID клиента
   - добавить условия на пустоту
*/

/*
  Автор: Кивилев Д.С.
	Описание: API для сущностей "Клиент" и "Клиентские данные"
*/

-- Создание клиента
declare
  v_message       varchar2(200 char) := 'Клиент создан';
  c_active        constant number(1) := 1;
  c_not_blocked   constant number(1) := 0;
  v_current_dtime date := sysdate;
  v_client_id 		number(30);
begin
  dbms_output.put_line(v_message || '. Статус: ' || c_active || '. Блокировка: ' || c_not_blocked);
  dbms_output.put_line(to_char(v_current_dtime, 'yyyy-mm-dd hh24:mi:ss'));
end;
/

-- Блокировка клиента
declare
	v_message       varchar2(200 char) := 'Клиент заблокирован. Блокировка: ';
  c_blocked       constant number(1) := 1;
  v_reason        varchar2(1000 char) := 'подозрительный перевод';
  v_current_dtime timestamp := systimestamp;
  v_client_id 		number(30) := 1;
begin
  if v_client_id is null then
	  dbms_output.put_line('ID объекта не может быть пустым');
	end if;

  if v_reason is null then
	  dbms_output.put_line('Причина не может быть пустой');
	end if;

  dbms_output.put_line(v_message || c_blocked || '. Причина: ' || v_reason || '. ID: '|| v_client_id);
  dbms_output.put_line(to_char(v_current_dtime, 'yyyy-mm-dd hh24:mi:ss'));
end;
/

-- Разблокировка клиента
declare 
  v_message       varchar2(200 char) := 'Клиент разблокирован. Блокировка: ';
  c_not_blocked   constant number(1) := 0;
  v_current_dtime timestamp := systimestamp;  
  v_client_id 		number(30) := 1;
begin
  if v_client_id is null then
	  dbms_output.put_line('ID объекта не может быть пустым');
	end if;

  dbms_output.put_line(v_message || c_not_blocked|| '. ID: '|| v_client_id);
  dbms_output.put_line(to_char(v_current_dtime, 'mm/dd/yyyy hh24:mi:ss.ff'));  
end;
/

-- Деактивация клиента
declare
  v_message       varchar2(200 char) := 'Клиент деактивирован. Статус активности: ';
  c_inactive      constant number(1) := 0;
  v_current_dtime date := sysdate;  
  v_client_id 		number(30);
begin
  if v_client_id is null then
	  dbms_output.put_line('ID объекта не может быть пустым');
	end if;

  dbms_output.put_line(v_message || c_inactive || '. ID: '|| v_client_id);
  dbms_output.put_line(to_char(v_current_dtime, 'yyyy_mm_dd_hh24'));  
end;
/

-- Добавление/изменение клиентских данных
declare
  v_message       varchar2(200 char) := 'Клиентские данные вставлены или обновлены по списку id_поля/значение';
  v_current_dtime date := sysdate;
  v_client_id 		number(30) := 1;
begin
  if v_client_id is null then
	  dbms_output.put_line('ID объекта не может быть пустым');
	end if;

  dbms_output.put_line(v_message|| '. ID: '|| v_client_id);
  dbms_output.put_line(to_char(v_current_dtime, '"date:"yyyymmdd" time:"hh24:mi'));
end;
/

-- Удаление клиентских данных
declare
  v_message       varchar2(200 char) := 'Клиентские данные удалены по списку id_полей';
  v_current_dtime timestamp := systimestamp;
  v_client_id 		number(30) := 100;
begin
  if v_client_id is null then
	  dbms_output.put_line('ID объекта не может быть пустым');
	end if;

  dbms_output.put_line(v_message|| '. ID: '|| v_client_id);
  dbms_output.put_line(to_char(v_current_dtime, 'ff4'));
end;
/