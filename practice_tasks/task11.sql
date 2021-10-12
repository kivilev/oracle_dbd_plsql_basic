/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Описание скрипта: пример задания 11. Использование SQL в PL/SQL
*/

/*
  Автор: Кивилев Д.С.
	Описание: API для сущностей "Клиент" и "Клиентские данные"
*/

-- Создание клиента
declare
  v_message varchar2(200 char) := 'Клиент создан';
  c_active      constant client.is_active%type := 1;
  c_not_blocked constant client.is_blocked%type := 0;
  v_current_dtime date := sysdate;
  v_client_data   t_client_data_array := t_client_data_array(t_client_data(1,
                                                                           'email@email.com'),
                                                             t_client_data(2,
                                                                           '+7999000000'),
                                                             t_client_data(3,
                                                                           '10000000'));
  v_client_id     client.client_id%type;
begin
  dbms_output.put_line(v_message || '. Статус: ' || c_active ||
                       '. Блокировка: ' || c_not_blocked);
  dbms_output.put_line(to_char(v_current_dtime, 'yyyy-mm-dd hh24:mi:ss'));

  if v_client_data is not empty then
    for i in v_client_data.first .. v_client_data.last loop
      if (v_client_data(i).field_id is null) then
        dbms_output.put_line('ID поля не может быть пустым');
      end if;
      if (v_client_data(i).field_value is null) then
        dbms_output.put_line('Значение в поле не может быть пустым');
      end if;
    
      dbms_output.put_line('Field_id: ' || v_client_data(i).field_id ||
                           '. Value: ' || v_client_data(i).field_value);
    end loop;
  else
    dbms_output.put_line('Коллекция не содержит данных');
  end if;
  
  -- создание записи в таблице "клиент"
  insert into client
    (client_id
    ,is_active
    ,is_blocked
    ,blocked_reason)
  values
    (client_seq.nextval
    ,c_active
    ,c_not_blocked
    ,null)
  returning client_id into v_client_id; -- возвращается новый ID из client_seq

  dbms_output.put_line('Client_id of new client: ' || v_client_id);

  -- вставляем клиентские данные
  insert into client_data
    (client_id
    ,field_id
    ,field_value)
    select v_client_id
          ,value      (t).field_id
          ,value      (t).field_value
      from table(v_client_data) t;
end;
/

-- Блокировка клиента
declare
	v_message       varchar2(200 char) := 'Клиент заблокирован. Блокировка: ';
  c_blocked       constant client.is_blocked%type := 1;
  v_reason        client.blocked_reason%type := 'подозрительный перевод';
  v_current_dtime timestamp := systimestamp;
  v_client_id 		client.client_id%type := 1;
  c_active        constant client.is_blocked%type := 1;
begin
  if v_client_id is null then
	  dbms_output.put_line('ID объекта не может быть пустым');
	end if;

  if v_reason is null then
	  dbms_output.put_line('Причина не может быть пустой');
	end if;

  dbms_output.put_line(v_message || c_blocked || '. Причина: ' || v_reason || '. ID: '|| v_client_id);
  dbms_output.put_line(to_char(v_current_dtime, 'yyyy-mm-dd hh24:mi:ss'));
  
  -- обновляем клиента
  update client cl
     set cl.is_blocked     = c_blocked
        ,cl.blocked_reason = v_reason
   where cl.client_id = v_client_id
     and cl.is_active = c_active;
  
end;
/

-- Разблокировка клиента
declare 
  v_message       varchar2(200 char) := 'Клиент разблокирован. Блокировка: ';
  c_not_blocked   constant client.is_blocked%type := 0;
  v_current_dtime timestamp := systimestamp;  
  v_client_id 		client.client_id%type := 1;
  c_active        constant client.is_blocked%type := 1; 
begin
  if v_client_id is null then
	  dbms_output.put_line('ID объекта не может быть пустым');
	end if;

  dbms_output.put_line(v_message || c_not_blocked|| '. ID: '|| v_client_id);
  dbms_output.put_line(to_char(v_current_dtime, 'mm/dd/yyyy hh24:mi:ss.ff'));

  -- обновляем клиента    
  update client cl
     set cl.is_blocked     = c_not_blocked
        ,cl.blocked_reason = null
   where cl.client_id = v_client_id
     and cl.is_active = c_active;  
end;
/

-- Деактивация клиента
declare
  v_message       varchar2(200 char) := 'Клиент деактивирован. Статус активности: ';
  c_inactive      constant client.is_active%type := 0;
  v_current_dtime date := sysdate;
  v_client_id 		client.client_id%type;
  c_active        constant client.is_blocked%type := 1;   
begin
  if v_client_id is null then
	  dbms_output.put_line('ID объекта не может быть пустым');
	end if;

  dbms_output.put_line(v_message || c_inactive || '. ID: '|| v_client_id);
  dbms_output.put_line(to_char(v_current_dtime, 'yyyy_mm_dd_hh24'));  
  
  -- обновляем клиента
  update client cl
     set cl.is_active = c_inactive
   where cl.client_id = v_client_id
     and cl.is_active = c_active;  
end;
/

-- Добавление/изменение клиентских данных
declare
  v_message       varchar2(200 char) := 'Клиентские данные вставлены или обновлены по списку id_поля/значение';
  v_current_dtime date := sysdate;
  v_client_id     client.client_id%type := 1;
  v_client_data   t_client_data_array := t_client_data_array(t_client_data(2,
                                                                           '+7000000000'),
                                                             t_client_data(4,
                                                                           '14.07.1983'));
begin
  if v_client_id is null then
    dbms_output.put_line('ID объекта не может быть пустым');
  end if;

  if v_client_data is not empty then
    for i in v_client_data.first .. v_client_data.last loop
      if (v_client_data(i).field_id is null) then
        dbms_output.put_line('ID поля не может быть пустым');
      end if;
      if (v_client_data(i).field_value is null) then
        dbms_output.put_line('Значение в поле не может быть пустым');
      end if;
    
      dbms_output.put_line('Field_id: ' || v_client_data(i).field_id ||
                           '. Value: ' || v_client_data(i).field_value);
    end loop;
  else
    dbms_output.put_line('Коллекция не содержит данных');
  end if;

  dbms_output.put_line(v_message || '. ID: ' || v_client_id);
  dbms_output.put_line(to_char(v_current_dtime,
                               '"date:"yyyymmdd" time:"hh24:mi'));

  -- вставка или обновление
  merge into client_data o
  using (select v_client_id client_id
               ,value      (t).field_id       field_id
               ,value      (t).field_value       field_value
           from table(v_client_data) t) n
  on (o.client_id = n.client_id and o.field_id = n.field_id)
  when matched then
    update set o.field_value = n.field_value
  when not matched then
    insert
      (client_id
      ,field_id
      ,field_value)
    values
      (n.client_id
      ,n.field_id
      ,n.field_value);
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

  if p_delete_field_ids is null or p_delete_field_ids is empty then
    dbms_output.put_line('Коллекция не содержит данных');
  end if;

  dbms_output.put_line(v_message || '. ID: ' || v_client_id);
  dbms_output.put_line(to_char(v_current_dtime, 'ff4'));
  dbms_output.put_line('Количество удаляемых полей: '||v_delete_field_ids.count());

  -- удаляем клиентские данные
  delete client_data cd
   where cd.client_id = v_client_id
     and cd.field_id in (select value(t) from table(v_delete_field_ids) t);
       
end;
/

