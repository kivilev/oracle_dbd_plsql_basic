/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Описание скрипта: пример задания 14. Создание триггеров
*/

create or replace package client_data_api_pack is

  /*
    Автор: Кивилев Д.С.
    Описание: API для сущности "Клиентские данные"
  */

  -- Добавление/изменение клиентских данных
  procedure insert_or_update_data(p_client_id   client.client_id%type
                                 ,p_client_data t_client_data_array);

  -- Удаление клиентских данных
  procedure delete_data(p_client_id        client.client_id%type
                       ,p_delete_field_ids t_number_array);

  -- Проверка происходит ли изменение через API (вызыывается в триггере)
  procedure is_changes_through_api;

end;
/
