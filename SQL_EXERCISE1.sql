create DATABASE BOOTCAMP_EXCERCISE1;

use BOOTCAMP_EXCERCISE1;

create table regions(
	region_id int auto_increment,
    region_name varchar(25),
    constraint pk_regions primary key (region_id)
    );
    
insert into regions(region_id, region_name) values
(1, 'North America'),
(2, 'Europe'),
(3, 'Asia');
select * from regions;
    
create table countries(
	country_id int auto_increment,
    country_name varchar(40),
    region_id integer not null, -- reference
    primary key (country_id),
    foreign key (region_id) references regions(region_id) -- foreign key
    );
    
insert into countries (country_id, country_name, region_id) values
(1, 'United States', 1),
(2, 'United Kingdom', 2),
(3, 'Japan', 3);
select * from countries;

create table locations(
	location_id int auto_increment,
    street_address varchar(25),
    potal_code varchar(12),
    city varchar(30),
    state_province varchar(12),
    country_id int not null, -- reference
    primary key (location_id),
    foreign key (country_id) references countries(country_id) -- foreign key
    );

insert into locations (location_id, street_address, potal_code, city, state_province, country_id) values
(1001, '123 Main St', '12345', 'New York', 'NY', 1),
(1002, '456 Elm St', '67890', 'London', NULL, 2),
(1003, '789 Oak St', '98765', 'Tokyo', NULL, 3);
select * from locations;

create table departments(
	department_id int auto_increment,
    department_name varchar(20),
    manager_id integer not null,
    location_id integer not null, -- reference
    primary key (department_id),
    foreign key (location_id) references locations(location_id) -- foreign key
    );
    
insert into departments (department_id, department_name, manager_id, location_id) values
(10, 'Sales', 101, 1001),
(20, 'HR', 102, 1002),
(30, 'IT', 103, 1003);
select * from departments;

create table jobs(
	job_id varchar(10),
    job_title varchar(35),
    min_salary numeric (10,2), -- 小數點前131072 位；小數點後16383 位
    max_salary numeric (10,2), -- 小數點前131072 位；小數點後16383 位
    primary key (job_id)
    );
    
insert into jobs (job_id, job_title, min_salary, max_salary) values
('SALESMAN', 'Salesman', 30000, 60000),
('HR_REP', 'HR Representative', 35000, 70000),
('IT_PROG', 'IT Programmer', 40000, 80000);
select * from jobs;

create table employees(
	employee_id int auto_increment,
    first_name varchar(20),
    last_name varchar(25),
    email varchar(25),
    phone_number varchar(20),
    hire_date date,
    job_id varchar(10),
    salary numeric(7, 2),
    commission_pct numeric(10, 2),
    manager_id int not null,
    department_id int not null,
    primary key (employee_id),
    foreign key (job_id)references jobs(job_id),
    foreign key (department_id)references departments(department_id)
    );

insert into employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) values
(101, 'John', 'Doe', 'john@gmail.com', '123-456-70', '2023-01-15', 'SALESMAN',50000, 0.05, 103, 10),
(102, 'Jane', 'Smith', 'john@gmail.com', '987-654-32', '2023-02-20', 'HR_REP',55000, 0.07, 103, 20),
(103, 'Michael', 'Johnson', 'john@gmail.com', '555-123-45', '2023-03-25', 'IT_PROG',60000, 0.06, 103, 30);
select * from employees;

update employees 
set email = 'john@gmail.com'
where employee_id = 101;
update employees 
set email = 'michael@gmail.com'
where employee_id = 103;

create table job_history(
	employee_id int not null, -- reference
	start_date date ,
    end_date date,
    job_id varchar(10),
    department_id int not null, -- reference
    primary key (start_date, employee_id),
    foreign key (job_id) references jobs(job_id),
    foreign key (employee_id)references employees(employee_id), -- foreign key
    foreign key (department_id)references departments(department_id) -- foreign key
    );
insert into job_history (start_date, end_date, job_id, department_id, employee_id) values
('2023-01-15', '2023-05-15', 'SALESMAN', 10, 101),
('2023-02-20', '2023-06-20', 'HR_REP', 20, 102),
('2023-03-25', NULL, 'IT_PROG', 30, 103);
select * from job_history;

-- 3. 
select location_id, street_address, city, state_province, country_name
from locations l, countries c
where l.country_id = c.country_id;

-- 4.
select first_name, last_name, department_id
from employees;

-- 5.
SELECT e.first_name, e.last_name, e.job_id, e.department_id
FROM employees e, departments d, locations l, countries c
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND l.country_id = c.country_id
  AND c.country_name = 'Japan';

-- 6.
select e.employee_id, e.last_name, m.manager_id, m.last_name as manager_last_name
from employees e
left join employees m on e.manager_id = m.employee_id;

-- 7.
insert into employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) values
(104, 'De Haan', 'Lex', 'lexdehaan@gmail.com', '234-523-00', '2023-04-30', 'IT_PROG',60000, 0.06, 103, 30),
(105, 'Shing', 'Ng', 'shingng@gmail.com', '345-406-74', '2023-06-12', 'SALESMAN',50000, 0.05, 101, 10);

select e.first_name, e.last_name, e.hire_date
from employees e, employees d
where e.hire_date > d.hire_date
and d.last_name = 'Lex';

-- 8.
select d.department_name, count(e.employee_id) as EMPLOYEES
from departments d
left join employees e on d.department_id = e.department_id
group by d.department_name;

-- 9.
select employee_id, job_id,
datediff(end_date, start_date) as days_between_dates
from job_history
where department_id = 30;

-- 10.
SELECT D.DEPARTMENT_NAME, E.FIRST_NAME AS MANAGER_FIRST_NAME,
 E.LAST_NAME AS MANAGER_LAST_NAME, L.CITY, C.COUNTRY_NAME
FROM DEPARTMENTS D
JOIN EMPLOYEES E ON D.MANAGER_ID = E.EMPLOYEE_ID
JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
JOIN COUNTRIES C ON L.COUNTRY_ID = C.COUNTRY_ID;

-- 11.
SELECT D.DEPARTMENT_NAME, AVG(E.SALARY) AS AVG_SALARY
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME;

-- 12.
CREATE TABLE JOB_GRADES(
 GRADE_LEVEL VARCHAR(4) ,
 LOWEST_SAL NUMERIC (10,2),
 HIGHEST_SAL NUMERIC (10,2),
 CONSTRAINT PK_JOB_GRADES PRIMARY KEY (GRADE_LEVEL)
);

ALTER TABLE JOBS
DROP COLUMN MIN_SALARY,
DROP COLUMN MAX_SALARY,
ADD COLUMN GRADE_LEVEL  VARCHAR(4),
ADD CONSTRAINT FK_JOBS_JOB_GRADES FOREIGN KEY (GRADE_LEVEL) REFERENCES JOB_GRADES(GRADE_LEVEL);





    