use master 
go

create database DeptEmp
on primary(
	name= 'DeptEmp_dat',
	filename= 'D:\SQL\DeptEmp.mdf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

log on(
	name= 'DeptEmp_log',
	filename= 'D:\SQL\DeptEmp.ldf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

go 
use DeptEmp
go

create table Department(
	DepartmentNo integer not null primary key,
	DepartmentName char(25) not null,
	Location char(25) not null
)

create table Employee(
	EmpNo integer not null primary key,
	Fname varchar(15) not null,
	Lname varchar(15) not null,
	Job varchar(25) not null,
	HireDate datetime not null,
	Salary numeric not null,
	Commision numeric,
	DepartmentNo integer not null,
	constraint fk_e_d foreign key(DepartmentNo)
	references Department(DepartmentNo)
)

insert into Department values
(10, 'Accounting', 'Melbourne'),
(20, 'Research', 'Adealide'),
(30, 'Sales', 'Sydney'),
(40, 'Operations', 'Perth')



insert into Employee(EmpNo, Fname, Lname, Job, HireDate, Salary, DepartmentNo) values
(1, 'John', 'Smith', 'Clerk', '6/5/2008', 800, 20),
(4, 'Jack', 'Jones', 'Manager', '2/4/1981', 2975, 20)
insert into Employee values
(2, 'Peter', 'Allen', 'Salesman', '2/20/2006', 1600, 300, 30),
(3, 'Kate', 'Ward', 'Salesman', '2/22/2007', 1250, 500, 30),
(5, 'Joe', 'Martin', 'Salesman', '2/9/2002', 1250, 1400, 30)


select*from Department
select*from Employee
