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

  -- Коды ошибок
  c_error_code_invalid_input_parameter constant number(10) := -20101;

  -- Объекты ошибок
  e_invalid_input_parameter exception;
  pragma exception_init(e_invalid_input_parameter, c_error_code_invalid_input_parameter);
  
  -- Вставка/обновление клиентских данных
  procedure insert_or_update_client_data(p_client_id   client.client_id%type
                                        ,p_client_data t_client_data_array);

  -- Удаление клиентских данных
  procedure delete_client_data(p_client_id        client.client_id%type
                              ,p_delete_field_ids t_number_array);
end;
/
