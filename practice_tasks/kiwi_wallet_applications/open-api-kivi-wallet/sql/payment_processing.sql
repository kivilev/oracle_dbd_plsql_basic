-- Скрипт процессинга
declare

begin
  -- проходимся по всем активным платежам от активного не заблокированного клиента к другому
  for p in (select p.payment_id,
                   p.currency_id,
                   p.summa,
                   p.from_client_id,
                   p.to_client_id,
                   w1.wallet_id     wallet_from_id,
                   w2.wallet_id     wallet_to_id
              from payment p
              join client cl1
                on cl1.client_id = p.from_client_id
               and cl1.is_blocked = client_api_pack.c_not_blocked
               and cl1.is_active = client_api_pack.c_active
              join wallet w1
                on w1.client_id = cl1.client_id
               and w1.status_id = wallet_api_pack.c_wallet_status_active
              join client cl2
                on cl2.client_id = p.to_client_id
               and cl2.is_blocked = client_api_pack.c_not_blocked
               and cl2.is_active = client_api_pack.c_active
              join wallet w2
                on w2.client_id = cl2.client_id
               and w2.status_id = wallet_api_pack.c_wallet_status_active
             where p.status = payment_api_pack.c_created) loop
  
    begin
      -- тут могут быть различные проверки и вообще куча другой логики (лимиты, фрауд и т.п.) 
      dbms_output.put_line('Payment_id: '|| p.payment_id);
     
      -- блокируем оба баланса и переводим денежку
      account_api_pack.transfer_money(p_wallet_from_id => p.wallet_from_id,
                                      p_wallet_to_id   => p.wallet_to_id,
                                      p_currency_id    => p.currency_id,
                                      p_summa          => p.summa);

      -- переводим платеж в конечный успешный статус
      payment_api_pack.successful_finish_payment(p_payment_id => p.payment_id);
    exception
      when others then
        -- если возникала ошибка, фейлим платеж
        payment_api_pack.fail_payment(p_payment_id => p.payment_id,
                                      p_reason     => substr(sqlerrm ||
                                                             chr(10) ||
                                                             chr(13) ||
                                                             dbms_utility.format_error_stack,
                                                             1,
                                                             200));
    end;
  
    commit;
  
  end loop;

end;
/
