-- Part 1: Simple Retrieval (SELECT, WHERE, ORDER BY)


-- 1. Find the names and Grades of all students in discipline ’Physics’.
select sname, gpa from Students where (discipline="Physics");

-- 2. List the course names and their credit values for all courses worth 4 credits.
select cname, credits from Courses where (credits=4);

-- 3. Retrieve the student ID and course ID for all enrollments where the grade is ’F’.
select sid, cid from Enrolled where (grade="F");

-- 4. List all student names and their discipline, sorted alphabetically by discipline, and then by name for students in the same discipline.
select sname, discipline from Students order by discipline asc, sname asc;


-- Part 2: Joins


-- 1. List the names of all students who are enrolled in ’Databases’ (CSL303).
select sname from Students join Enrolled on Students.sid = Enrolled.sid where Enrolled.cid="CSL303";

-- 2. Find the names of all courses that ’Ben Taylor’ is enrolled in.
select c.cname from Courses as c join Enrolled as e on c.cid = e.cid join Students as s on e.sid = s.sid where s.sname = "Ben Taylor";

-- 3. Show the name of each student and the name of each course they are enrolled in, along with their grade.
select s.sname, c.cname, e.grade from Students as s join Enrolled as e on s.sid = e.sid join Courses as c on e.cid = c.cid;

-- 4. List the names of all students who are not enrolled in any courses.
select s.sname from Students as s left join Enrolled as e on s.sid=e.sid where e.cid is null;

-- 5. Find the names of all students who received a ’B’ in a 3-credit course. 
select distinct s.sname from Students as s join Enrolled as e on s.sid=e.sid join Courses as c on e.cid=c.cid where e.grade="B" and c.credits=3;


-- Part 3: Aggregation and Grouping


-- 1. For each discipline, find the number of students in it.
select discipline, count(discipline) from Students group by discipline;

-- 2. Count the number of courses offered, grouped by the number of credits (i.e., how many 3-credit courses, 4-credit courses, etc.).
select credits, count(credits) from Courses group by credits;

-- 3. For each course, find the number of students enrolled. List the course name and the student count.
select c.cname, count(e.sid) as student_count from Courses as c left join Enrolled as e on c.cid = e.cid group by c.cname;

-- 4. Find the ‘cid‘ of all courses that have more than 2 students with a grade of ’A’.
select cid from Enrolled where (grade="A") group by cid having count(sid)>2;
