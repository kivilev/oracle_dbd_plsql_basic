create or replace package body ut_common_pack is

  -- Генерация значения полей для сущности клиент
  function get_random_client_email return client_data.field_value%type is
  begin
    return dbms_random.string('l', 10) || '@' || dbms_random.string('l',
                                                                    10) || '.com';
  end;

  function get_random_client_mobile_phone return client_data.field_value%type is
  begin
    return '+7' || trunc(dbms_random.value(79000000000, 79999999999));
  end;

  function get_random_client_inn return client_data.field_value%type is
  begin
    return trunc(dbms_random.value(1000000000000, 99999999999999));
  end;

  function get_random_client_bday return client_data.field_value%type is
  begin
    return add_months(trunc(sysdate),
                      -trunc(dbms_random.value(18 * 12, 50 * 12)));
  end;

  function create_default_client(p_client_data t_client_data_array := null)
    return client.client_id%type is
    v_client_data t_client_data_array := p_client_data;
  begin
    -- если ничего не передано, то по умолчанию генерим какие-то значения
    if v_client_data is null
       or v_client_data is empty then
      v_client_data := t_client_data_array(t_client_data(c_client_field_email_id,
                                                         get_random_client_email()),
                                           t_client_data(c_client_mobile_phone_id,
                                                         get_random_client_mobile_phone()),
                                           t_client_data(c_client_inn_id,
                                                         get_random_client_inn()),
                                           t_client_data(c_client_birthday_id,
                                                         get_random_client_bday()));
    end if;
  
    return client_api_pack.create_client(p_client_data => v_client_data);
  end;

  -- Получить данные по полю клиента
  function get_client_field_value(p_client_id client_data.client_id%type
                                 ,p_field_id  client_data.field_id%type)
    return client_data.field_value%type is
    v_field_value client_data.field_value%type;
  begin
    select max(cd.field_value)
      into v_field_value
      from client_data cd
     where cd.client_id = p_client_id
       and cd.field_id = p_field_id;
  
    return v_field_value;
  end;

  procedure ut_failed is
  begin
    raise_application_error(c_error_code_test_failed,
                            c_error_msg_test_failed);
  end;

  function get_client_info(p_client_id client_data.client_id%type)
    return client%rowtype is
    v_client client%rowtype;
  begin
    select * into v_client from client c where c.client_id = p_client_id;
    return v_client;
  end;

end;
/
