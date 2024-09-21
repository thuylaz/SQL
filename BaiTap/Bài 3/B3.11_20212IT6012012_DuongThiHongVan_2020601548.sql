use master
go
/* create database */
CREATE DATABASE DeptEmp
GO

USE DeptEmp
GO

/* create table */
CREATE TABLE Department(
	DepartmentNo INTEGER PRIMARY KEY,
	DepartmentName CHAR(25) NOT NULL,
	Location CHAR(25) NOT NULL
)

CREATE TABLE Employee(
	EmpNo INTEGER PRIMARY KEY,
	Fname VARCHAR(15) NOT NULL,
	Lname VARCHAR(15) NOT NULL,
	Job VARCHAR(25) NOT NULL,
	HireDate DATETIME NOT NULL,
	Salary NUMERIC NOT NULL,
	Commision NUMERIC,
	DepartmentNo INTEGER,
	constraint fk_DE_EM FOREIGN KEY ̣̣(DepartmentNo) REFERENCES Department(DepartmentNo)
)
GO
/* insert data */
INSERT INTO Department
VALUES  (10, 'Accounting', 'Melburne'),
		(20, 'Research', 'Adealide'),
		(30, 'Sales', 'Sydney'),
		(40, 'Operation', 'Perth')

INSERT INTO Emoloyee
VALUES  (1, 'John', 'Smith', 'Clerk', '17-Dec-1980', 800, '', 20),
		(2, 'Peter', 'Allen', 'Salesman', '20-Feb-1981', 1600, 300, 30),
		(3, 'Kate', 'Ward', 'Salesman', '22-Feb-1981', 1250, 500, 30),
		(4, 'Jack', 'Jones', 'Manager', '02-Apr-1981', 2975, '', 20),
		(5, 'Joe', 'Martin', 'Salesman', '28-Sep-1981', 1250, 1400, 30)
GO

--1. Hiển thị nội dung bảng Department
SELECT * FROM DEPARTMENT
--2. Hiển thị nội dung bảng Employee
SELECT * FROM EMPLOYEE

--3.  Hiển thị employee number, employee first name và employee last name từ bảng Employee mà employee first name có tên là ‘Kate’.
SELECT EmpNo, FName, LName
		FROM Employee
		WHERE FName = 'Kate'

--4. Hiển thị ghép 2 trường Fname và Lname thành Full Name, Salary, 10%Salary (tăng 10% so với lương ban đầu).
SELECT FName+' '+LName AS FullName, Salary, Salary*1.1 AS '10% Salary'
		FROM Employee

--5.
SELECT FName, LName, HireDate
		FROM Employee
		WHERE Year(HireDate) =1981
		ORDER BY LName

/*
Các hàm ngày tháng
Year(): năm
Month():tháng
Day(): ngày
getdate(): trả về ngày tháng hiện tại
dayofweek(): trả về ngày của tuần
dayname(): trả về tên của ngày
*/
--6. Hiển thị trung bình(average), lớn nhất(max) và nhỏ nhất(min) của lương(salary) cho từng phòng ban trong bảng Employee
SELECT DepartmentNo, AVG(Salary) AS LUONGTB, MIN(Salary) AS LUONGNHOTNHAT, MAX(Salary) AS LUONGLONNHAT
		FROM Employee
		GROUP BY DepartmentNo
		--Hiển thị tên phòng ban và lương tb của từng phòng ban
	SELECT DepartmentName, AVG(Salary)
	FROM Department INNER JOIN Employee
	ON Department.DepartmentNo = Employee.DepartmentNo
	GROUP BY DepartmentName

--7. Hiển thị DepartmentNo và số người có trong từng phòng ban có trong bảng Employee
SELECT DepartmentNo, COUNT(*) AS SLNHANVIEN
FROM Employee
GROUP BY DepartmentNo
--8. Hiển thị DepartmentNo, DepartmentName, FullName (Fname và Lname), Job, Salary trong bảng Department và bảng Employee.
SELECT Department.DepartmentNo, DepartmentNam, FName+' '+LName AS FullName, Job, Salary
FROM Department INNER JOIN Employee
ON Department.DepartmentNo = Employee.DepartmentNo

--9. Hiển thị DepartmentNo, DepartmentName, Location và số người có trong từng phòng ban của bảng Department và bảng Employee.
SELECT Department.DepartmentNo, DepartmentName, Location, COUNT(EmpNo) AS SLNHANVIEN
FROM Department INNER JOIN Employee 
ON Department.DepartmentNo = Employee.DepartmentNo
GROUP BY Department.DepartmentNo, DepartmentName, Location

--10. Hiển thị tất cả DepartmentNo, DepartmentName, Location và số người có trong từng phòng ban của bảng Department và bảng Employee
SELECT Department.DepartmentNo, DepartmentName, Location, COUNT(EmpNo) AS SLNHANVIEN
FROM Employee RIGHT JOIN Department  
ON Department.DepartmentNo = Employee.DepartmentNo
GROUP BY Department.DepartmentNo, DepartmentName, Location

SELECT Department.DepartmentNo, DepartmentName, Location, COUNT(*) AS SLNHANVIEN
FROM Department LEFT JOIN Employee 
ON Department.DepartmentNo = Employee.DepartmentNo
GROUP BY Department.DepartmentNo, DepartmentName, Location