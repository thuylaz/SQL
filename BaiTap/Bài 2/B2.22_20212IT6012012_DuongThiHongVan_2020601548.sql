use master
go
/* create database*/
create database DeptEmp
go
use DeptEmp
go
/*create table*/
create table DEPARTMENT
(
DepartmentNo integer primary key,
DepartmentName char(25) not null,
Location char(25) not null,
)
create table EMPLOYEE
(
EmpNo integer primary key,
Fname varchar(15) not null,
Lname varchar(15) not null,
Job varchar(25) not null,
HireDate datetime not null,
Salary numeric not null,
Commision numeri,
DepartmentNo integer
constraint fk_DE_EM foreign key(DepartmentNo) references DEPARTMENT(DepartmentNo)
)
go
/*insert data*/
insert into DEPARTMENT
values(10,'Accounting','Melburne'),
	  (20,'Research','Adealide'),
	  (30,'Sales','Sydney'),
	  (40,'Operation','Perth')

insert into EMPLOYEE
values(1,'John','Smith','Clerk','17- Dec-1980',800,'',20),
      (2,'Peter','Allen','Salesman','20-Feb-1981',1600,300,30),
	  (3,'Kate','Ward','Salesman','22-Feb-1981',1250,500,30),
	  (4,'Jack','Jones','Manager','02-Apr-1981',2975,'',20),
	  (5,'Joe','Martin','Salesman','28-Sep-1981',1250,1400,30)
go
--test
select *from DEPARTMENT
select *from EMPLOYEE
go
