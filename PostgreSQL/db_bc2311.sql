create table book (
	id serial primary key, -- auto-incrementing integer
	author_id integer,
	book_name varchar(50) not null,
	constraint fk_book_author_id foreign key (author_id) references author(id)
);

create table author (
	id serial primary key, -- auto_incrementing integer
	author_name varchar(50) not null,
	nat_code varchar(2) not null,
	constraint fk__author_nat_code foreign key (nat_code) references nationality (nat_code)
);

create table nationality (
	id serial primary key, -- auto_incrementing integer
	nat_code varchar(2) unique,
	nat_desc varchar(50) not null
);

insert into nationality (nat_code, nat_desc) values ('HK', 'HONG KONG');
insert into nationality (nat_code, nat_desc) values ('SG', 'SINGAPORE');
select * from nationality;

create table users (
	id serial primary key, -- auto-incrementing integer
	user_name varchar(50) not null
);

create table user_contact (
	id serial primary key, -- auto-incrementing integer
	user_id integer unique,  -- unique + FK -> one to one
	user_phone varchar(100) not null,
	user_email varchar(100),
	constraint fk_user_contact foreign key (user_id) references users(id)
);

create table borrow_history (
	id serial primary key, -- auto-incrementing integer
	user_id integer not null,
	book_id integer not null,
	borrow_date timestamp not null,
	constraint fk_history_user_id foreign key (user_id) references users(id),
	constraint fk_history_book_id foreign key (book_id) references book(id)
);




