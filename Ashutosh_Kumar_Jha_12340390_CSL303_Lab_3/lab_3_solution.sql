-- Part 1: Joins and Outer Joins
---------------------------------------------------------------------------
-- 1. List the names of all courses and the name of the faculty member who teaches each course.
select 
c.cname as course_name, 
f.fname as faculty_name 
from Courses  as c 
left join faculty as f on c.instructor_fid = f.fid;

-- 2. Find the names of all students who are enrolled in a course taught by ’Prof. Sharma’.
select distinct 
s.sname 
from Students as s
join Enrolled as e on s.sid = e.sid
join Courses as c on e.cid = c.cid
join Faculty as f on c.instructor_fid = f.fid
where f.fname = "Prof. Sharma";

-- 3. List all student names. If a student is enrolled in any course, also list the course name. Include
-- students who are not enrolled in any course.
select 
s.sname as student_name, 
c.cname as course_name
from Students as s 
left join Enrolled as e on s.sid = e.sid 
left join Courses as c on e.cid = c.cid;

-- 4. List all faculty members and the names of the courses they teach. Include faculty who are not
-- currently teaching any course.
select 
f.fname as faculty_name, 
c.cname as course_name 
from Faculty as f 
left join Courses as c on f.fid = c.instructor_fid;


-- Part 2: Advanced Conditions and Functions
-------------------------------------------------------------------------------------------
-- 1. Find all students whose name contains the letter ’a’. The search should be case-insensitive 
select 
sname 
from Students 
WHERE lower(sname) LIKE '%a%';

-- 2. Find the student ID and name for all students who do not have a discipline listed (i.e., their
-- discipline is NULL).
select 
sid, sname 
from Students 
where discip is null;

-- 3. List the names and registration dates of all students who registered in the year 2022.
select 
sname, registration_date
from Students  
where strftime('%Y', registration_date) = "2022"; 

-- 4. Find the names of all students who registered in August 2022. Use the BETWEEN operator.
select 
sname
from Students 
where registration_date between "2022-08-01" and "2022-08-31";


-- Part 3: Subqueries and Set Operations
---------------------------------------------------------------------------------
-- 1. Find the names of all students who have a GPA greater than the average GPA of all students. (Use
-- a scalar subquery).
select 
sname 
from Students 
where gpa > (
    select avg(gpa)
    from Students
);

-- 2. Find the names of all ’CSE’ students who are not enrolled in ’Databases’ (CSL303). Use the
-- EXCEPT operator.
select 
s.sname 
from Students as s 
where s.discip = "CSE" 
except 
select 
s.sname 
from Students as s 
join Enrolled as e on s.sid = e.sid 
where (s.discip = "CSE" and e.cid = "CSL303");

-- 3. Find the names of all courses that have at least one student enrolled. Use a subquery with EXISTS.
select  
c.cname 
from Courses as c 
where exists (
    select  
    1 
    from Enrolled as e 
    where e.cid = c.cid
);

-- 4. Find the names of students who have the highest GPA in their respective discipline. (Use a
-- correlated subquery).
select 
s1.sname, s1.discip, s1.gpa 
from Students as s1 
where s1.gpa = (
    select 
    max(s2.gpa)
    from Students as s2 
    where s2.discip = s1.discip
);


-- Part 4: Data Manipulation Language (DML)
----------------------------------------------------------------------------------
-- 1. A new student has joined. Insert the following record into the Students table:
-- • sid: 108
-- • sname: ’Ravi’
-- • discip: ’EE’
-- • gpa: 8.0
-- • registration date: ’2023-09-01’
insert into  
Students 
(sid, sname, discip, gpa, registration_date)
values (201, 'Ravi', 'EE', 8.0, '2023-09-01');

-- 2. ’Prof. Sharma’ has decided to give a 10% GPA boost to all students who received an ’A’ in
-- ’Databases’ (CSL303). Write an UPDATE statement to reflect this change.
update 
Students  
set gpa = gpa*1.10
where sid in (
    select e.sid
    from Enrolled as e
    join Courses as c on e.cid = c.cid
    join Faculty as f on c.instructor_fid = f.fid
    where (e.grade = "A" and c.cid = "CSL303" and f.fname = "Prof. Sharma")
);

-- 3. The ’Linear Algebra’ course (MAL251) has been cancelled. Delete all enrollment records for this
-- course
delete from 
Enrolled 
where cid = "MAL251";

