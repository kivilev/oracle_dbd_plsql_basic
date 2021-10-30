create or replace package client_data_api_pack is

  /*
  Автор: Кивилев Д.С.
  Описание: API для сущностей "Клиентские данные"
  */

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
