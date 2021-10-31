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

  -- Блокировка клиента для изменений
  procedure try_lock_client(p_client_id client.client_id%type);


  ---- Триггеры
  
  -- Проверка, допустимость изменения клиента
  procedure is_changes_through_api;
  
  -- Проверка, на возможность удалять данные
  procedure check_client_delete_restriction;
  
end;
/
