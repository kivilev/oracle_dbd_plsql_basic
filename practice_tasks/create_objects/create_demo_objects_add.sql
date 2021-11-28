/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)
  
  Описание скрипта: создание объектов, необходимых для выполнения ДОПОЛНИТЕЛЬНОЙ практической работы
*/

-- удаление сущностей, если выполняете первый раз, будут ошибки удаления
-- ничего страшного у вас пока этих объектов нет.
drop table account;
drop table wallet;
drop sequence wallet_seq;
drop sequence account_seq;


--------- Создание сущности "Кошелек" ----------------
create table wallet
(
  wallet_id                 number(30) not null,
  client_id                 number(30) not null,
  status_id                 number(2) default 0 not null,
  last_status_change_reason varchar2(200 char),
  create_dtime              timestamp(6) default systimestamp not null,
  update_dtime              timestamp(6) default systimestamp not null
);

-- add comments to the table 
comment on table wallet is 'Кошелек';
-- add comments to the columns 
comment on column wallet.wallet_id is 'Уникальный ID кошелька';
comment on column wallet.client_id is 'Уникальный ID клиента';
comment on column wallet.status_id is 'Статус кошелька. 0 - транзакции разрешены, 1 - транзакции заблокированы';
comment on column wallet.last_status_change_reason is 'Последняя причина изменения статуса';
comment on column wallet.create_dtime is 'Техническое поле. Дата создания записи';
comment on column wallet.update_dtime is 'Техническое поле. Дата обновления записи';

-- create/recreate primary, unique and foreign key constraints 
alter table wallet add constraint wallet_pk primary key (wallet_id);
alter table wallet add constraint wallet_client_unq unique (client_id);
alter table wallet add constraint wallet_client_fk foreign key (client_id) references client (client_id);
-- create/recreate check constraints 
alter table wallet add constraint wallet_status_id_chk check (status_id in (0, 1));
alter table wallet add constraint wallet_status_reason_chk check (status_id = 1 and last_status_change_reason is not null);


--------- Создание сущности "Счет" ----------------------
create table account
(
  account_id   number(38) not null,
  wallet_id    number(30) not null,
  currency_id  number(4) not null,
  balance      number(30,2) not null,
  create_dtime timestamp(6) default systimestamp not null,
  update_dtime timestamp(6) default systimestamp not null
);

-- add comments to the table 
comment on table account is 'Счет кошелька';
-- add comments to the columns 
comment on column account.account_id is 'Уникальный ID счета';
comment on column account.wallet_id is 'Уникальный ID кошелька';
comment on column account.currency_id is 'Валюта счета. 840 - USD, 643 - RUB, 978 - EUR'; -- Да, хорошо бы справочник, но ты уже прости въедливый студент :)
comment on column account.balance is 'Текущий баланс счета';
comment on column account.create_dtime is 'Техническое поле. Дата создания записи';
comment on column account.update_dtime is 'Техническое поле. Дата обновления записи';
-- create/recreate indexes 
create unique index account_wallet_currency_unq on account (wallet_id, currency_id);

-- create/recreate primary, unique and foreign key constraints 
alter table account add constraint account_pk primary key (account_id);
alter table account add constraint account_wallet_fk foreign key (wallet_id) references wallet (wallet_id);
-- create/recreate check constraints 
alter table account add constraint account_currency_id_fk foreign key (currency_id) references currency (currency_id);

--------- Последовательности ----------------------
create sequence wallet_seq;
create sequence account_seq;


