use master
go
if(exists(select * from sysdatabases where name='MarkManagement'))
	drop database MarkManagemet
go

/* A. Create Database */

create database MarkManagement

go
use MarkManagement
go
/* B. Create Table */

create table STUDENTS(
	StudentID nvarchar(12) not null primary key,
	StudentName nvarchar(25) not null,
	DateofBirth datetime not null,
	Email nvarchar(40),
	Phone nvarchar(12),
	Class nvarchar(10)
)

create table SUBJECTS(
	SubjectID nvarchar(10) not null primary key,
	SubjectName nvarchar(25) not null
)

create table MARK(
	ID int not null identity,
	StudentID nvarchar(12) not null,
	SubjectID nvarchar(10) not null,
	Theory tinyint,
	Practical tinyint,
	Date datetime,
	constraint Pri_Key primary key(ID, StudentID, SubjectID),
	constraint Mark_Stu foreign key(StudentID) references Students(StudentID),
	constraint Mark_Sub foreign key(SubjectID) references Subjects(SubjectID)
)

go


/* C. Insert Data */

insert into STUDENTS 
values('AV0807005',N'Mai Trung Hiếu','11/10/1989','trunghieu@yahoo.com','0904115116','AV1'),
		('AV0807006',N'Nguyễn Quý Hùng','2/12/1988','quyhung@yahoo.com','0955667787','AV2'),
		('AV0807007',N'Đỗ Đắc Huỳnh','2/1/1990','dachuynh@yahoo.com','0988574747','AV2'),
		('AV0807009',N'An Đăng Khê','6/3/1986','dangkhue@yahoo.com','0986757463','AV1'),
		('AV0807010',N'Nguyễn T. Tuyết Lan','12/7/1989','tuyetlan@gmail.com','0983310342','AV2'),
		('AV0807011',N'Đinh Phụng Long','2/12/1990','phunglong@yahoo.com','','AV1'),
		('AV0807012',N'Nguyễn Tuấn Nam','2/3/1990','tuannam@yahoo.com','','AV1')

insert into SUBJECTS
values('S001','SQL'), ('S002','Java Simplefield'), ('S003', 'Active Server Page')

insert into MARK
values('AV0807005','S001',8,25,'6/5/2008'),
 ('AV0807006','S002',16,30,'6/5/2008'),
 ('AV0807007','S001',10,25,'6/5/2008'),
 ('AV0807009','S003',7,13,'6/5/2008'),
 ('AV0807010','S003',9,16,'6/5/2008'),
 ('AV0807011','S002',8,30,'6/5/2008'),
 ('AV0807012','S001',7,31,'6/5/2008'),
 ('AV0807005','S002',12,11,'6/6/2008'),
 ('AV0807009','S003',11,20,'6/6/2008'),
 ('AV0807010','S001',7,6,'6/6/2008')

 go

 -- test
 select * from STUDENTS
 select * from SUBJECTS
 select * from MARK
 go