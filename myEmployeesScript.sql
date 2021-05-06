USE employees;

SELECT dept_no FROM departments;
    
select * from departments;

select * from employees where first_name = 'Elvis';

select * from employees where first_name = 'Kellie' and gender = 'F';

select * from employees where first_name = 'Kellie' or first_name = 'Aruna';

select * from employees where gender = 'F' AND (first_name = 'Kellie' or first_name = 'Aruna');

select * from employees where first_name in ('Denis', 'Elvis');

select * from employees where first_name not in ('John', 'Mark', 'Jacob');

select * from employees where first_name like ('Mark%');

select * from employees where hire_date like ('%2000%');

select * from employees where emp_no like ('1000_');

select * from employees where first_name like ('%Jack%');

select * from employees where first_name not like ('%jack%');

select * from salaries where salary between 66000 and 70000; 

select * from employees where emp_no not between 10004 and 100012;

select dept_name from departments where dept_no between 'd003' and 'd006';

select dept_name from departments where dept_no is not null;

select * from employees where first_name = 'Mark';

select * from employees where gender = 'F' and hire_date > '2000-01-01';

select salary from salaries where 1 > 150000;

select distinct hire_date from employees;

select count(emp_no) from salaries where salary >= 100000;

select count(*) from dept_manager;

select * from employees order by hire_date DESC;

select salary, count(*) as 'emps_with_same_salary' from salaries where salary > 80000 group by salary order by salary;

select emp_no, AVG(salary) from salaries group by emp_no having avg(salary) > 120000;

select * from dept_emp;

select emp_no as 'num_emps' from dept_emp where from_date > '2000-01-01' group by emp_no having count(from_date) > 1 order by emp_no;

select * from dept_emp limit 100;

select * from titles limit 10;

use employees;

INSERT INTO employees

VALUES

(

    999901,

    '1977-09-14',

    'Mary',

    'Creek',

    'F',

    '1999-01-01'

);

insert into titles ( emp_no, title, from_date, to_date) values ( 999903, 'Senior Engineer', '1997-10-01', '9999-01-01' );

select * from titles order by emp_no desc limit 10;

select * from dept_emp limit 10;

insert into dept_emp values (999903, 'd005', '1997-10-01', '9999-01-01');

create table departments_dup ( dept_no char(4) not null, dept_name varchar(40) not null );

insert into departments_dup (dept_no, dept_name) select * from departments;

select * from departments limit 10;

insert into departments values ('d010', 'Buisness Anaylsis');

update employees set first_name = 'Stella', last_name = 'Parkinson', birth_date = '1990-12-01', gender = 'F' where emp_no = '999901';

update departments set dept_name = "Data Analysis" where dept_name = "Buisness Analysis";

commit;

delete from employees where emp_no = '999903';

select * from titles where emp_no = '999903';

rollback;

delete from departments where dept_no = 'd010';

select count(distinct dept_no) from dept_emp;

select sum(salary) from salaries where from_date > '1997-01-01';

select MAX(emp_no) from employees;

select round(avg(salary), 2) from salaries where from_date > '1997-01-01';

alter table departments_dup change column dept_name dept_name varchar(40) null;

insert into departments_dup(dept_no) values ('d010'), ('d011');

alter table employees.departments_dup add column dept_manager varchar(255) null after dept_name;
commit;

SELECT 
    IFNULL(dept_no, 'N/A') AS dept_no,
    IFNULL(dept_name,
            'department name not provided') AS dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    departments_dup
ORDER BY dept_no; 

use employees;

select * from departments_dup limit 10;

alter table departments_dup drop column dept_manager;

alter table departments_dup change column dept_no dept_no char(4) null;

alter table departments_dup change column dept_name dept_name varchar(40) null;

DROP TABLE IF EXISTS dept_manager_dup;

CREATE TABLE dept_manager_dup (

  emp_no int(11) NOT NULL,

  dept_no char(4) NULL,

  from_date date NOT NULL,

  to_date date NULL

  );

 

INSERT INTO dept_manager_dup

select * from dept_manager;

 

INSERT INTO dept_manager_dup (emp_no, from_date)

VALUES                (999904, '2017-01-01'),

                                (999905, '2017-01-01'),

                               (999906, '2017-01-01'),

                               (999907, '2017-01-01');

 

DELETE FROM dept_manager_dup

WHERE

    dept_no = 'd001';

INSERT INTO departments_dup (dept_name)

VALUES                ('Public Relations');

 

DELETE FROM departments_dup

WHERE

    dept_no = 'd002'; 
    
select e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
from employees e
join dept_manager dm on e.emp_no = dm.emp_no;

select e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date
from employees e
left join dept_manager dm on e.emp_no = dm.emp_no
where e.last_name = 'Markovitch'
order by dm.dept_no desc, e.emp_no;

select e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
from employees e, dept_manager dm 
where e.emp_no = dm.emp_no;

set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');

select @@global.sql_mode;

#'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'

select e.emp_no, e.first_name, e.last_name, e.hire_date, t.title
from employees e	
join titles t on e.emp_no = t.emp_no
where e.last_name = 'Markovitch' and e.first_name = 'Margareta'
order by e.emp_no;

select dm.*, d.*
from departments d
cross join dept_manager dm
where d.dept_no = 'd009'
order by d.dept_no;

select e.*, d.*
from employees e
cross join departments d
where e.emp_no<10011
order by e.emp_no, d.dept_name;

select e.emp_no, e.first_name, e.last_name, e.hire_date, t.title, dm.from_date, d.dept_no, d.dept_name
from employees e
join dept_manager dm on e.emp_no = dm.emp_no
join departments d on dm.dept_no = d.dept_no
join titles t on e.emp_no = t.emp_no and dm.from_date = t.from_date
order by e.emp_no;

select e.gender, count(dm.emp_no)
from employees e
join dept_manager dm on e.emp_no = dm.emp_no
group by e.gender;

drop table if exists employees_dup;
create table employees_dup 
(
emp_no int,
birth_date date,
first_name varchar(14),
last_name varchar(16),
gender enum('M', 'F'),
hire_date date
);

insert into employees_dup
select
e.*
from
employees e
limit 20;

select * from employees_dup;

select * from dept_manager where emp_no in (select emp_no from employees where hire_date between '1990-01-01' and '1995-01-01');

select * from employees e where exists(select emp_no from titles t where t.emp_no = e. emp_no and title = "Assistant Engineer");

SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = '110022') AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = '110039') AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B;
    
drop table if exists emp_manager;

create table emp_manager(
emp_no int not null,
dept_no char(4) null,
manager_no int not null);

use employees;

SELECT 
    U.*
FROM
    (SELECT 
        A.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = '110022') AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A UNION SELECT 
        B.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = '110039') AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B UNION SELECT 
        C.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = '110039') AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS C UNION SELECT 
        D.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = '110022') AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS D) AS U;
    
create or replace view v_average_manager_salary as
select dm.emp_no, round(avg(s.salary), 2)
from dept_manager dm
join salaries s on dm.emp_no = s.emp_no;

SELECT 
    *
FROM
    v_average_manager_salary;

use employees;

