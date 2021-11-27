----- Зачисляем бабло через терминал.
declare

  c_payment_detail_field_client_software_id  payment_detail_field.field_id%type := 1;
  c_payment_detail_field_ip_id               payment_detail_field.field_id%type := 2;
  c_payment_detail_field_note_id             payment_detail_field.field_id%type := 3;
  c_payment_detail_field_is_checked_fraud_id payment_detail_field.field_id%type := 4;

  v_payment_id payment.payment_id%type;

  v_payment_details t_payment_detail_array := t_payment_detail_array(t_payment_detail(c_payment_detail_field_client_software_id,
                                                                                      'internal terminal'),
                                                                     t_payment_detail(c_payment_detail_field_ip_id,
                                                                                      '199.2.3.222'),
                                                                     t_payment_detail(c_payment_detail_field_note_id,
                                                                                      'пополнение через терминал'),
                                                                     t_payment_detail(c_payment_detail_field_is_checked_fraud_id,
                                                                                      '1'));
begin
  v_payment_id := payment_api_pack.create_payment(p_from_client_id => 344, -- id терминала
                                                  p_to_client_id   => 345, -- id Яковлева
                                                  p_currency_id    => account_api_pack.c_currency_rub_id, -- rub 
                                                  p_create_dtime   => systimestamp, -- дата платежа
                                                  p_summa          => 1000, -- пополняем 1000 рублями
                                                  p_payment_detail => v_payment_details);

  dbms_output.put_line('Платеж на пополнение счета. Payment_id: ' ||
                       v_payment_id);

  commit;
end;
/
