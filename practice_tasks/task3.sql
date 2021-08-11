/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Описание скрипта: пример задания 3. Использование переменных и констант   
*/

/*
  Автор: Кивилев Д.С.
	Описание: API для сущностей "Клиент" и "Клиентские данные"
*/

-- Создание клиента
declare
  v_message 	  varchar2(200) := 'Клиент создан';
  c_active      constant number := 1;
  c_not_blocked constant number := 0;
begin
  dbms_output.put_line(v_message || '. Статус: ' || c_active || '. Блокировка: ' || c_not_blocked);
end;
/

-- Блокировка клиента
declare
  v_message varchar2(200) := 'Клиент заблокирован. Блокировка: ';
  c_blocked constant number := 1;
  v_reason  varchar2(200) := 'подозрительный перевод';
begin
  dbms_output.put_line(v_message || c_blocked || '. Причина: ' || v_reason);
end;
/

-- Разблокировка клиента
declare 
  v_message varchar2(200) := 'Клиент разблокирован. Блокировка: ';
  c_not_blocked constant number := 0;  
begin
  dbms_output.put_line(v_message || c_not_blocked);
end;
/

-- Деактивация клиента
declare
  v_message varchar2(200) := 'Клиент деактивирован. Статус активности: ';
  c_inactive constant number := 0;
begin
  dbms_output.put_line(v_message || c_inactive);
end;
/

-- Добавление/изменение клиентских данных
declare
  v_message varchar2(200) := 'Клиентские данные вставлены или обновлены по списку id_поля/значение';
begin
  dbms_output.put_line(v_message);
end;
/

-- Удаление клиентских данных
declare
  v_message varchar2(200) := 'Клиентские данные удалены по списку id_полей';
begin
  dbms_output.put_line(v_message);
end;
/
