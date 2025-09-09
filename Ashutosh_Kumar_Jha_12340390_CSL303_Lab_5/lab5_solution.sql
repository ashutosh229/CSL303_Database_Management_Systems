-- Part 1: Subqueries and Advanced WHERE clauses

-- 1. Find the names of all employees who work in the ’Marketing’ department.
select e.emp_name
from Employees as e
join Departments as d on e.dept_id = d.dept_id
where d.dept_name = 'Marketing';

-- 2. Find the names and salaries of employees who earn more than the company’s average salary.
select emp_name, salary
from Employees
where salary > (
    select AVG(salary) 
    from Employees
);

-- 3. Find the names of all employees who are assigned to ’Project Phoenix’.
select e.emp_name
from Employees as e
join Assignments as a on e.emp_id = a.emp_id
join Projects as p on a.proj_id = p.proj_id
where p.proj_name = 'Project Phoenix';

-- 4. Find the names of all employees who are not assigned to any project.
select e.emp_name
from Employees as e
left join Assignments as a on e.emp_id = a.emp_id
where a.proj_id IS NULL;

-- 5. Find the names of employees who earn more than any employee in the ’Marketing’ department.
select e.emp_name
from Employees as e
where e.salary > (
    select MAX(e2.salary)
    from Employees as e2
    join Departments as d on e2.dept_id = d.dept_id
    where d.dept_name = 'Marketing'
);

-- 6. Find the names of employees who earn more than all employees in the ’Marketing’ department.
select e.emp_name
from Employees as e
where e.salary > (
    select e2.salary
    from Employees as e2
    join Departments as d on e2.dept_id = d.dept_id
    where d.dept_name = 'Marketing'
);

-- Part 2: Date Functions, NULLs, and Pattern Matching

-- 1. Find the names and hire dates of all employees hired in 2023.
select emp_name, hire_date
from Employees
where strftime('%Y', hire_date) = '2023';

-- 2. Find the names of all employees who do not have a manager.
select emp_name
from Employees
where manager_id IS NULL;

-- 3. Find the names of all employees whose last name is ’Smith’ or ’Williams’.
select emp_name
from Employees
where (
    emp_name like '% Smith'
    or
    emp_name like '% Williams'
);

-- 4. Find all employees who were hired in the last 2 years from today’s date.
select emp_name, hire_date
from Employees
where (
    hire_date >= DATE('now', '-2 years')
);

-- Part 3: Correlated Subqueries and Set Operations

-- 1. For each department, find the employee with the highest salary. List the department name, em-
-- ployee name, and salary.
select d.dept_name, e.emp_name, e.salary
from Employees as e
join Departments as d on e.dept_id = d.dept_id
where e.salary = (
    select MAX(e2.salary)
    from Employees as e2
    where e2.dept_id = e.dept_id
);

-- 2. Find the names of all employees who work in the ’Engineering’ department but are not assigned
-- to ’Project Neptune’.
select e.emp_name
from Employees as e
join Departments as d on e.dept_id = d.dept_id
where (
    d.dept_name = 'Engineering'
    and  
    e.emp_id not in (
      select a.emp_id
      from Assignments as a
      join Projects as p on a.proj_id = p.proj_id
      where p.proj_name = 'Project Neptune'
    )
);

-- 3. (Challenge) Find the departments where the average salary is greater than the overall average
-- salary of the entire company.
select d.dept_name, AVG(e.salary) as avg_dept_salary
from Employees as e
join Departments as d on e.dept_id = d.dept_id
group by d.dept_id, d.dept_name
having (
    AVG(e.salary) > (
        select AVG(salary) 
        from Employees
    )
);

-- Part 4: DDL and DML

-- 1. Add a new column named email of type TEXT to the Employees table.
alter table Employees
add column email TEXT;

-- 2. Update the email for all employees in the ’Engineering’ department. Set the email to be their  
-- name (lowercase, spaces removed) followed by engineering.com. For example, ’Alice Johnson’
-- becomes ’alicejohnsonengineering.com’. (Hint: Use the LOWER and REPLACE string functions).
update Employees
set email = LOWER(REPLACE(emp_name, ' ', '')) || '@engineering.com'
where dept_id = (
    select dept_id
    from Departments
    where dept_name = 'Engineering'
);

-- 3. Create a new table called HighEarners with columns emp id and emp name. Insert into this table
-- all employees who earn more than $95,000.
create table HighEarners (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL
);
insert into HighEarners (emp_id, emp_name)
select emp_id, emp_name
from Employees
where salary > 95000;


