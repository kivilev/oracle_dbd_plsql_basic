create or replace package ut_client_api_pack is

  -- Author  : D.KIVILEV 
  -- Purpose : Тесты для API работы с клиентом

  --%suite(Test client_api_pack)

  --%test(Создание клиента)
  procedure create_client;

  --%test(Блокировка клиента)
  procedure block_client;

  --%test(Разблокировка клиента)
  procedure unblock_client;

  --%test(Деактивация клиента)
  procedure deactivate_client;

  --%test(Прямой delete клиента с отключенными глобальными проверками выполняется успешно)
  procedure delete_client_with_direct_dml_and_enabled_manual_change;

  --%test(Прямой update клиента с отключенными глобальными проверками выполняется успешно)
  procedure update_client_with_direct_dml_and_enabled_manual_change;

  ---- Негативные тест-кейсы

  --%test(Блокировка клиента с пустой причиной завершается ошибкой)
  procedure block_client_with_empty_reason_should_fail;

  --%test(Разблокировка клиента с незаданным ID клиента завершается ошибкой)
  procedure unblock_client_for_undefined_client_id_should_fail;

  --%test(Деактивация клиента с незаданным ID клиента завершается ошибкой)
  procedure deactivate_client_for_undefined_client_id_should_fail;

  --%test(Прямое удаление клиента завершается ошибкой)
  procedure direct_client_delete_should_fail;

  --%test(Прямая вставка клиента (не через API) завершается ошибкой)
  procedure direct_client_insert_should_fail;

  --%test(Прямой update клиента (не через API) завершается ошибкой)
  procedure direct_client_update_should_fail;

  --%test(Блокировка несуществующего клиента завершается ошибкой)
  procedure block_non_existing_client_should_fail;

end ut_client_api_pack;
/
