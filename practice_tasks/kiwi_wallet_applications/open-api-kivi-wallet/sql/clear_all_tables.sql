-- Чистка всех таблиц
call common_pack.enable_manual_changes(); 

delete from account;
delete from wallet;
delete from client_data;
delete from payment_detail;
delete from payment;
delete from client;
commit;
