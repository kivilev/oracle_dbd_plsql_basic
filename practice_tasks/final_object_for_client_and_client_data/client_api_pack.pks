create or replace package client_api_pack is

  -- Author  : D.KIVILEV
  -- Created : 26.04.2021 19:49:00
  -- Purpose : API для сущности "Клиент"

  ------ Константы
  -- Активность клиента
  c_inactive constant client.is_active%type := 0;
  c_active   constant client.is_active%type := 1;

  -- Блокировка
  c_not_blocked constant client.is_blocked%type := 0;
  c_blocked     constant client.is_blocked%type := 1;

  -- Ошибки
  c_client_not_found_code  constant number(10) := -20101;
  c_client_not_found_msg   constant varchar2(200 char) := 'Активный клиент не найден';
  c_invalid_param_code     constant number(10) := -20102;
  c_block_reason_empty_msg constant varchar2(200 char) := 'Пустая причина блокировки';
  c_client_id_empty_msg    constant varchar2(200 char) := 'ID объекта не может быть пустым';
  c_manual_change_code     constant number(10) := -20103;
  c_manual_change_code_msg constant varchar2(200 char) := 'Нельзя изменять данные напрямую, только через API';
  c_manual_delete_code_msg constant varchar2(200 char) := 'Нельзя удалить клиента. Используйте деактивацию';
  c_object_locked_code     constant number(10) := -20154;
  c_object_locked_code_msg constant varchar2(200 char) := 'Клиент уже заблокирован';

  -- Исключения
  e_object_locked exception;
  pragma exception_init(e_object_locked, -00054);

  ------ API
  -- создание клиента с данными
  function create_client(p_client_data t_client_data_array)
    return client.client_id%type;

  -- блокировка клиента
  procedure block_client(p_client_id    client.client_id%type
                        ,p_block_reason client.blocked_reason%type);

  -- разблокировка клиента
  procedure unblock_client(p_client_id client.client_id%type);

  -- деактивация клиента
  procedure deactivate_client(p_client_id client.client_id%type);

  -- проверка, выполняются ли изменения через API (вызывается в триггере)
  procedure is_changes_through_api;

  -- блокировка клиента для изменений
  procedure lock_client_for_update(p_client_id client.client_id%type);

end;
/
