use master
go
if (exists(select * from sysdatabases where name ='DeptEmp'))
drop database DeptEmp
go
create database DeptEmp
on primary (
name='DeptEmp_dat', filename='E:\DeptEmp.mdf', size=2MB, maxsize=10MB, filegrowth=20%)
log on (name='DeptEmp_log', filename='E:\DeptEmp.ldf', size=1MB, maxsize=5MB, filegrowth=1MB)
go
use DeptEmp
go
create table Department
(DepartmentNo Integer not null PRIMARY KEY,
DepartmentName char(25) not null,
Location char(25) not null
)
create table Employee
(EmpNo integer not null PRIMARY KEY,
Fname varchar(15) not null,
Lname varchar(15) not null,
Job varchar(25) not null,
HireDate datetime not null,
Salary numeric not null,
Commision numeric,
DepartmentNo integer not null,
constraint fk foreign key(DepartmentNo) references Department(DepartmentNo) on update cascade on delete cascade
)
-- CHEN DU LIEU VAO BANG DEPARTMENT
INSERT INTO Department 
(DepartmentNo, DepartmentName, Location)
VALUES
(10, 'Accounting', 'Melbourne'),
(20, 'Research', 'Adealide'),
(30, 'Sales', 'Sydney'),
(40, 'Operations', 'Perth');

-- CHEN DU LIEU VAO BANG EMPLOYEE
INSERT INTO Employee
(EmpNo, Fname, Lname, Job, HireDate, Salary, Commision, DepartmentNo)
VALUES
(1, 'John', 'Smith', 'Clerk', '12-Dec-1980', 800, null, 20), 
(2, 'Peter', 'Allen', 'Salesman', '20-Feb-1981', 1600, 300, 30),
(3, 'Kate', 'Ward', 'Salesman', '22-Feb-1981', 1250, 500, 30),
(4, 'Jack', 'Jones', 'Manager', '02-Apr-1981', 2975, null, 20),
(5, 'Joe', 'Martin', 'Salesman', '28-Sep-1981', 1250, 1400, 30);

--TRUY VAN DU LIEU
--cau1--hiển thị nội dung bảng Department
SELECT * FROM Department
 
--cau2--hiển thị nội dung bảng Employee
SELECT * FROM Employee

--cau3--hiển thị EmpNo, Fname, Lname từ bảng Employee mà Fname có tên là 'Kate'
SELECT EmpNo, Fname, Lname FROM Employee
WHERE Fname = 'Kate'

--cau4--ghép 2 trường Fname và Lname hành Fullname và Salary, 10%Salary
SELECT Fname + ' ' + Lname as 'Fullname', Salary, Salary-Salary*0.1 as '10%Salary' 
FROM Employee
go

--cau5--hiển thị Fname, Lname, HireDate cho tất cả các Employee có HireDate là năm 1981 và xếp theo thứ tự tăng dần của Lname
SELECT Fname, Lname, HireDate FROM Employee
WHERE YEAR(HireDate) = 1981
ORDER BY Lname ASC
--cach khac SELECT Fname, Lname, HireDate FROM Employee
--			WHERE DATEPART(yy, HireDate) = 1981
--			ORDER BY Lname ASC

--cau6--hiển thị avg, min, max của salary cho từng phòng ban trong bảng Employee
SELECT DepartmentName, MIN(Salary) AS 'luong thap nhat', MAX(Salary) AS 'luong cao nhat', 'luong trung binh' = AVG(Salary)
FROM Employee, Department
WHERE (Employee.DepartmentNo = Department.DepartmentNo) 
GROUP BY DepartmentName

--cau7--hiển thị DepartmentNo và số người có trong từng phòng ban trong bảng Employee
SELECT DepartmentNo, COUNT (EmpNo) as 'Number Employee' 
FROM Employee
GROUP BY DepartmentNo 

--cau8--hiển thị DepartmentNo, DepartmentName, Full name, Job, Salary trong bảng Employee, Department
SELECT Employee.DepartmentNo, Department.DepartmentName, Fname + ' ' + Lname as 'Full name' , Job, Salary
FROM Employee, Department
WHERE (Employee.DepartmentNo = Department.DepartmentNo)

--cau9--hiển thị DepartmentNo, DepartmentName, Location và số người có trong từng phòng ban của bảng Employee, Department
SELECT Employee.DepartmentNo, Department.DepartmentName, Department.Location, count(Employee.DepartmentNo) as 'Number Employee'
FROM Employee, Department
WHERE (Employee.DepartmentNo = Department.DepartmentNo) 
GROUP BY Employee.DepartmentNo,  Department.DepartmentName, Department.Location

--cau10--hiển thị tất cả DepartmentNo, DepartmentName, Location và số người có trong từng phòng ban của bảng Employee, Department
SELECT Employee.DepartmentNo, Department.DepartmentName, Department.Location, count(Employee.DepartmentNo) as 'Number Employee'
FROM Department left outer join Employee
on Employee.DepartmentNo = Department.DepartmentNo
GROUP BY Employee.DepartmentNo,  Department.DepartmentName, Department.Location
go
