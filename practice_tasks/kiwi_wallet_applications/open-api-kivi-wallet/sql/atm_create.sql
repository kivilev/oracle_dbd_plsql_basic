----- C������� ������������ ������� - ��������\��� ����� ������� �� ����� ��������� �����

declare
  �_client_field_is_tech_client_id client_data_field.field_id%type := 8; -- �������� �� ������ �����������
  �_client_field_tech_name_id      client_data_field.field_id%type := 9; -- ������������ ��� �������
  �_client_field_tech_address_id   client_data_field.field_id%type := 10; -- ����� ����������

  v_client_id  client.client_id%type;
  v_wallet_id  wallet.wallet_id%type;
  v_account_id account.account_id%type;

  v_client_data t_client_data_array := t_client_data_array(t_client_data(�_client_field_is_tech_client_id,
                                                                         '1'),
                                                           t_client_data(�_client_field_tech_name_id,
                                                                         'Terminal_123456'),
                                                           t_client_data(�_client_field_tech_address_id,
                                                                         '�. ������, �������, ��. �������, 1 (���� � ����������)'));
begin
  -- �������� ��������
  v_client_id := client_api_pack.create_client(p_client_data => v_client_data);

  -- �������� ������� + �������� ���� � ����������� 1 ��� ������
  v_wallet_id  := wallet_api_pack.create_wallet(p_client_id => v_client_id);
  v_account_id := account_api_pack.create_account(p_client_id   => v_client_id,
                                                  p_wallet_id   => v_wallet_id,
                                                  p_currency_id => account_api_pack.c_currency_rub_id,
                                                  p_balance     => 1000000);

  dbms_output.put_line('Client id: ' || v_client_id || '. Wallet_id: ' ||
                       v_wallet_id || '. Account_id: ' || v_account_id);

  commit;
end;
/
