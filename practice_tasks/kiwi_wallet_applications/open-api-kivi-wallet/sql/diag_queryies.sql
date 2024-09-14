---- Запросы по табличкам

--- клиент
select get_client_name(cl.client_id) client_name, cl.* from client cl 
 where cl.client_id = &client_id;
-- данные по клиенту
select cl.client_id, cl.field_id, cl.field_value, f.name, f.description
  from client_data cl
  join client_data_field f on cl.field_id = f.field_id
 where cl.client_id = &client_id
 order by cl.field_id;
-- кошелек
select * from wallet w where w.client_id = &client_id;
-- счета
select * from account w where w.client_id = &client_id;

--- платежи
select * from payment p where p.payment_id = &payment_id;
select pd.*, f.name, f.description
  from payment_detail pd
  join payment p on p.payment_id = pd.payment_id
  join payment_detail_field f on f.field_id = pd.field_id
 where p.payment_id = &payment_id
 order by pd.field_id;

-- Платежи клеинтов
select p.payment_id,
       p.create_dtime,
       p.summa,
       p.currency_id,
       get_client_name(from_client_id) from_client,
       get_client_name(p.to_client_id) to_client,
       p.status,
       p.status_change_reason,
       p.create_dtime_tech,
       p.update_dtime_tech
  from payment p
 order by p.payment_id desc;

-- Балансы клиентов
select a.*, get_client_name(a.client_id) client_name
  from account a
 order by a.account_id;
  
 


/*
create or replace function get_client_name(p_client_id client.client_id%type) return varchar2
is
  v_result varchar2(1000 char);
  c_last_name_field_id constant client_data.field_id%type := 5;
  c_first_name_field_id constant client_data.field_id%type := 6;
  c_sure_name_field_id constant client_data.field_id%type := 7;
  c_is_tech_name_field_id constant client_data.field_id%type := 9;
begin
  select trim(ln.field_value || ' '||fn.field_value||' '||sn.field_value || techn.field_value)
    into v_result
    from client cl
    left join client_data ln on cl.client_id = ln.client_id  and ln.field_id = c_last_name_field_id
    left join client_data fn on cl.client_id = fn.client_id and fn.field_id = c_first_name_field_id
    left join client_data sn on cl.client_id = sn.client_id and sn.field_id = c_sure_name_field_id
    left join client_data techn on cl.client_id = techn.client_id and techn.field_id = c_is_tech_name_field_id
   where cl.client_id = p_client_id;
  
  return v_result;
end;
/

*/
