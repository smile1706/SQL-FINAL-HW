DROP SCHEMA mutallapov_da cascade;

CREATE SCHEMA mutallapov_da AUTHORIZATION postgres;

create sequence mutallapov_da.seq_readers_card_num --последоватеьность для поля номера чит.билета
as smallint
increment by 1
start 1
no cycle;

create sequence mutallapov_da.seq_employees_id --последовательность для номера учетки сотрудника
as smallint
increment by 1
start 1
no cycle;

create table mutallapov_da.readers (
	card_num smallint default nextval('mutallapov_da.seq_readers_card_num'),
	first_name varchar(20),
	last_name varchar(20),
	phone varchar(12)
);

create table mutallapov_da.books (
	barcode_num bigint,
	book_name varchar(100),
	book_author varchar(60),
	book_genre varchar(60)
);

create table mutallapov_da.employees (
	id smallint default nextval('mutallapov_da.seq_employees_id'),
	job_title varchar(15),
	first_name_employee varchar(20),
	last_name_employee varchar(20)
);

create table mutallapov_da.orders (
	card_num smallint default nextval('mutallapov_da.seq_readers_card_num'),
	barcode_num bigint,
	issue_date date,
	issuer_id smallint
);

alter table mutallapov_da.readers 
	add constraint pk_readers_card_num primary key (card_num),
	alter column first_name set not null,
	alter column last_name set not null,
	add constraint uq_readers_phone unique (phone),
	add constraint ck_readers_phone check (phone like '7%');

alter table mutallapov_da.books
	add constraint pk_books_barcode_num primary key (barcode_num),
	alter column book_name set not null,
	alter column book_author set not null,
	alter column book_genre set not null;

alter table mutallapov_da.employees 
	add constraint pk_employees_id primary key (id),
	alter column job_title set not null,
	alter column first_name_employee set not null,
	alter column last_name_employee set not null;

alter table mutallapov_da.orders 
	add constraint fk_orders_card_num foreign key (card_num)
		references mutallapov_da.readers (card_num) on delete restrict,
	add constraint fk_orders_barcode_num foreign key (barcode_num)
		references mutallapov_da.books (barcode_num) on delete restrict,
	alter column issue_date set not null,
	add constraint fk_orders_issuer_id foreign key (issuer_id)
		references mutallapov_da.employees (id) on delete restrict;

	
	
	

--select now()::date;

insert into mutallapov_da.readers (first_name, last_name, phone)
values ('Петров', 'Алексей', 79015551234), 
	('Иванова', 'Мария', 79267778899),
	('Смирнов', 'Денис', 74951110011),
	('Козлова', 'Ольга', 79603334455),
	('Фёдоров', 'Кирилл', 79152221133);

insert into mutallapov_da.books (barcode_num, book_name, book_author, book_genre)
values (9785389025, 'Морской Волк', 'Джек Лондон', 'Приключения'), 
	(9785171059, 'История Искусств', 'Эрнст Гомбрих', 'Искусствоведение'),
	(9785949755, 'Алгоритмы Python', 'Гэри Корнелл', 'Программирование'),
	(9785389146, 'Война и Мир. Том 1', 'Лев Толстой', 'Классика'),
	(9785040924, 'Философия', 'Бертран Рассел', 'Философия'),
	(9785970420, 'Геометрия. Справочник', 'Атанасян Л.С.', 'Научная литература');

insert into mutallapov_da.employees (job_title, first_name_employee, last_name_employee)
values ('Директор', 'Кузнецова', 'Ольга'), 
	('Библиотекарь', 'Смирнова', 'Елена'),
	('Ассистент', 'Попова', 'Наталья');

insert into mutallapov_da.orders (card_num, barcode_num, issue_date, issuer_id)
values (1, 9785389025, to_date('2025-09-15','YYYY-MM-DD'), 2), 
	(2, 9785171059, to_date('2025-10-01','YYYY-MM-DD'), 3),
	(3, 9785949755, to_date('2025-09-20','YYYY-MM-DD'), 2),
	(1, 9785389146, to_date('2025-10-05','YYYY-MM-DD'), 3),
	(4, 9785040924, to_date('2025-09-28','YYYY-MM-DD'), 1),
	(5, 9785970420, to_date('2025-10-10','YYYY-MM-DD'), 2);



select b.book_name, b.book_author, r.first_name, r.last_name
from mutallapov_da.books b 
inner join mutallapov_da.orders o
	on b.barcode_num = o.barcode_num
inner join mutallapov_da.readers r 
	on o.card_num = r.card_num 
order by b.book_name asc;

