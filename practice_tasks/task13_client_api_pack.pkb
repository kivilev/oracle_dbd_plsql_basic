/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  Дата: 08.04.2021

  Описание скрипта: пример задания 13. Создание пакетов
*/

create or replace package body client_api_pack is

  -- Создание клиента
  function create_client(p_client_data t_client_data_array)
    return client.client_id%type is
    v_message       varchar2(200 char) := 'Клиент создан';
    v_current_dtime date := sysdate;
    v_client_id     client.client_id%type;
  begin
    dbms_output.put_line(v_message || '. Статус: ' || c_active ||
                         '. Блокировка: ' || c_not_blocked);
    dbms_output.put_line(to_char(v_current_dtime, 'yyyy-mm-dd hh24:mi:ss'));
  
    if p_client_data is not empty then
      for i in p_client_data.first .. p_client_data.last loop
        if (p_client_data(i).field_id is null) then
          dbms_output.put_line('ID поля не может быть пустым');
        end if;
        if (p_client_data(i).field_value is null) then
          dbms_output.put_line('Значение в поле не может быть пустым');
        end if;
      
        dbms_output.put_line('Field_id: ' || p_client_data(i).field_id ||
                             '. Value: ' || p_client_data(i).field_value);
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
        from table(p_client_data) t;
  
    return v_client_id;
  end;


  -- Блокировка клиента
  procedure block_client(p_client_id    client.client_id%type
                        ,p_block_reason client.blocked_reason%type) is
    v_message       varchar2(200 char) := 'Клиент заблокирован. Блокировка: ';
    v_current_dtime timestamp := systimestamp;
  begin
    if p_client_id is null then
      dbms_output.put_line('ID объекта не может быть пустым');
    end if;
  
    if p_block_reason is null then
      dbms_output.put_line('Причина не может быть пустой');
    end if;
  
    dbms_output.put_line(v_message || c_blocked || '. Причина: ' ||
                         p_block_reason || '. ID: ' || p_client_id);
    dbms_output.put_line(to_char(v_current_dtime, 'yyyy-mm-dd hh24:mi:ss'));
  
    -- обновляем клиента
    update client cl
       set cl.is_blocked     = c_blocked
          ,cl.blocked_reason = p_block_reason
     where cl.client_id = p_client_id
       and cl.is_active = c_active;
  end;


  -- Разблокировка клиента
  procedure unblock_client(p_client_id client.client_id%type) is
    v_message       varchar2(200 char) := 'Клиент разблокирован. Блокировка: ';
    v_current_dtime timestamp := systimestamp;
  begin
    if p_client_id is null then
      dbms_output.put_line('ID объекта не может быть пустым');
    end if;
  
    dbms_output.put_line(v_message || c_not_blocked || '. ID: ' ||
                         p_client_id);
    dbms_output.put_line(to_char(v_current_dtime,
                                 'mm/dd/yyyy hh24:mi:ss.ff'));
  
    -- обновляем клиента
    update client cl
       set cl.is_blocked     = c_not_blocked
          ,cl.blocked_reason = null
     where cl.client_id = p_client_id
       and cl.is_active = c_active;
  end;


  -- Деактивация клиента
  procedure deactivate_client(p_client_id client.client_id%type) is
    v_message       varchar2(200 char) := 'Клиент деактивирован. Статус активности: ';
    v_current_dtime date := sysdate;
  begin
    if p_client_id is null then
      dbms_output.put_line('ID объекта не может быть пустым');
    end if;
  
    dbms_output.put_line(v_message || c_inactive || '. ID: ' ||
                         p_client_id);
    dbms_output.put_line(to_char(v_current_dtime, 'yyyy_mm_dd_hh24'));
  
    -- обновляем клиента
    update client cl
       set cl.is_active = c_inactive
     where cl.client_id = p_client_id
       and cl.is_active = c_active;
  end;

end;
/
