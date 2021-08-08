/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  Дата: 26.04.2021

  Описание скрипта: unit-тесты на сущность "Клиент"
*/

---- позитивные
declare
  v_client         client%rowtype;
  v_client_id      client.client_id%type;
  v_blocked_reason client.blocked_reason%type := 'Причина блокировки';

  function get_client(p_client_id client.client_id%type)
    return client%rowtype is
    v_client client%rowtype;
  begin
    select * into v_client from client cl where cl.client_id = p_client_id;
    return v_client;
  end;

  procedure re is
  begin
    raise_application_error(-20999, 'API работает неверно');
  end;

begin
  -- проверяем создание
  v_client_id := client_api_pack.create_client(p_client_data => t_client_data_array());
  v_client    := get_client(v_client_id);
  if (v_client.is_blocked <> client_api_pack.c_not_blocked or
     v_client.blocked_reason is not null or
     v_client.is_active <> client_api_pack.c_active) then
    re();
  end if;

  -- проверяем блокировку  
  client_api_pack.block_client(p_client_id    => v_client_id,
                               p_block_reason => v_blocked_reason);
  v_client := get_client(v_client_id);
  if (v_client.is_blocked <> client_api_pack.c_blocked or
     v_client.blocked_reason <> v_blocked_reason) then
    re();
  end if;

  -- проверяем разблокировку
  client_api_pack.unblock_client(p_client_id => v_client_id);
  v_client := get_client(v_client_id);
  if (v_client.is_blocked <> client_api_pack.c_not_blocked or
     v_client.blocked_reason is not null) then
    re();
  end if;

  -- проверяем деактивацию
  client_api_pack.deactivate_client(p_client_id => v_client_id);
  v_client := get_client(v_client_id);
  if (v_client.is_active <> client_api_pack.c_inactive) then
    re();
  end if;

  dbms_output.put_line('Все тесты прошли успешно');
  rollback;
end;
/

---- негативные
-- 1. запрещен прямой DML
-- 2. в функцию блокировки передается пустая причина
-- 3. функции вызываются для неактивного клиента
