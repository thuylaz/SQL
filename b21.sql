use master 
go

create database b21
on primary(
	name= 'b21_dat',
	filename= 'D:\SQL\b21.mdf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

log on(
	name= 'b21_log',
	filename= 'D:\SQL\b21.ldf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

go 
use b21
go

create table student(
	studentid nvarchar(12) not null primary key,
	studentname nvarchar(25) not null,
	dateofbirht datetime,
	email nvarchar(40),
	phone nvarchar(12),
	class nvarchar(10)
)

create table subject(
	subjectid nvarchar(10) not null primary key,
	subjectname nvarchar(25) not null
)

create table mark(
	studentid nvarchar(12) not null,
	subjectid nvarchar(10) not null,
	datee datetime,
	theory tinyint,
	practical tinyint,
	constraint pk_m primary key(studentid,subjectid),
	constraint fk_m_st foreign key(studentid)
	references student(studentid),
	constraint fk_m_sj foreign key(subjectid)
	references subject(subjectid)
)

insert into student values
('AV0807005', N'Mail Trung Hiếu', '11/10/1989', 'trunghieu@yahoo.com', 0904115116, 'AV1'),
('AV0807006', N'Nguyễn Quý Hùng', '2/12/1988', 'quyhung@yahoo.com', 0955667787, 'AV2'),
('AV0807007', N'Đỗ Đắc Huỳnh', '2/1/1990', 'dachuynh@yahoo.com', 0988574747, 'AV2'),
('AV0807009', N'An Đăng Khuê', '6/3/1986', 'dangkhue@yahoo.com', 0986757463, 'AV1'),
('AV0807010', N'Nguyễn T. Tuyết Lan', '12/7/1989', 'tuyetlan@gmail.com', 0983310342, 'AV2')

insert into student(studentid, studentname, dateofbirht, email, class) values
('AV0807011', N'Đinh Phụng Long', '2/12/1990', 'phunglong@yahoo.com', 'AV1'),
('AV0807012', N'Nguyễn Tuấn Nam', '2/3/1990', 'tuannam@yahoo.com', 'AV1')

insert into subject values
('S001', 'SQL'),
('S002', 'Java Simplefield'),
('S003', 'Active Server Page')

insert into mark(studentid, subjectid, theory, practical, datee) values
('AV0807005', 'S001', 8, 25, '6/5/2008'),
('AV0807006', 'S002', 16, 30, '6/5/2008'),
('AV0807007', 'S001', 10, 25, '6/5/2008'),
('AV0807009', 'S003', 7, 13, '6/5/2008'),
('AV0807010', 'S003', 9, 16, '6/5/2008'),
('AV0807011', 'S002', 8, 30, '6/5/2008'),
('AV0807012', 'S001', 7, 31, '6/5/2008'),
('AV0807005', 'S002', 12, 11, '6/6/2008'),
('AV0807010', 'S001', 7, 6, '6/6/2008')

select*from student
select*from subject
select*from mark

