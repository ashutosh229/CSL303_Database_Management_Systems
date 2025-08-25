select 
from  
where 
group by 
having  
order by

select First_Name as Worker_Name
from Worker;

select Upper(First_Name) 
from Worker;

select distinct Department 
from Worker;

select Department 
from Worker 
group by Department;

select substring(first_name, 1, 3)
from Worker;

select instr(first_name, "b")
from Worker
where first_name = "Amitabh";

select rtrim(first_name) 
from Worker;

select ltrim(department)
from Worker;

select department, length(department)
from Worker
group by department;

select replace(first_name,"a","A") 
from Worker;

select concat(first_name," ",last_name) as Complete_Name
from Worker;

select * 
from Worker
order by first_name asc;

select * 
from Worker 
order by first_name asc, department desc;

select * 
from Worker 
where (
    first_name = "Vipul" or 
    first_name = "Satish"
);

select * 
from Worker
where first_name not in ("Vipul", "Satish"); 

select *
from Worker 
where department like "Admin%";

select * 
from Worker 
where (
    first_name like "%a%"
);

select * 
from Worker 
where (
    first_name like "%a"
);

select * 
from Worker 
where (
    first_name like "%h" 
    and  
    length(first_name)=6  
);

select * 
from Worker 
where (
    salary between 100000 and 500000
);

select * 
from Worker 
where (
    strftime("%m",Joining_Date)=="02"
    and 
    strftime("%y",Joining_Date)=="2014"
);

select department, count(Worker_ID)
from Worker
where (
    department="Admin"
);

select concat(first_name," ",last_name) as full_name 
from Worker 
where (
    salary >= 50000 
    and 
    salary <= 100000
);