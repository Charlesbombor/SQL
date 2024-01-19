-- create database org;
-- show databases;
-- use org;

-- create table worker
create table worker (
worker_id integer not null primary key auto_increment,
first_name char(25),
last_name char(25),
salary numeric(15),
joining_date datetime,
department char(25)
);

-- insert data to worker
insert into worker
(first_name, last_name, salary, joining_date, department) values
('Monika', 'Arrora', 100000, '21-02-20 09:00:00', 'HR'),
('Niharika', 'Verma', 80000, '21-06-11 09:00:00', 'Admin'),
('Vishal', 'Singhal', 300000, '21-02-20 09:00:00', 'HR'),
('Mohan', 'Sarah', 300000, '12-03-19 09:00:00', 'Admin'),
('Amitabh', 'Singh', 500000, '21-02-20 09:00:00', 'Admin'),
('Vivek', 'Bhati', 490000, '21-06-11 09:00:00', 'Admin'),
('Vipul', 'Diwan', 200000, '21-06-11 09:00:00', 'Account'),
('Satish', 'Kumar', 75000, '21-01-20 09:00:00', 'Account'),
('Geetika', 'Chauhan', 90000, '21-04-11 09:00:00', 'Admin');

select * 
from worker;

-- create table bonus
create table bonus (
worker_ref_id integer,
bonus_amount numeric(10),
bonus_date datetime,
foreign key (worker_ref_id) references worker(worker_id)
);

-- Task 1
insert into bonus (worker_ref_id, bonus_amount, bonus_date) values
(6, 32000, '21-11-02'),
(6, 20000, '22-11-02'),
(5, 21000, '21-11-02'),
(9, 30000, '21-11-02'),
(8, 4500, '22-11-02');

-- Task 2
with without_max_salary as (
	select salary
    from worker
    where salary < (select max(salary) from worker)
)
select max(salary) as second_max_salary
from without_max_salary;

-- Task 3
with hr_dept as (
	select concat(first_name, last_name) as hr_highest_salary_staff, salary
    from worker
    where department = 'HR'
),
acc_dept as (
	select concat(first_name, last_name) as acc_highest_salary_staff, salary
    from worker
    where department = 'Account'
),
admin_dept as (
	select concat(first_name, last_name) as admin_highest_salary_staff, salary
    from worker
    where department = 'Admin'
)
select *
from hr_dept hr, acc_dept acc, admin_dept ad
where hr.salary = (select max(salary) from hr_dept)
and acc.salary = (select max(salary) from acc_dept)
and ad.salary = (select max(salary) from admin_dept);

-- Task 4
with same_salary as (
SELECT salary, COUNT(*) as count
FROM worker
GROUP BY salary
HAVING count > 1
)
select first_name, last_name, w.salary
from worker w, same_salary ss
where w.salary = ss.salary;

-- Task 5
select w.first_name, w.last_name, w.salary, b.bonus_amount, b.bonus_date
from worker w, bonus b
where b.bonus_date > '20-12-31'
and b.bonus_date < '22-01-01'
and w.worker_id = b.worker_ref_id

-- Task 6

 















