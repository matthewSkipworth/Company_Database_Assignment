CREATE TABLE EMPLOYEE(
	Fname varchar(100),
    Minit char(1),
    Lname varchar(100),
    Ssn char(9), 
    Bdate char(10),
    Address varchar(100),
    Sex char(1),
    Salary integer,
    Super_ssn char(9) PRIMARY KEY,
    Dno integer
);

CREATE TABLE DEPARTMENT (
	Dname varchar(100),
    Dnumber integer PRIMARY KEY,
    Mgr_ssn char(9),
    Mgr_start_date char(10)
);

CREATE TABLE DEPT_LOCATIONS(
	Dnumber integer PRIMARY KEY,
    Dlocation varchar(100) PRIMARY KEY
);

CREATE TABLE PROJECT(
	Pname varchar(100),
    Pnumber integer PRIMARY KEY,
    Plocation varchar(100),
    Dnum int
);

CREATE TABLE WORKS_ON(
	Essn char(9) PRIMARY KEY,
    Pno integer,
    Hours float
);

CREATE TABLE DEPENDENT(
	Essn char(9) PRIMARY KEY,
    Dependent_name varchar(100) PRIMARY KEY, 
    Sex char(1),
    Bdate char(10),
    Relationship varchar(100)
);

INSERT INTO EMPLOYEE #(Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
VALUES('John', 'B', 'Smith', '123456789', '1965-01-09', '731 Fondren, Houston, TX', 'M', 30000, '333445555', 5),

#insert into EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638 Voss, Houston, TX', 'M', 40000, '888665555', 5),

##insert into EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19','3321 Castle, Spring, TX', 'F', 25000, '987654321', 4),

#insert into EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
('Jennifer','S','Wallace','987654321','1941-06-20','291 Berry, Bellaire, TX', 'F', 43000, '888665555', 4),

#insert into EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
('Ramesh','K','Narayan','666884444','1962-09-15','975 Fire Oak, Humble, TX', 'M', 38000, '333445555', 5),

#insert into EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
('Joyce','A','English','453453453','1972-07-31','5631 Rice, Houston, TX', 'F', 25000, '333445555', 5),

#insert into EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
('Ahmad','V','Jabbar','987987987','1969-03-29','980 Dallas, Houston, TX', 'M', 25000, '987654321', 4),

#insert into EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
('James','E','Borg','888665555','1937-11-10','450 Stone, Houston, TX', 'M', 55000, NULL, 1);


#SELECT * FROM EMPLOYEE

INSERT INTO DEPARTMENT VALUES
	('Research', 5, '333445555','1988-05-22'),
	('Administration', 4, '987654321', '1995-01-01'),
	('Headquarters', 1, '888665555', '1981-06-19');

#SELECT * FROM DEPARTMENT

INSERT INTO DEPT_LOCATIONS VALUES
	(1, 'Houston'),
	(4, 'Stafford'),
	(5, 'Bellaire'),
    (5, 'Sugarland'),
    (5, 'Houston');
    
INSERT INTO PROJECT VALUES
	('ProductX', 1, 'Bellaire', 5),
    ('ProductY', 2, 'Sugarland', 5),
    ('ProductZ', 3, 'Houston', 5),
    ('Computerization',10, 'Stafford',4),
    ('Reorganization',20,'Houston',1),
    ('Newbenefits',30,'Stafford',4);
    
INSERT INTO WORKS_ON VALUES
	('123456789',1,32.5),
    ('123456789',2,7.5),
    ('666884444', 3, 40.0),
    ('453453453',1,20.0),
    ('453453453',2,20.0),
    ('333445555',2,10.0),
    ('333445555',3,10.0),
    ('333445555',10,10.0),
    ('333445555',20,10.0),
    ('999887777',30,30.0),
    ('999887777',10,10.0),
    ('987987987',10,35.0),
    ('987987987',30,5.0),
    ('987654321',30,20.0),
    ('987654321',20,15.0),
    ('888665555',20,NULL);
    
INSERT INTO DEPENDENT VALUES
	('333445555','Alice','F','1986-04-05','Daughter'),
    ('333445555','Theodore','M','1983-10-25','Son'),
    ('333445555','Joy','F','1958-05-03','Spouse'),
    ('987654321','Abner','M','1942-02-28','Spouse'),
    ('123456789', 'Michael','M','1988-01-04','Son'),
    ('123456789','Alice','F','1988-12-30','Daughter'),
    ('123456789','Elizabeth','F','1967-05-05','Spouse');
    
    
    
#Retrieve the names of employees in department 5 who work more than 10 hours per week on the 'ProductX' project.
select distinct Fname, Minit, Lname 
from EMPLOYEE
where Ssn in (
	select Essn
    from WORKS_ON
    where Hours > 10.0 and Pno = (
		select Pnumber
        from PROJECT
        where Pname = 'ProductX'
	)
);


#List the names of employees who have a dependent with the first name as themselves.
select Fname, Minit, Lname
from EMPLOYEE
where Fname in (
	select Dependent_name
    from DEPENDENT
);

#Find the names of employees that are directly supervised by 'Franklin Wong'.
select distinct Fname, Minit, Lname
from EMPLOYEE
where Super_ssn IN (
	select Ssn
    from EMPLOYEE
	where Fname = 'Franklin' and Lname = 'Wong'
);
#For each project, list the project name and the total hours per week (by all employees) spent on that project.

select Pname, sum(hours)
from WORKS_ON  join PROJECT on Pnumber = Pno
group by Pname;

#Retrieve the names of employees who work on every project.
select Fname, Minit, Lname
from EMPLOYEE
where Ssn=(
	select Essn
    from WORKS_ON
    join PROJECT on Pno=Pnumber
    group by Essn
    having count(Pno)=(
		select count(Pname)
		from PROJECT
	)
);

#Retrieve the names of employees who do not work on any project.
select Fname, Minit, Lname
from EMPLOYEE
where Ssn=(
	select Essn 
	from WORKS_ON
	join PROJECT on Pno=Pnumber
	group by Essn
	having count(Pno) = 0
);

#For each department, retrieve the department name, and the average salary of employees working in that department.
select Dname, avg(Salary)
from DEPARTMENT
join EMPLOYEE on Dno=Dnumber
group by Dname;

#Retrieve the average salary of all female employees
select avg(Salary)
from EMPLOYEE
group by Sex
having Sex='F';

#Find the names and addresses of employees who work on at least one project located in Houston,  but whose department 
#has no location in Houston.
select distinct Fname, Minit, Lname, Address
from EMPLOYEE
where Ssn in (
	select Essn
	from WORKS_ON
	join PROJECT on Pno=Pnumber
	where Plocation = 'Houston'
);

#List all names of department managers who have no dependents
   
select distinct Lname
from EMPLOYEE
where Ssn in (
	select Mgr_ssn
	from DEPARTMENT
	where Mgr_ssn not in (
		select Essn
		from DEPENDENT
		)
);

