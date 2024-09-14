----- Cоздание технического клиента - терминал\АТМ через который мы будем зачислять бабло

declare
  с_client_field_is_tech_client_id client_data_field.field_id%type := 8; -- Является ли клиент техническим
  с_client_field_tech_name_id      client_data_field.field_id%type := 9; -- Наименование тех клиента
  с_client_field_tech_address_id   client_data_field.field_id%type := 10; -- Адрес нахождения

  v_client_id  client.client_id%type;
  v_wallet_id  wallet.wallet_id%type;
  v_account_id account.account_id%type;

  v_client_data t_client_data_array := t_client_data_array(t_client_data(с_client_field_is_tech_client_id,
                                                                         '1'),
                                                           t_client_data(с_client_field_tech_name_id,
                                                                         'Terminal_123456'),
                                                           t_client_data(с_client_field_tech_address_id,
                                                                         'г. Москва, Борвиха, ул. Богатая, 1 (вход в Шестерочку)'));
begin
  -- создадим терминал
  v_client_id := client_api_pack.create_client(p_client_data => v_client_data);

  -- создадим кошелек + рублевый счет с техническим 1 млн рублей
  v_wallet_id  := wallet_api_pack.create_wallet(p_client_id => v_client_id);
  v_account_id := account_api_pack.create_account(p_client_id   => v_client_id,
                                                  p_wallet_id   => v_wallet_id,
                                                  p_currency_id => account_api_pack.c_currency_rub_code,
                                                  p_balance     => 1000000);

  dbms_output.put_line('Client id: ' || v_client_id || '. Wallet_id: ' ||
                       v_wallet_id || '. Account_id: ' || v_account_id);

  commit;
end;
/
