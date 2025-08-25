create table Worker (
    Worker_ID integer not null primary key autoincrement,
    First_Name char(25), 
    Last_Name char(25), 
    Salary int(15), 
    Joining_Date datetime, 
    Department char(25)
);

insert into Worker 
(Worker_ID, First_Name, Last_Name, Salary, Joining_Date, Department)
values 
(001, 'Monika', 'Arora', 100000, '2014-02-20 09:00:00', 'HR'),
(002, 'Niharika', 'Verma', 80000, '2014-06-11 09:00:00', 'Admin'),
(003, 'Vishal', 'Singhal', 300000, '2014-02-20 09:00:00', 'HR'),
(004, 'Amitabh', 'Singh', 500000, '2014-02-20 09:00:00', 'Admin'),
(005, 'Vivek', 'Bhati', 500000, '2014-06-11 09:00:00', 'Admin'),
(006, 'Vipul', 'Diwan', 200000, '2014-06-11 09:00:00', 'Account'),
(007, 'Satish', 'Kumar', 75000, '2014-01-20 09:00:00', 'Account'),
(008, 'Geetika', 'Chauhan', 90000, '2014-04-11 09:00:00', 'Admin');

create table Bonus (
    Worker_Ref_ID int,
    Bonus_Amount int(10),
    Bonus_Date datetime,
    foreign key (Worker_Ref_ID)
        references Worker(Worker_ID)
        on delete cascade
);

INSERT INTO Bonus 
(Worker_Ref_ID, Bonus_Amount, Bonus_Date)
VALUES
(001, 5000, '2016-02-20'),
(002, 3000, '2016-06-11'),
(003, 4000, '2016-02-20'),
(001, 4500, '2016-02-20'),
(002, 3500, '2016-06-11');

CREATE TABLE Title (
    Worker_Ref_ID INTEGER,
    Worker_Title TEXT,
    Affected_From DATETIME,
    FOREIGN KEY (Worker_Ref_ID)
        REFERENCES Worker(Worker_ID)
        ON DELETE CASCADE
);

INSERT INTO Title 
(Worker_Ref_ID, Worker_Title, Affected_From) 
VALUES
(1, 'Manager', '2016-02-20 00:00:00'),
(2, 'Executive', '2016-06-11 00:00:00'),
(8, 'Executive', '2016-06-11 00:00:00'),
(5, 'Manager', '2016-06-11 00:00:00'),
(4, 'Asst. Manager', '2016-06-11 00:00:00'),
(7, 'Executive', '2016-06-11 00:00:00'),
(6, 'Lead', '2016-06-11 00:00:00'),
(3, 'Lead', '2016-06-11 00:00:00');