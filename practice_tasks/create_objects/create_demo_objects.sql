/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Описание скрипта: создание объектов, необходимых для выполнения практической работы    
*/

-- удаление сущностей, если выполняете первый раз, будут ошибки удаления, т.к. объектов еще нет
drop table client_data;
drop table client_data_field;
drop table client;

drop table payment_detail;
drop table payment_detail_field;
drop table payment;
drop table currency;

drop sequence client_seq;
drop sequence payment_seq;

-------- Создание сущности "Клиент"
create table client
(
  client_id           number(30) not null,
  is_active           number(1) default 1 not null,
  is_blocked          number(1) default 0 not null,
  blocked_reason      varchar2(1000 char),
  create_dtime_tech   timestamp(6) default systimestamp not null,
  update_dtime_tech   timestamp(6) default systimestamp not null
);

comment on table client is 'Клиент';
comment on column client.client_id is 'Уникальный ID клиента';
comment on column client.is_active is 'Активен ли клиент. 1 - да, 0 - нет.';
comment on column client.is_blocked is 'Заблокирован ли клиент. 1 - да, 0 - нет.';
comment on column client.blocked_reason is 'Причина блокировки';
comment on column client.create_dtime_tech is 'Техническое поле. Дата создания записи';
comment on column client.update_dtime_tech is 'Техническое поле. Дата обновления записи';

alter table client add constraint client_pk primary key (client_id);

alter table client add constraint client_active_chk check (is_active in (0, 1));
alter table client add constraint client_blocked_chk check (is_blocked in (0, 1));
alter table client add constraint client_block_reason_chk check ((is_blocked = 1 and blocked_reason is not null) or (is_blocked = 0));
alter table client add constraint client_tech_dates_chk check (create_dtime_tech <= update_dtime_tech);

-------- Создание сущности "Справочник полей данных клиента"
create table client_data_field
(
  field_id    number(10) not null,
  name        varchar2(100 char) not null,
  description varchar2(200 char) not null
);

comment on table client_data_field is 'Справочник полей данных клиента';
comment on column client_data_field.field_id is 'Уникальный ID поля';
comment on column client_data_field.name is 'Название - код';
comment on column client_data_field.description is 'Описание';

alter table client_data_field add constraint client_data_field_pk primary key (field_id);
alter table client_data_field add constraint client_data_field_name_chk check (name = upper(name));

-- поля
insert into client_data_field values (1, 'EMAIL', 'E-mail пользователя');
insert into client_data_field values (2, 'MOBILE_PHONE', 'Номер мобильного телефона');
insert into client_data_field values (3, 'INN', 'ИНН');
insert into client_data_field values (4, 'BIRTHDAY', 'Дата рождения');
commit;

-------- Создание сущности "Данные клиента"
create table client_data
(
  client_id   number(30) not null,
  field_id    number(10) not null,
  field_value varchar2(200 char) not null
);

comment on table client_data is 'Данные клиента';
comment on column client_data.client_id is 'ID клиента';
comment on column client_data.field_id is 'ID поля';
comment on column client_data.field_value is 'Значение поля (сами данные)';

alter table client_data add constraint client_data_pk primary key (client_id, field_id);
alter table client_data add constraint client_data_client_fk foreign key (client_id) references client (client_id);
alter table client_data add constraint client_data_field_fk foreign key (field_id) references client_data_field (field_id);

create index client_data_field_i on client_data(field_id);

---------------------------------------------------------------------------------------------------------------

-------- Создание справочника "Валюты"
create table currency
(
  currency_id number(3) not null,
  alfa3       char(3 char) not null,
  description varchar2(100 char) not null
);
comment on table currency is 'Справочник валют (ISO-4217)';
comment on column currency.currency_id is 'Трёхзначный цифровой (number-3) код валюты';
comment on column currency.alfa3 is 'Трёхбуквенный алфавитный (alfa-3) код валюты';
comment on column currency.description is 'Описание валюты';

alter table currency add constraint currency_pk primary key (currency_id);
alter table currency add constraint currency_alfa3_chk check (alfa3 = upper(alfa3));

insert into currency values(643, 'RUB', 'Российский рубль');
insert into currency values(840, 'USD', 'Доллар США');
insert into currency values(978 , 'EUR', 'Евро');
commit;

-------- Создание сущности "Платеж"
create table payment
(
  payment_id           number(38) not null,
  create_dtime         timestamp(6) not null,
  summa                number(30,2) not null,
  currency_id          number(3) not null,
  from_client_id       number(30) not null,
  to_client_id         number(30) not null,
  status               number(10) default 0 not null,
  status_change_reason varchar2(200 char),
  create_dtime_tech    timestamp(6) default systimestamp not null,
  update_dtime_tech    timestamp(6) default systimestamp not null
);
comment on table payment is 'Платеж';
comment on column payment.payment_id is 'Уникальный ID платежа';
comment on column payment.create_dtime is 'Дата создания платежа';
comment on column payment.summa is 'Сумма платежа';
comment on column payment.currency_id is 'В какой валюте производился платеж';
comment on column payment.from_client_id is 'Клиент-отправитель';
comment on column payment.to_client_id is 'Клиент-получатель';
comment on column payment.status is 'Статус платежа. 0 - создан, 1 - проведен, 2 - ошибка проведения, 3 - отмена платежа';
comment on column payment.status_change_reason is 'Причина изменения стуса платежа. Заполняется для статусов "2" и "3"';
comment on column payment.create_dtime_tech is 'Техническое поле. Дата создания записи';
comment on column payment.update_dtime_tech is 'Техническое поле. Дата обновления записи';

create index payment_from_client_i on payment (from_client_id);
create index payment_to_client_i on payment (to_client_id);

alter table payment add constraint payment_pk primary key (payment_id);
alter table payment add constraint payment_currency_id_fk foreign key (currency_id) references currency (currency_id);
alter table payment add constraint payment_from_client_id_fk foreign key (from_client_id) references client (client_id);
alter table payment add constraint payment_to_client_id_fk foreign key (to_client_id) references client (client_id);

alter table payment add constraint payment_reason_chk check ((status in (2,3) and status_change_reason is not null) or (status not in (2, 3)));
alter table payment add constraint payment_status_chk check (status in (0, 1, 2, 3));
alter table payment add constraint payment_tech_dates_chk check (create_dtime_tech <= update_dtime_tech);



-------- Создание сущности "Справочник полей данных платежа"
create table payment_detail_field
(
  field_id    number(10) not null,
  name        varchar2(100 char) not null,
  description varchar2(200 char) not null
);

comment on table payment_detail_field is 'Справочник полей данных платежа';
comment on column payment_detail_field.field_id is 'Уникальный ID поля';
comment on column payment_detail_field.name is 'Название - код';
comment on column payment_detail_field.description is 'Описание';

alter table payment_detail_field add constraint payment_detail_field_pk primary key (field_id);
alter table payment_detail_field add constraint payment_detail_field_name_chk check (name = upper(name));

-- поля
insert into payment_detail_field values (1, 'CLIENT_SOFTWARE', 'Софт, через который совершался платеж');
insert into payment_detail_field values (2, 'IP', 'IP адрес плательщика');
insert into payment_detail_field values (3, 'NOTE', 'Примечание к переводу');
insert into payment_detail_field values (4, 'IS_CHECKED_FRAUD', 'Проверен ли платеж в системе "АнтиФрод"');
commit;


-------- Создание сущности "Детали платежа"
create table payment_detail
(
  payment_id   number(38) not null,
  field_id     number(10) not null,
  field_value  varchar2(200 char) not null
);

comment on table payment_detail is 'Детали платежа';
comment on column payment_detail.payment_id is 'ID платежа';
comment on column payment_detail.field_id is 'ID поля';
comment on column payment_detail.field_value is 'Значение поля (сами данные)';

alter table payment_detail add constraint payment_detail_pk primary key (payment_id, field_id);
alter table payment_detail add constraint payment_detail_payment_fk foreign key (payment_id) references payment (payment_id);
alter table payment_detail add constraint payment_detail_field_fk foreign key (field_id) references payment_detail_field (field_id);

create index payment_detail_field_i on payment_detail(field_id);

--------- Последовательности ----------------------
create sequence client_seq;
create sequence payment_seq;
