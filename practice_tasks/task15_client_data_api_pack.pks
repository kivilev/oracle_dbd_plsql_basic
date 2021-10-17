create or replace package client_data_api_pack is

  /*
  Автор: Кивилев Д.С.
  Описание: API для сущностей "Клиентские данные"
  */
  
  -- Сообщения ошибок
  c_error_msg_empty_field_id    constant varchar2(100 char) := 'ID поля не может быть пустым';
  c_error_msg_empty_field_value constant varchar2(100 char) := 'Значение в поле не может быть пустым';
  c_error_msg_empty_collection  constant varchar2(100 char) := 'Коллекция не содержит данных';
  c_error_msg_empty_object_id   constant varchar2(100 char) := 'ID объекта не может быть пустым';
  c_error_msg_manual_changes    constant varchar2(100 char) := 'Изменения должны выполняться только через API';

  -- Коды ошибок
  c_error_code_invalid_input_parameter constant number(10) := -20101;
  c_error_code_manual_changes          constant number(10) := -20102;

  -- Объекты ошибок
  e_invalid_input_parameter exception;
  pragma exception_init(e_invalid_input_parameter, -20101);
  e_manual_changes exception;
  pragma exception_init(e_manual_changes, -20102);
    
  -- Вставка/обновление клиентских данных
  procedure insert_or_update_client_data(p_client_id   client.client_id%type
                                        ,p_client_data t_client_data_array);

  -- Удаление клиентских данных
  procedure delete_client_data(p_client_id        client.client_id%type
                              ,p_delete_field_ids t_number_array);

  -- Выполняются ли изменения через API
  procedure is_changes_through_api;

end;
/
