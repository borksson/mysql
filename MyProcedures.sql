USE employees;

drop procedure if exists select_employees;

delimiter $$

create procedure select_employees()
begin 
select * from employees limit 1000;
end$$

select * from employees$$

delimiter ;

select * from employees;

call employees.select_employees();

use employees;

drop procedure if exists avg_salary;

delimiter $$

create procedure avg_salary()
begin
select avg(salary) from salaries;
end $$

delimiter ;

call avg_salary();

select * from employees limit 1;

set @v_emp_no = 0;
call emp_info('Aruna', 'Journel', @v_emp_no);
select @v_emp_no;

drop function if exists emp_info;

delimiter $$
create function emp_info (p_first_name varchar(14), p_last_name varchar(16)) returns decimal(10,2)
deterministic
begin
declare v_contract_salary decimal(10,2);
declare v_max_from_date date;

select MAX(s.from_date)
into v_max_from_date
from employees e
join salaries s on e.emp_no = s.emp_no
where e.first_name = p_first_name and e.last_name = p_last_name
limit 1;

select salary
into v_contract_salary
from salaries
where from_date = v_max_from_date
limit 1;

return v_contract_salary;
end$$
delimiter ;

select emp_info('Aruna', 'Journel');

#session var syntax
set @session_var = 0;

use employees;

commit;

drop trigger if exists check_hire_date;

delimiter $$

create trigger check_hire_date
before insert on employees
for each row
begin
	if NEW.hire_date > date_format(sysdate(), '%Y-%m-%d') then
		set NEW.hire_date = date_format(sysdate(), '%Y-%m-%d');	
	end if;
end$$

delimiter ;

DELIMITER $$

CREATE TRIGGER trig_hire_date  

BEFORE INSERT ON employees

FOR EACH ROW  

BEGIN  

                IF NEW.hire_date > date_format(sysdate(), '%Y-%m-%d') THEN     

                                SET NEW.hire_date = date_format(sysdate(), '%Y-%m-%d');     

                END IF;  

END $$  

DELIMITER ; 

select *
from salaries
where salary > 89000
order by emp_no;

create index i_salaries on salaries(salary);

select
	e.emp_no,
    e.first_name,
    e.last_name,
    case
		when dm.emp_no is not null then 'Manager'
		else 'Employee'
    end as is_manager
	from employees e
		left join dept_manager dm on e.emp_no = dm.emp_no
	where e.emp_no > 109990
order by e.emp_no;

select
	dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) as salary_diff,
    case
		when MAX(s.salary) - MIN(s.salary) > 30000 then 'Yes'
        else 'No'
	end as greater_than_30000
from dept_manager dm
join employees e on dm.emp_no = e.emp_no
join salaries s on dm.emp_no = s.emp_no
group by dm.emp_no
order by dm.emp_no;

SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    IF(MAX(de.to_date) = '9999-01-01',
        'Is still employed',
        'Not an employee anymore') AS current_employee
FROM
    employees AS e
        JOIN
    dept_emp de ON e.emp_no = de.emp_no
GROUP BY e.emp_no
ORDER BY e.emp_no
LIMIT 100;