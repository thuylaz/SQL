use master
GO
IF(exists(SELECT * FROM sysdatabases WHERE NAME='MarkManagement'))
	DROP DATABASE MarkManagement
GO

/* A. Create Database */

CREATE DATABASE MarkManagement

GO
USE MarkManagement
GO
/* B. Create Table */

CREATE TABLE Students(
	StudentID  NVARCHAR(12) NOT NULL PRIMARY KEY,
	StudentName NVARCHAR(25) NOT NULL,
	DateofBirth DATETIME NOT NULL,
	Email NVARCHAR(40),
	Phone NVARCHAR(12),
	Class NVARCHAR(10)
)

CREATE TABLE Subjects(
	SubjectID NVARCHAR(10) NOT NULL PRIMARY KEY,
	SubjectName NVARCHAR(25) NOT NULL
)

CREATE TABLE Mark(
	ID int NOT NULL identity,
	StudentID NVARCHAR(12) NOT NULL,
	SubjectID NVARCHAR(10) NOT NULL,
	Theory TINYINT,
	Practical TINYINT,
	DATE DATETIME,
	CONSTRAINT Pri_Key PRIMARY KEY(ID, StudentID, SubjectID),
	CONSTRAINT Mark_Stu FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
	CONSTRAINT Mark_Sub FOREIGN KEY(SubjectID) REFERENCES Subjects(SubjectID)
)

GO	

/* C. Insert Data */

INSERT INTO Students 
VALUES  ('AV0807005',N'Mail Trung Hiếu','11/10/1989','trunghieu@yahoo.com','0904115116','AV1'),
		('AV0807006',N'Nguyễn Quý Hùng','2/12/1988','quyhung@yahoo.com','0955667787','AV2'),
		('AV0807007',N'Đỗ Đắc Huỳnh','2/1/1990','dachuynh@yahoo.com','0988574747','AV2'),
		('AV0807009',N'An Đăng Khê','6/3/1986','dangkhue@yahoo.com','0986757463','AV1'),
		('AV0807010',N'Nguyễn T. Tuyết Lan','12/7/1989','tuyetlan@gmail.com','0983310342','AV2'),
		('AV0807011',N'Đinh Phụng Long','2/12/1990','phunglong@yahoo.com','','AV1'),
		('AV0807012',N'Nguyễn Tuấn Nam','2/3/1990','tuannam@yahoo.com','','AV1')

INSERT INTO Subjects
VALUES('S001','SQL'), ('S002','Java Simplefield'), ('S003', 'Active Server Page')

INSERT INTO Mark
VALUES  ('AV0807005','S001',8,25,'6/5/2008'),
		('AV0807006','S002',16,30,'6/5/2008'),
		('AV0807007','S001',10,25,'6/5/2008'),
		('AV0807009','S003',7,13,'6/5/2008'),
		('AV0807010','S003',9,16,'6/5/2008'),
		('AV0807011','S002',8,30,'6/5/2008'),
		('AV0807012','S001',7,31,'6/5/2008'),
		('AV0807005','S002',12,11,'6/6/2008'),
		('AV0807009','S003',11,20,'6/6/2008'),
		('AV0807010','S001',7,6,'6/6/2008')

 GO

 -- test
 SELECT * FROM Students
 SELECT * FROM Subjects
 SELECT * FROM Mark
 GO
 --1. Hiển thị nội dung bảng Students
	SELECT * FROM  Students
 --2. Hiển thị nội dung danh sách sinh viên lớp AV1
	SELECT * FROM  Students
    WHERE Class='AV1'
  --3.Sử dụng lệnh UPDATE để chuyển sinh viên có mã AV0807012 sang lớp AV2
  UPDATE Students SET  Class='AV2' WHERE StudentID='AV0807012'
   --test
  SELECT * FROM  Students
  GO
  --4. Tính tổng số sinh viên của từng lớp
  SELECT Class, count(*) AS 'Slstudent'
  FROM Students
  GROUP BY Class
  --5. Hiển thị danh sách sinh viên lớp AV2 được sắp xếp tăng dần theo StudentName
  SELECT * FROM Students 
  WHERE Class='AV2'
  ORDER BY StudentName ASC
  --6.Hiển thị danh sách sinh viên không đạt lý thuyết môn S001 (theory <10) thi ngày 6/5/2008
  SELECT * FROM Students 
  where StudentID IN (SELECT StudentID FROM Mark WHERE SubjectID='S001' AND Theory<10 and DATE='6/5/2008')
  --7. Hiển thị tổng số sinh viên không đạt lý thuyết môn S001. (theory <10)
  SELECT count(*) AS 'SV không đạt S001'
  FROM Mark
  WHERE SubjectID='S001' AND Theory<10
  --8.Hiển thị Danh sách sinh viên học lớp AV1 và sinh sau ngày 1/1/1980
  SELECT * FROM Students
  WHERE Class='AV1' AND DateofBirth> '1/1/1980'
  --9. Xoá sinh viên có mã AV0807011
  DELETE FROM Mark
  WHERE StudentID='AV0807011'
  DELETE FROM Students
  WHERE StudentID='AV0807011'
  --test
  SELECT * FROM Students
  SELECT * FROM Mark
  go
  -- 10. Hiển thị danh sách sinh viên dự thi môn có mã S001 ngày 6/5/2008
  --bao gồm các trường sau: StudentID, StudentName, SubjectName, Theory, Practical, Date
  SELECT Students.StudentID, StudentName, SubjectName, Theory, Practical, DATE
  FROM Students INNER JOIN Mark ON Students.StudentID = Mark.StudentID
			  INNER JOIN Subjects ON Mark.SubjectID = Subjects.SubjectID
  WHERE Mark.SubjectID = 'S001' AND Mark.DATE = '6/5/2008'
  GO

