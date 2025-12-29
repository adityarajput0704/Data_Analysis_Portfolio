# 1. Find out the working location of each employee
select e.id, d.location from employees e 
join departments d on e.department_id=d.id;

# 2.Create Salary column & update the salaries for each department 
alter table departments add Salary int;
UPDATE departments SET Salary = 40000 WHERE D_name = 'HR';
UPDATE departments SET Salary = 30000 WHERE D_name = 'Finance';
UPDATE departments SET Salary = 55000 WHERE D_name = 'Engineering';
UPDATE departments SET Salary = 60000 WHERE D_name = 'Marketing';
UPDATE departments SET Salary = 75000 WHERE D_name = 'Sales';
UPDATE departments SET Salary = 100000 WHERE D_name = 'IT Support';
UPDATE departments SET Salary = 125000 WHERE D_name = 'Legal';
UPDATE departments SET Salary = 130000 WHERE D_name = 'Operations';
UPDATE departments SET Salary = 150000 WHERE D_name = 'Customer Service';

select * from departments ;

# 3.Find which project the employee is working on.
select e.id, p.P_name from employees e 
join projects p on e.department_id=p.department_id;

# 4.Find out the total hours worked on each project by each employee.
select e.id, t.hours from employees e 
join timesheets t on e.department_id=t.employee_id;

# 5.Find those employees who have not worked on any of the projects.
SELECT *
FROM employees
WHERE id NOT IN (
    SELECT employee_id
    FROM timesheets
);

-- 6. Find the maximum hours worked on which project.
SELECT project_id, hours
FROM timesheets
WHERE hours = (
    SELECT MAX(hours)
    FROM timesheets
);
-- 7. Create a view which stores employees' department names & their respective salaries.
create view dept_salary as
select e.id, d.D_name, d.Salary from employees e
join departments d on e.department_id=d.id;

select * from dept_salary;

-- 8. Create a view which stores the projects allocated to each employee
create view emp_projects as
select e.id, p.P_name from employees e
join projects p on e.department_id=p.department_id;

select * from emp_projects;

-- 9. Find the employees who have worked more than 20 hours on a single project.
SELECT project_id, SUM(hours) AS total_hours
FROM timesheets
GROUP BY project_id
having sum(hours)>20;

-- 10.Create a query that classifies employees based on their job titles as 'Manager','Developer', or 'Other'.
select id , first_name, last_name, job_title, 
case
when job_title like 'Manager' then 'Manager'
when job_title like 'Developer' then 'Developer'
Else 'other'
end as job_category
from employees;

select * from timesheets;
 -- 11.Retrieve a list of employees who worked on multiple projects.
select employee_id from timesheets
group by employee_id
having count(distinct project_id)>1;

-- 12.Retrieve each employee’s total hours worked on projects, and show the rank of each employee based on total hours worked.
 select employee_id , sum(hours) as total_hours,
 rank () over (order by sum(hours) desc) as rank_no
 from timesheets 
 group by employee_id;
 
 -- 13. List all employees whose total hours worked are above the overall average using subquery.
select e.* from employees e 
join timesheets t 
on e.id=t.employee_id
group by employee_id
having sum(hours)>( 
SELECT AVG(total_hours)
FROM (
    SELECT employee_id, SUM(hours) AS total_hours
    FROM timesheets
    GROUP BY employee_id
) t
);

select * from employees;
-- 14.Update the Employees table by changing the job_title of all employees working in the 'Engineering' department to 'Senior Developer', except for those who are 'Manager' or 'HR Specialist'. 
SET SQL_SAFE_UPDATES = 0;
UPDATE employees e
join departments d
on e.department_id=d.id
 SET e.job_title = 'Senior Developer' 
 WHERE d.D_name = 'Engineering'
	And e.job_title not in ('Manager','Hr Specialist');
 
 select * from employees;
 
-- 15. Find out which department has the highest average employee salary.
Select D_name , Salary from departments
where Salary= (select max(Salary)  from departments);
 
 
