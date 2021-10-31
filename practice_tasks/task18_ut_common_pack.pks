create or replace package ut_common_pack is

  -- Author  : D.KIVILEV  
  -- Purpose : Различные вспомогательные модули для организации тест-кейсов

  c_client_field_email_id  constant client_data_field.field_id%type := 1;
  c_client_mobile_phone_id constant client_data_field.field_id%type := 2;
  c_client_inn_id          constant client_data_field.field_id%type := 3;
  c_client_birthday_id     constant client_data_field.field_id%type := 4;

  c_non_existing_client_id constant client.client_id%type := -777;

  -- Сообщения об ошибках
  c_error_msg_test_failed constant varchar2(100 char) := 'Unit-тест или API выполнены не верно';

  -- Коды ошибок
  c_error_code_test_failed constant number(10) := -20999;

  -- Генерация значения полей для сущности клиент
  function get_random_client_email return client_data.field_value%type;
  function get_random_client_mobile_phone return client_data.field_value%type;
  function get_random_client_inn return client_data.field_value%type;
  function get_random_client_bday return client_data.field_value%type;

  -- Создание клиента
  function create_default_client(p_client_data t_client_data_array := null)
    return client.client_id%type;

  -- Получить информацию по сущности "Клиент"
  function get_client_info(p_client_id client_data.client_id%type)
    return client%rowtype;

  -- Получить данные по полю клиента
  function get_client_field_value(p_client_id client_data.client_id%type
                                 ,p_field_id  client_data.field_id%type)
    return client_data.field_value%type;

  -- возбуждение исключения о неверном тесте
  procedure ut_failed;

end;
/
