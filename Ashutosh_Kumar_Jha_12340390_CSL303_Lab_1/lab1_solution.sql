-- Creating the .db file and entering into it
sqlite3 student.db

-- Creating the table for Students
create table Students(
StudentID integer PRIMARY KEY,
FirstName VARCHAR(255) NOT NULL,
LastName VARCHAR(255) NOT NULL,
Discipline VARCHAR(255)
);

-- Creating the table for Faculty 
create table Faculty(
FacultyID int PRIMARY KEY,
FirstName varchar(255) NOT NULL,
LastName varchar(255) NOT NULL,
Department varchar(255)
);

-- Inserting the values into Students Table 
insert into Students (StudentID, FirstName, LastName, Discipline)
values
(1, "Ashutosh", "Jha", "DSAI"),
(2, "Ashutosh", "Prajapati", "CSE"),
 (3, "Chetan", "Rathod", "DSAI"),
(4, "Akash", "Rathod", "EE"),
(5, "Akshat", "Gupta", "ME"),
(6, "Shashwat", "Jaiswal", "MSME");

-- Inserting the values into Faculty Table
insert into Faculty (FacultyID, FirstName, LastName, Department)
values
(1, "Gagan", "Gupta", "CSE"),
(2, "Gagan", "Jaiswal", "EE"),
(3, "Rishi", "Ranjan", "CSE"),
(4, "Rajkumar", "Ranjan", "ME"),
(5, "Amit", "Dhar", "CSE"),
(6, "Nitin", "Khana", "EE");

-- Selecting the students from the Students table whose discipline is "CSE"
select * from Students where (Discipline = "CSE");

-- Selecting the faculty from the Faculty table whose discipline is "CSE
select * from Faculty where (Department = "CSE");

-- Selecting the FirstName and LastName column from Students table
select FirstName, LastName from Students;

-- Selecting the LastName and Department column from Faculty table
select LastName, Department from Faculty;

-- Listing all unique first names of both students and faculty
select distinct FirstName from Students
union
select distinct FirstName from Faculty;

-- Listing all unique last names of both students and faculty
select distinct LastName from Students
union
select distinct LastName from Faculty;

-- Finding all first names that are common to both students and faculty
select distinct FirstName from Students
intersect
select distinct FirstName from Faculty;

-- Finding all last names that are common to both students and faculty
select distinct LastName from Students
intersect
select distinct LastName from Faculty;