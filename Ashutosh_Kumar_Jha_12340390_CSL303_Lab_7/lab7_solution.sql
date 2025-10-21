-- 4
SELECT *
FROM Students
WHERE major = 'Computer Science';

-- 5
EXPLAIN QUERY PLAN
SELECT *
FROM Students
WHERE major = 'Computer Science';

-- 6
SELECT 
    s.first_name,
    s.last_name,
    c.course_name
FROM Students AS s
JOIN Enrollments AS e
    ON s.student_id = e.student_id
JOIN Courses AS c
    ON e.course_id = c.course_id
WHERE c.department = 'Humanities';

-- 7
EXPLAIN QUERY PLAN
SELECT 
    s.first_name,
    s.last_name,
    c.course_name
FROM Students AS s
JOIN Enrollments AS e
    ON s.student_id = e.student_id
JOIN Courses AS c
    ON e.course_id = c.course_id
WHERE c.department = 'Humanities';

-- 8
CREATE INDEX idx_major ON Students(major);

-- 9
EXPLAIN QUERY PLAN
SELECT *
FROM Students
WHERE major = 'Computer Science';

-- 10
CREATE INDEX idx_enrollments_student_id ON Enrollments(student_id);
CREATE INDEX idx_enrollments_course_id ON Enrollments(course_id);

-- 11 
EXPLAIN QUERY PLAN
SELECT 
    s.first_name,
    s.last_name,
    c.course_name
FROM Students AS s
JOIN Enrollments AS e
    ON s.student_id = e.student_id
JOIN Courses AS c
    ON e.course_id = c.course_id
WHERE c.department = 'Humanities';








