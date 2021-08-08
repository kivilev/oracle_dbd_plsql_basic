/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  Дата: 26.04.2021

  Описание скрипта: unit-тесты на сущность "Данные Клиента"
*/

---- позитивные
declare
  v_client_id client.client_id%type;
  c_email_field_id        constant client_data_field.field_id%type := 1;
  c_mobile_phone_field_id constant client_data_field.field_id%type := 2;
  c_inn_field_id          constant client_data_field.field_id%type := 3;
  c_email_value           constant client_data.field_value%type := 'email@email';
  c_mobile_phone_value    constant client_data.field_value%type := '+79999999999';
  c_inn_value             constant client_data.field_value%type := '1234567890';

  v_current_email        client_data.field_value%type;
  v_current_mobile_phone client_data.field_value%type;
  v_current_inn          client_data.field_value%type;

  -- данные для вставки 
  v_client_data_for_new_client t_client_data_array := t_client_data_array(t_client_data(c_email_field_id,
                                                                                        c_email_value),
                                                                          t_client_data(c_mobile_phone_field_id,
                                                                                        c_mobile_phone_value));
  -- данные для обновления 
  v_client_data_for_update t_client_data_array := t_client_data_array(t_client_data(c_inn_field_id,
                                                                                    c_inn_value));
  -- данные для удаления 
  v_field_ids_for_delete t_number_array := t_number_array(c_inn_field_id,
                                                          c_email_field_id);

  -- получаем инфу по данным клиента
  procedure get_client_data(p_client_id     client.client_id%type
                           ,po_email        out client_data.field_value%type
                           ,po_mobile_phone out client_data.field_value%type
                           ,po_inn          out client_data.field_value%type) is
  begin
    select max(decode(cd.field_id, c_email_field_id, cd.field_value))
          ,max(decode(cd.field_id, c_mobile_phone_field_id, cd.field_value))
          ,max(decode(cd.field_id, c_inn_field_id, cd.field_value))
      into po_email
          ,po_mobile_phone
          ,po_inn
      from client_data cd
     where cd.client_id = p_client_id;
  end;

  procedure re is
  begin
    raise_application_error(-20999, 'API работает неверно');
  end;

begin
  -- проверяем создание
  v_client_id := client_api_pack.create_client(p_client_data => v_client_data_for_new_client);

  get_client_data(v_client_id,
                  v_current_email,
                  v_current_mobile_phone,
                  v_current_inn);
  if v_current_email <> c_email_value
     or v_current_mobile_phone <> c_mobile_phone_value then
    re();
  end if;

  -- проверяем обновление
  client_data_api_pack.insert_or_update_data(p_client_id   => v_client_id,
                                             p_client_data => v_client_data_for_update);

  get_client_data(v_client_id,
                  v_current_email,
                  v_current_mobile_phone,
                  v_current_inn);
  if v_current_email <> c_email_value
     or v_current_mobile_phone <> c_mobile_phone_value
     or v_current_inn <> c_inn_value then
    re();
  end if;

  -- проверяем удаление
  client_data_api_pack.delete_data(p_client_id => v_client_id,
                                   p_field_ids => v_field_ids_for_delete);

  get_client_data(v_client_id,
                  v_current_email,
                  v_current_mobile_phone,
                  v_current_inn);
  if v_current_email is not null
     or v_current_mobile_phone <> c_mobile_phone_value
     or v_current_inn is not null then
    re();
  end if;


  dbms_output.put_line('Все тесты прошли успешно');
  rollback;
end;
/

---- негативные
-- 1. запрещен прямой DML
