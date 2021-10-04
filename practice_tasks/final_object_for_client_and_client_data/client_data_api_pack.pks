create or replace package client_data_api_pack is

  -- Author  : D.KIVILEV
  -- Created : 26.04.2021 22:54:52
  -- Purpose : API для сущности "Данные клиента"

  ------ Константы
  c_invalid_param_code            constant number(10) := -20102;
  c_empty_data_list               constant varchar2(200 char) := 'Коллекция не содержит данных';
  c_empty_field_id_in_client_data constant varchar2(200 char) := 'ID поля не может быть пустым';
  c_empty_value_in_client_data    constant varchar2(200 char) := 'Значение в поле не может быть пустым';
  c_manual_change_code            constant number(10) := -20103;
  c_manual_change_code_msg        constant varchar2(200 char) := 'Нельзя изменять данные напрямую, только через API';

  ------ API
  -- вставка данных, если нет или обновление, если есть
  procedure insert_or_update_client_data(p_client_id   client.client_id%type
                                 ,p_client_data t_client_data_array);

  -- удаление данных по id полей
  procedure delete_client_data(p_client_id        client.client_id%type
                       ,p_delete_field_ids t_number_array);

  -- проверка, выполняются ли изменения через API (вызывается в триггере)
  procedure is_changes_through_api;

end;
/
