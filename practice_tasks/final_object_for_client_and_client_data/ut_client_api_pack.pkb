create or replace package body ut_client_api_pack is

  procedure create_client is
    v_client_id         client.client_id%type;
    v_create_dtime_tech client.create_dtime_tech%type;
    v_update_dtime_tech client.update_dtime_tech%type;
    v_client            client%rowtype;
  begin
    -- вызов тестируемой функции
    v_client_id := ut_common_pack.create_default_client();
  
    -- получаем данные по клиенту
    v_client := ut_common_pack.get_client_info(v_client_id);
  
    -- проверка правильного заполнения полей
    if v_client.is_active != client_api_pack.c_active
       or v_client.is_blocked != client_api_pack.c_not_blocked
       or v_client.blocked_reason is not null then
      ut_common_pack.ut_failed();
    end if;
  
    -- ! проверка самих данных клиента выполняется в юнит-тесте API для клиентских данных
  
    -- проверка работы триггера на заполнение тех дат
    if v_client.create_dtime_tech != v_client.update_dtime_tech then
      ut_common_pack.ut_failed();
    end if;
  
  end;

  procedure block_client is
    v_client_id         client.client_id%type;
    v_reason            client.blocked_reason%type := dbms_random.string('a',
                                                                         100);
    v_create_dtime_tech client.create_dtime_tech%type;
    v_update_dtime_tech client.update_dtime_tech%type;
    v_client            client%rowtype;
  begin
    -- setup
    v_client_id := ut_common_pack.create_default_client();
  
    -- вызов тестируемой функции
    client_api_pack.block_client(p_client_id => v_client_id,
                                 p_reason    => v_reason);
  
    -- получаем данные по клиенту
    v_client := ut_common_pack.get_client_info(v_client_id);
  
    -- проверка правильного заполнения полей
    if v_client.is_blocked != client_api_pack.c_blocked
       or v_client.blocked_reason != v_reason then
      ut_common_pack.ut_failed();
    end if;
  
    -- проверка работы триггера по изменению технических полей
    if v_client.create_dtime_tech = v_client.update_dtime_tech then
      ut_common_pack.ut_failed();
    end if;
  
  end;

  procedure unblock_client is
    v_client_id client.client_id%type;
    v_client    client%rowtype;
  begin
    -- setup
    v_client_id := ut_common_pack.create_default_client();
  
    -- вызов тестируемой функции
    client_api_pack.unblock_client(p_client_id => v_client_id);
  
    -- получаем данные по клиенту
    v_client := ut_common_pack.get_client_info(v_client_id);
  
    -- проверка правильного заполнения полей
    if v_client.is_blocked != client_api_pack.c_not_blocked
       or v_client.blocked_reason is not null then
      ut_common_pack.ut_failed();
    end if;
  
  end;

  procedure deactivate_client is
    v_client_id client.client_id%type;
    v_client    client%rowtype;
  begin
    -- setup
    v_client_id := ut_common_pack.create_default_client();
  
    -- вызов тестируемой функции
    client_api_pack.deactivate_client(p_client_id => v_client_id);
  
    -- получаем данные по клиенту
    v_client := ut_common_pack.get_client_info(v_client_id);
  
    -- проверка работы триггера по изменению технических полей
    if v_client.is_active != client_api_pack.c_inactive then
      ut_common_pack.ut_failed();
    end if;
  
  end;

  procedure delete_client_with_direct_dml_and_enabled_manual_change is
    v_client_id client.client_id%type := ut_common_pack.c_non_existing_client_id;
  begin
    common_pack.enable_manual_changes();
  
    delete from client cl where cl.client_id = v_client_id;
  
    common_pack.disable_manual_changes();
  exception
    when others then
      common_pack.disable_manual_changes();
      raise;
  end;

  procedure update_client_with_direct_dml_and_enabled_manual_change is
    v_client_id client.client_id%type := ut_common_pack.c_non_existing_client_id;
  begin
    common_pack.enable_manual_changes();
  
    update client cl
       set cl.is_active = cl.is_active
     where cl.client_id = v_client_id;
  
    common_pack.disable_manual_changes();
  exception
    when others then
      common_pack.disable_manual_changes();
      raise;
  end;

  procedure block_client_with_empty_reason_should_fail is
    v_client_id client.client_id%type;
    v_reason    client.blocked_reason%type := null;
  begin
    -- setup
    v_client_id := ut_common_pack.create_default_client();
  
    client_api_pack.block_client(p_client_id => v_client_id,
                                 p_reason    => v_reason);
  
    ut_common_pack.ut_failed();
  exception
    when common_pack.e_invalid_input_parameter then
      null;
  end;

  procedure unblock_client_for_undefined_client_id_should_fail is
    v_client_id client.client_id%type := null;
  begin
 
    client_api_pack.unblock_client(p_client_id => v_client_id);
  
    ut_common_pack.ut_failed();
  exception
    when common_pack.e_invalid_input_parameter then
      null;
  end;

  procedure deactivate_client_for_undefined_client_id_should_fail is
    v_client_id client.client_id%type := null;
  begin

    client_api_pack.deactivate_client(p_client_id => v_client_id);
  
    ut_common_pack.ut_failed();
  exception
    when common_pack.e_invalid_input_parameter then
      null;
  end;

  procedure direct_client_delete_should_fail is
    v_client_id client.client_id%type := ut_common_pack.c_non_existing_client_id;
  begin
    delete from client cl where cl.client_id = v_client_id;
  
    ut_common_pack.ut_failed();
  exception
    when common_pack.e_delete_forbidden then
      null;
  end;

  procedure direct_client_insert_should_fail is
    v_client_id client.client_id%type := ut_common_pack.c_non_existing_client_id;
  begin
    insert into client
      (client_id
      ,is_active
      ,is_blocked
      ,blocked_reason)
    values
      (v_client_id
      ,client_api_pack.c_active
      ,client_api_pack.c_not_blocked
      ,null);
  
    ut_common_pack.ut_failed();
  exception
    when common_pack.e_manual_changes then
      null;
  end;


  procedure direct_client_update_should_fail is
    v_client_id client.client_id%type := ut_common_pack.c_non_existing_client_id;
  begin
  
    update client cl
       set cl.is_active = cl.is_active
     where cl.client_id = v_client_id;
  
    ut_common_pack.ut_failed();
  exception
    when common_pack.e_manual_changes then
      null;
  end;

  procedure block_non_existing_client_should_fail is
    v_client_id client.client_id%type := ut_common_pack.c_non_existing_client_id;
    v_reason    client.blocked_reason%type := dbms_random.string('a', 100);
  begin
    client_api_pack.block_client(p_client_id => v_client_id,
                                 p_reason    => v_reason);
  
    ut_common_pack.ut_failed();
  exception
    when common_pack.e_object_notfound then
      null;
  end;

end ut_client_api_pack;
/
