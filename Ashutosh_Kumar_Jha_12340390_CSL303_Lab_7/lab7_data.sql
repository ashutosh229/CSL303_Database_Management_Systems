-- Populate database with random data safely
-- Run: sqlite3 university.db < lab7_data.sql

PRAGMA foreign_keys = OFF;

DELETE FROM Enrollments;
DELETE FROM Students;
DELETE FROM Courses;

PRAGMA journal_mode = MEMORY;
PRAGMA synchronous = OFF;

BEGIN TRANSACTION;

-- Generate 2000 Students
WITH RECURSIVE 
  cnt(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM cnt LIMIT 2000),
  random_majors(id, major) AS (
    VALUES (0, 'Computer Science'), (1, 'Physics'), (2, 'Chemistry'), (3, 'Mathematics'), (4, 'Humanities'), (5, 'Engineering')
  )
INSERT INTO Students (first_name, last_name, email, major, enrollment_date)
SELECT
  'FirstName' || x,
  'LastName' || x,
  'student' || x || '@university.edu',
  (SELECT major FROM random_majors WHERE id = ABS(RANDOM()) % 6),
  DATE('2020-01-01', '+' || (ABS(RANDOM()) % 1825) || ' days')
FROM cnt;

-- Generate 100 Courses
WITH RECURSIVE
  cnt2(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM cnt2 LIMIT 100),
  random_depts(id, dept) AS (
    VALUES (0, 'Science'), (1, 'Humanities'), (2, 'Engineering'), (3, 'Arts'), (4, 'Business')
  )
INSERT INTO Courses (course_name, department, credits)
SELECT
  'Course' || x || ' ' || (SELECT dept FROM random_depts WHERE id = ABS(RANDOM()) % 5),
  (SELECT dept FROM random_depts WHERE id = ABS(RANDOM()) % 5),
  (ABS(RANDOM()) % 3) + 2
FROM cnt2;

-- Generate 10000 Enrollments
WITH RECURSIVE
  cnt3(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM cnt3 LIMIT 10000)
INSERT INTO Enrollments (student_id, course_id, grade)
SELECT
  (ABS(RANDOM()) % 2000) + 1,
  (ABS(RANDOM()) % 100) + 1,
  ROUND((ABS(RANDOM()) % 2.0) + 2.0, 2)
FROM cnt3;

COMMIT;

PRAGMA synchronous = FULL;
PRAGMA journal_mode = DELETE;
PRAGMA foreign_keys = ON;
VACUUM;
