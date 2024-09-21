use master 
go

create database DeptEmp1
on primary(
	name= 'DeptEmp1_dat',
	filename= 'D:\SQL\DeptEmp1.mdf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

log on(
	name= 'DeptEmp1_log',
	filename= 'D:\SQL\DeptEmp1.ldf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

go 
use DeptEmp1
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
(1, 'John', 'Smith', 'Clerk', '12/17/1980', 800, 20),
(4, 'Jack', 'Jones', 'Manager', '7/2/1981', 2975, 20)
insert into Employee values
(2, 'Peter', 'Allen', 'Salesman', '11/20/1981', 1600, 300, 30),
(3, 'Kate', 'Ward', 'Salesman', '11/22/1981', 1250, 500, 30),
(5, 'Joe', 'Martin', 'Salesman', '09/28/1981', 1250, 1400, 30)

--cau 1
select*from Department
--cau 2
select*from Employee

--cau 3
select EmpNo, Fname, Lname 
from Employee
where Fname= 'Kate'

--cau 4
select CONCAT_WS(' ', Fname, Lname) as FullName, Salary, Salary*1.1 as tangSalary 
from Employee

--cau 5
select Fname, Lname, HireDate
from Employee
where HireDate= 1981
order by Lname asc

--cau 6
select DepartmentNo, avg(Salary) as tb_luong, max(Salary) as max_luong, min(Salary) as min_luong
from Employee
group by DepartmentNo 

--cau 7
select DepartmentNo, count(DepartmentNo) as so_nguoi_trong_phong
from Employee
group by DepartmentNo

--cau 8
select Department.DepartmentNo, Department.DepartmentName, 
CONCAT_WS(' ', Fname, Lname) as FullName, Employee.Job,
Employee.Salary
from Department join Employee
on Department.DepartmentNo= Employee.DepartmentNo

--cau 9
select Department.DepartmentNo, Department.DepartmentName, Department.Location, count(Department.DepartmentNo) as tong
from Department join Employee
on Department.DepartmentNo= Employee.DepartmentNo
group by Department.DepartmentNo, Department.DepartmentName, Department.Location



