select 
from  
where 
group by 
having  
order by
limit

-- 1
select First_Name as Worker_Name
from Worker;

-- 2
select Upper(First_Name) 
from Worker;

-- 3
select distinct Department 
from Worker;

-- 4
select Department 
from Worker 
group by Department;

-- 5
select substring(first_name, 1, 3)
from Worker;

-- 6
select instr(first_name, "b")
from Worker
where first_name = "Amitabh";

-- 7
select rtrim(first_name) 
from Worker;

-- 8
select ltrim(department)
from Worker;

-- 9
select department, length(department)
from Worker
group by department;

-- 10
select replace(first_name,"a","A") 
from Worker;

-- 11
select concat(first_name," ",last_name) as Complete_Name
from Worker;

-- 12
select * 
from Worker
order by first_name asc;

-- 13
select * 
from Worker 
order by first_name asc, department desc;

-- 14
select * 
from Worker 
where (
    first_name = "Vipul" or 
    first_name = "Satish"
);

-- 15
select * 
from Worker
where first_name not in ("Vipul", "Satish"); 

-- 16
select *
from Worker 
where department like "Admin%";

-- 17
select * 
from Worker 
where (
    first_name like "%a%"
);

-- 18
select * 
from Worker 
where (
    first_name like "%a"
);

-- 19
select * 
from Worker 
where (
    first_name like "%h" 
    and  
    length(first_name)=6  
);

-- 20
select * 
from Worker 
where (
    salary between 100000 and 500000
);

-- 21
select * 
from Worker 
where (
    strftime("%m",Joining_Date)=="02"
    and 
    strftime("%y",Joining_Date)=="2014"
);

-- 22
select department, count(Worker_ID)
from Worker
where (
    department="Admin"
);

-- 23
select concat(first_name," ",last_name) as full_name 
from Worker 
where (
    salary >= 50000 
    and 
    salary <= 100000
);

-- 24
select department, count(Worker_ID) as number_of_workers 
from Worker
group by department
order by number_of_workers desc;

-- 25
select * 
from Worker as w 
inner join Title as t 
on w.Worker_ID = t.Worker_Ref_ID
where t.Worker_Title="Manager";

-- 26
select Worker_Title, count(Worker_Ref_ID) as number_of_workers
from Title
group by Worker_Title
having (
    number_of_workers > 1
);

-- 27
select * 
from Worker 
where (
    Worker_ID % 2 = 0
);

-- 28
select * 
from Worker 
where (
    Worker_ID % 2 =1
);

-- 29
create table worker_clone as 
select * 
from Worker;

-- 30
select * 
from worker 
intersect 
select * 
from worker_clone;

-- 31
select * 
from worker 
except
select *  
from worker 
intersect 
select * 
from worker_clone;

-- 32
select date("now");
select time("now");

-- 33
select * 
from worker 
order by salary desc
limit 5;

-- 34
select * 
from worker 
order by salary desc
limit 4,1;

-- 35
select salary  
from worker as w1 
where 4 = (
    select count(distinct salary) 
    from worker as w2 
    where w1.salary <= w2.salary
);
-- not understood

-- 36
select * 
from Worker
-- not understood

-- 37
select * from worker
union all 
select * from worker
order by Worker_ID;

--38 
select worker_ID
from worker 
where (
    Worker_ID not in (
        select Worker_Ref_ID 
        from Bonus
    )
);

select worker_ID
from worker as w
left join Bonus as b
on w.worker_ID = b.Worker_Ref_ID
where b.Worker_Ref_ID is null;

--39 
select * 
from Worker 
limit (select count(*)/2 from Worker);

--40 
select department 
from Worker 
group by department
having (
    count(worker_ID) < 4
);

--41
select department, count(worker_ID)
from worker
group by department;

--42 
select * 
from worker 
limit (
    select count(*)-1 from worker
),1;

--43
select * 
from worker 
limit 0,1;

--44
select * 
from worker 
where (
    worker_ID > (
        select count(worker_ID)-5 
        from worker
    )
);

(select * 
from worker 
order by worker_ID desc
limit 5)
order by worker_ID;

--45 
select department, (
    select concat(first_name," ",last_name)
    from worker
    order by salary desc
    limit 0,1
)
from worker 
group by department;

-- cannot understood the joins implementation

--46 
select distinct salary 
from worker 
order by salary desc
limit 3;

-- could not understand the corelated subquery 

--47 
select * 
from (
    select distinct salary 
    from worker 
    order by salary asc 
    limit 3
)
order by salary desc;

-- could not understand the corelated subquery

--48  
select distinct salary 
from worker 
order by salary desc
limit 4,1;

-- could not understand the corelated subquery

--49 
select department, sum(salary) as total_salary
from worker 
group by department
order by total_salary desc; 

--50 
select concat(first_name," ",last_name) as full_name, salary
from worker 
where (
    salary = (
        select max(salary)
        from worker
    )
);




