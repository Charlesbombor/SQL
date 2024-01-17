create table book (
	id serial primary key, -- auto-incrementing integer
	author_id integer,
	book_name varchar(50) not null,
	constraint fk_book_author_id foreign key (author_id) references author(id)
);

insert into book (author_id, book_name) values (1, 'Fast');
insert into book (author_id, book_name) values (2, 'vantage');
select * from book;


create table author (
	id serial primary key, -- auto_incrementing integer
	author_name varchar(50) not null,
	nat_code varchar(2) not null,
	constraint fk__author_nat_code foreign key (nat_code) references nationality (nat_code)
);

insert into author (author_name, nat_code) values ('VanDesil', 'HK');
insert into author (author_name, nat_code) values ('The Rock', 'SG');
select * from author;

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

insert into users (user_name) values ('Donald Duck');
insert into users (user_name) values ('Micky Mouse');
select * from users;

create table user_contact (
	id serial primary key, -- auto-incrementing integer
	user_id integer unique,  -- unique + FK -> one to one
	user_phone varchar(100) not null,
	user_email varchar(100),
	constraint fk_user_contact foreign key (user_id) references users(id)
);

insert into user_contact (user_id, user_phone, user_email) values (1, '98765432', 'duck@gmail.com');
insert into user_contact (user_id, user_phone, user_email) values (2, '23456789', 'mouse@gmail.com');
select * from user_contact;

create table borrow_history (
	id serial primary key, -- auto-incrementing integer
	user_id integer not null,
	book_id integer not null,
	borrow_date timestamp not null,
	constraint fk_history_user_id foreign key (user_id) references users(id),
	constraint fk_history_book_id foreign key (book_id) references book(id)
);

insert into borrow_history (user_id, book_id, borrow_date) values (1, 2, current_timestamp);
insert into borrow_history (user_id, book_id, borrow_date) values (2, 1, current_timestamp);
insert into borrow_history (user_id, book_id, borrow_date) values (2, 1, '2022-01-15 17:20:00');
insert into borrow_history (user_id, book_id, borrow_date) values (2, 1, now() - interval '-1 day');

select * from borrow_history;

create table return_history (
	id serial primary key,
	borrow_id integer unique not null,
	return_date timestamp not null,
	constraint fk_return_book_id foreign key (borrow_id) references borrow_history(id)
);

insert into return_history (borrow_id, return_date) values (1, now() - interval '-7 day');
insert into return_history (borrow_id, return_date) values (2, now() - interval '-3 day');
insert into return_history (borrow_id, return_date) values (3, now() - interval '-6 day');
insert into return_history (borrow_id, return_date) values (4, now() - interval '-9 day');

delete from return_history;

select *
from return_history;


select bh.borrow_date
, u.user_name
, b.book_name
, a.author_name
, n.nat_code as author_nat_code
, n.nat_desc as author_nat_desc
from borrow_history bh, book b, users u, author a, nationality n
where bh.book_id = b.id
and bh.user_id = u.id
and b.author_id = a.id
and a.nat_code = n.nat_code
order by bh.borrow_date desc
;

select min(borrow_date) as first_borrow, book_name
from borrow_history bh, book b
group by borrow_date, book_name;

-- Find the user (user_name), who has the longest total book borrowing time. (no. of days, ignore timestamp)
select  user_name, sum(rh.return_date - bh.borrow_date) as total_borrow_date
from users, borrow_history bh, return_history rh
where rh.borrow_id = bh.id
and bh.user_id = user_id
group by user_name;

with borrow_days_per_user as (
	select bh.user_id, sum(extract(day from (rh.return_date - bh.borrow_date))) as borrow_days
	from borrow_history bh, return_history rh, users u
	where bh.id = rh.borrow_id
	and u.id = bh.user_id
	group by bh.user_id
)
select bd.user_id, u.user_name, bd.borrow_days
from borrow_days_per_user bd, users u
where borrow_days in (select max (borrow_days) from borrow_days_per_user)
and bd.user_id = u.id;

-- Find the user(s) who has not ever borrow a book
insert into users (user_name) values ('Peter Chan');

-- Approach 2: not exists
select * 
from users u
where not exists (select 1 from borrow_history bh where bh.book_id = u.id);

-- Approach 2: left join
select *
from users u left join boorow_history bh on bh.user_id = u.id
where bh.user_id is null;

--select * 
--from users u left join borrow_history bh
--on u.id = bh.user_id
--where bh.user_id is null;


-- Find the book(s), which has no borrow history
insert into book (author_id, book_name) values ('1', 'XYZ BOOK');

-- Approach 1: not exists
select *
from book b
where not exists (select 1 from borrow_history bh where bh.book_id = b.id)

-- Approach 2: left join
select book_name
from book b left join borrow_history bh
on b.id = bh.book_id
where bh.book_id is null;



-- Find all users and books, no matter the user or book has borrow history.
select u.user_name, b.book_name
from borrow_history bh
	full outer join users u on u.id = bh.user_id
	full outer join book b on b.id = bh.book_id
group by u.user_name, b.book_name


-- Result Set:
-- 'John' 'ABC Book'
-- 'Sunny' 'IJK Book'
-- 'Mary' null
-- null 'XYZ Book'

--with users_book_name as (
--	select u.user_name, b.book_name
--	from users u 
--	left join borrow_history bh on u.id = bh.user_id
--	left join book b on b.id = bh.book_id
--	group by u.user_name, b.book_name
--),
--book_users_name as (
--	select b.book_name, u.user_name
--	from book b
--	left join borrow_history bh on b.id = bh.book_id
--	left join users u on u.id = bh.user_id
--	group by b.book_name, u.user_name
--)
--select bun.book_name, ubn.user_name
--from book_users_name bun left join users_book_name ubn
--on bun.book_name = ubn.book_name
--or bun.user_name = ubn.user_name
-- group by bun.book_name, ubn.user_name

select u.user_name, b.book_name
from borrow_history bh
	full outer join users u on u.id = bh.user_id
	full outer join book b on b.id = bh.book_id
where u.id is null or b.id is null;

-- Procedures
create or replace function create_user (in user_name varchar) returns void as $$
begin
	insert into users values (user_name);
	-- you can do hunderds of code here...
end;
$$ language plpgsql;










































