/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Описание скрипта: пример задания 13. Создание пакетов
*/

create or replace package client_api_pack is
  /*
    Автор: Кивилев Д.С.
    Описание: API для сущности "Клиент"
  */

  ------ Константы
  -- Статусы активности
  c_active   constant client.is_active%type := 1;
  c_inactive constant client.is_active%type := 0;
  -- Статусы блокировки
  c_not_blocked constant client.is_blocked%type := 0;
  c_blocked     constant client.is_blocked%type := 1;

  ------ API
  -- Создание клиента
  function create_client(p_client_data t_client_data_array)
    return client.client_id%type;

  -- Блокировка клиента
  procedure block_client(p_client_id    client.client_id%type
                        ,p_block_reason client.blocked_reason%type);

  -- Разблокировка клиента
  procedure unblock_client(p_client_id client.client_id%type);

  -- Деактивация клиента
  procedure deactivate_client(p_client_id client.client_id%type);

end;
/
