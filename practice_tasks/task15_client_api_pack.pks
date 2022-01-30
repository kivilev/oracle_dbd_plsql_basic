create or replace package client_api_pack is
  /*
    Автор: Кивилев Д.С.
    Описание: API для сущности "Клиент"
  */

  -- Статусы активности клиента
  c_active   constant client.is_active%type := 1;
  c_inactive constant client.is_active%type := 0;

  -- Статусы блокировки клиента
  c_not_blocked constant client.is_blocked%type := 0;
  c_blocked     constant client.is_blocked%type := 1;

  -- Сообщения ошибок
  c_error_msg_empty_field_id    constant varchar2(100 char) := 'ID поля не может быть пустым';
  c_error_msg_empty_field_value constant varchar2(100 char) := 'Значение в поле не может быть пустым';
  c_error_msg_empty_collection  constant varchar2(100 char) := 'Коллекция не содержит данных';
  c_error_msg_empty_object_id   constant varchar2(100 char) := 'ID объекта не может быть пустым';
  c_error_msg_empty_reason      constant varchar2(100 char) := 'Причина не может быть пустой';
  c_error_msg_delete_forbidden  constant varchar2(100 char) := 'Удаление объекта запрещено';
  c_error_msg_manual_changes    constant varchar2(100 char) := 'Изменения должны выполняться только через API';

  -- Коды ошибок
  c_error_code_invalid_input_parameter constant number(10) := -20101;
  c_error_code_delete_forbidden        constant number(10) := -20102;
  c_error_code_manual_changes          constant number(10) := -20103;

  -- Объекты ошибок
  e_invalid_input_parameter exception;
  pragma exception_init(e_invalid_input_parameter, c_error_code_invalid_input_parameter);
  e_delete_forbidden exception;
  pragma exception_init(e_delete_forbidden, c_error_code_delete_forbidden);
  e_manual_changes exception;
  pragma exception_init(e_manual_changes, c_error_code_manual_changes);


  ---- API
  -- Создание клиента
  function create_client(p_client_data t_client_data_array)
    return client.client_id%type;

  -- Блокировка клиента
  procedure block_client(p_client_id client.client_id%type
                        ,p_reason    client.blocked_reason%type);


  -- Разблокировка клиента
  procedure unblock_client(p_client_id client.client_id%type);

  -- Клиент деактивирован
  procedure deactivate_client(p_client_id client.client_id%type);
  
  -- Выполняются ли изменения через API
  procedure is_changes_through_api;

end;
/
