-- 1. Create a new table “enrolled” where there is no “enroll id” and primary key is (“student id”,
-- “course id”).
create table enrolled (
    student_id INTEGER,
    course_id INTEGER,
    grade TEXT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY(student_id) REFERENCES Students(student_id),
    FOREIGN KEY(course_id) REFERENCES Courses(course_id)
);

-- 2. Insert all the data that is existing in “Enrolment” table into “enrolled” table.
insert into enrolled
(student_id, course_id, grade)
select student_id, course_id, grade 
from Enrollments;

-- 3. Update the department of students with character ’i’ in their name to ’Philosophy’.
update Students
set department = "Philosophy"
where name like '%i%';

-- 4. Add a new column email to the Students table.
alter table Students 
add column email text;

-- 5. Update the email for all students as “name@iitbhilai.ac.in”.
update Students 
set email = lower(name)||'@iitbhilai.ac.in';

-- 6. Select all students in the ”Computer Science” department.
select name
from Students
where department = "Computer Science";

-- 7. Find names that exist both as student names and as course names.
select s.name 
from Students as s 
join Courses as c 
on s.name = c.course_name;

-- 8. List student names and their enrolled course names in a course name wise. The course name should
-- appear in ascending order.
select s.name, c.course_name
from Students as s
join enrolled as e
on s.student_id = e.student_id
join Courses as c
on e.course_id = c.course_id
order by c.course_name asc;

-- 9. List all students and their enrolled courses (including students with no enrollments).
select s.name, c.course_name
from Students as s  
left join enrolled as e
on s.student_id = e.student_id  
left join Courses as c
on e.course_id = c.course_id
order by s.name;

-- 10. List all students whose name starts with ”A”
select name
from Students
where (
    name like "A%"
);

-- 11. Find students who are enrolled in at least one course worth more than 3 credits.
select distinct s.name 
from Students as s 
join enrolled as e 
on s.student_id = e.student_id
join Courses as c
on e.course_id = c.course_id
where c.credits > 3;

-- 12. Find students who have never enrolled in any course.
select name
from Students
where (
    student_id not in (
        select student_id
        from Enrollments
    )
);


