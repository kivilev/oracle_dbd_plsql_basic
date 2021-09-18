/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  Дата: 08.04.2021

  Описание скрипта: пример задания 10. Проход по коллекциям + доп проверки
*/

/*
  Автор: Кивилев Д.С.
	Описание: API для сущностей "Клиент" и "Клиентские данные"
*/

-- Создание клиента
declare
  v_message       varchar2(200 char) := 'Клиент создан';
  c_active        constant client.is_active%type := 1;
  c_not_blocked   constant client.is_blocked%type := 0;
  v_current_dtime date := sysdate;
  v_client_data   t_client_data_array := t_client_data_array(t_client_data(1, 'email@email.com'),
                                                             t_client_data(2, '+7999000000'),
                                                             t_client_data(3, '10000000'));
  v_client_id 		client.client_id%type;
begin
  dbms_output.put_line(v_message || '. Статус: ' || c_active ||
                       '. Блокировка: ' || c_not_blocked);
  dbms_output.put_line(to_char(v_current_dtime, 'yyyy-mm-dd hh24:mi:ss'));
  
  if v_client_data is not empty then

		for i in v_client_data.first..v_client_data.last loop

      if(v_client_data(i).field_id is null) then
        dbms_output.put_line('ID поля не может быть пустым');
      end if;

      if(v_client_data(i).field_value is null) then
        dbms_output.put_line('Значение в поле не может быть пустым');
      end if;
      
      dbms_output.put_line('Field_id: '|| v_client_data(i).field_id ||'. Value: '||v_client_data(i).field_value);
    end loop;

  else
    dbms_output.put_line('Коллекция не содержит данных');
  end if;
  
end;
/

-- Блокировка клиента
declare
	v_message       varchar2(200 char) := 'Клиент заблокирован. Блокировка: ';
  c_blocked       constant client.is_blocked%type := 1;
  v_reason        client.blocked_reason%type := 'подозрительный перевод';
  v_current_dtime timestamp := systimestamp;
  v_client_id 		client.client_id%type := 1;
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
  c_not_blocked   constant client.is_blocked%type := 0;
  v_current_dtime timestamp := systimestamp;  
  v_client_id 		client.client_id%type := 1;
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
  c_inactive      constant client.is_active%type := 0;
  v_current_dtime date := sysdate;
  v_client_id 		client.client_id%type;
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
  v_client_id 		client.client_id%type := 1;
  v_client_data   t_client_data_array := t_client_data_array(t_client_data(2, '+7000000000'),
                                                             t_client_data(4, '14.07.1983'));  
begin
  if v_client_id is null then
	  dbms_output.put_line('ID объекта не может быть пустым');
	end if;
  
  if v_client_data is not empty then
    for i in v_client_data.first..v_client_data.last loop
      if(v_client_data(i).field_id is null) then
        dbms_output.put_line('ID поля не может быть пустым');
      end if;
      if(v_client_data(i).field_value is null) then
        dbms_output.put_line('Значение в поле не может быть пустым');
      end if;
      
      dbms_output.put_line('Field_id: '|| v_client_data(i).field_id ||'. Value: '||v_client_data(i).field_value);
    end loop;
  else
    dbms_output.put_line('Коллекция не содержит данных');
  end if;

  dbms_output.put_line(v_message|| '. ID: '|| v_client_id);
  dbms_output.put_line(to_char(v_current_dtime, '"date:"yyyymmdd" time:"hh24:mi'));
end;
/

-- Удаление клиентских данных
declare
  v_message       varchar2(200 char) := 'Клиентские данные удалены по списку id_полей';
  v_current_dtime timestamp := systimestamp;
  v_client_id     client.client_id%type := 100;
  v_delete_field_ids t_number_array := t_number_array(2, 3);
begin
  if v_client_id is null then
    dbms_output.put_line('ID объекта не может быть пустым');
  end if;

  if v_delete_field_ids is empty then
    dbms_output.put_line('Коллекция не содержит данных');
  end if;

  dbms_output.put_line(v_message || '. ID: ' || v_client_id);
  dbms_output.put_line(to_char(v_current_dtime, 'ff4'));
  dbms_output.put_line('Количество удаляемых полей: '||v_delete_field_ids.count());
end;
/

