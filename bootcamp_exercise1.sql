show databases;
show tables from bootcamp_exercise1;
use bootcamp_exercise1;

# 1
select * 
from departments;
# 2
select * 
from employees;
# 3
select *
from job_history;
# 4
select * 
from jobs;
# 5 
select *
from locations;
# 6 
select * 
from regions;
# 7 
select *
from countries;

select *
from locations
where city = 'Tokyo';

delete from locations
where location_id = null;

select*
from locations;

update locations 
set country_id = 'JP'
where location_id = 1200;

select first_name, last_name, department_id
from employees;

select location_id
from locations
where country_id = 'JP';

select department_id
from departments
where location_id = (select location_id from locations where country_id = 'JP');



select first_name, last_name, job_id, department_id
from employees
where department_id = location_id
and location_id  = (select location_id from locations where country_id = 'JP');

# query 6
select employee_id, last_name, manager_id
from employees;

# query 7
select last_name, first_name
from employees
where hire_date < (select hire_date from employees where last_name = 'De Haan' and first_name = 'Lex');




















