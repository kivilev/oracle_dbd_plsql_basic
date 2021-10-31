create or replace package ut_client_data_api_pack is

  -- Author  : D.KIVILEV
  -- Created : 30.10.2021 19:01:09
  -- Purpose : Тесты для API работы с клиентскими данными

  --%suite(Test client_data_api_pack)

  --%test(Вставка или обновление клиентских данных)
  procedure insert_or_update_client_data;

  --%test(Удаление клиентских данных)
  procedure delete_client_data;

  --%test(Изменение клиентских данных через прямой DML с отключением всех проверок завершается без ошибок)
  procedure update_client_data_with_direct_dml_and_enabled_manual_change;

  --%test(Передача пустого массива для вставки клиентских данных завершается ошибкой)
  procedure insert_client_data_with_empty_array_leads_to_error;

  --%test(Передача пустого массива полей для удаления клиентских данных завершается ошибкой)
  procedure delete_client_data_with_empty_array_leads_to_error;

  --%test(Прямая вставка клиентских данных (не через API) завершается ошибкой)
  procedure direct_insert_client_data_leads_to_error;

  --%test(Прямоне обновление клиентских данных (не через API) завершается ошибкой)
  procedure direct_update_client_data_leads_to_error;
  
end ut_client_data_api_pack;
/
