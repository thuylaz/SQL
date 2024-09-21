use master
go
if (exists (select * from sysdatabases where name = 'MarkManagement'))
drop table MarkManagement
go
create database MarkManagement
on primary (
name = 'MarkManagement_dat', filename = 'E:\MYSQL\MarkManagement.mdf', size=2MB, maxsize=10MB, filegrowth=20%)
log on (name = 'MarkManagement_log', filename = 'E:\MYSQL\MarkManagement.ldf', size=1MB, maxsize=5MB, filegrowth=1MB)
go
use MarkManagement
go
create table Students
(StudentID Nvarchar(12) primary key, 
StudentName Nvarchar(25) not null,
DateofBirth Datetime not null,
Email Nvarchar(40),
Phone Nvarchar(12),
Class Nvarchar(10)
)
create table Subjects
(SubjectID Nvarchar(10) primary key,
SubjectName Nvarchar(25) not null
)
create table Mark
(StudentID Nvarchar(12),
SubjectID Nvarchar(10),
Date Datetime,
Theory Tinyint,
Practical Tinyint,
constraint pk1 primary key(StudentID, SubjectID),
constraint fk1 foreign key(StudentID) references Students(StudentID) on update cascade on delete cascade,
constraint fk2 foreign key(SubjectID) references Subjects(SubjectID) on update cascade on delete cascade
)

-- Chen du lieu vao bang Students
INSERT INTO Students
(StudentID, StudentName, DateofBirth, Email, Phone, Class)
VALUES
('AV0807005', 'Mai Trung Hieu', '11/10/1989', 'trunghieu@yahoo.com', '0904115116', 'AV1'),
('AV0807006', 'Nguyen Quy Hung', '2/12/1988', 'quyhung@yahoo.com', '0955667787', 'AV2'),
('AV0807007', 'Do Dac Huynh', '2/1/1990', 'dachuynh@yahoo.com', '0988574747', 'AV2'),
('AV0807009', 'An Dang Khue', '6/3/1986', 'dangkhue@yahoo.com', '0986757463', 'AV1'),
('AV0807010', 'Nguyen T.Tuyet Lan', '12/7/1989', 'tuyetlan@yahoo.com', '0983310342', 'AV2'),
('AV0807011', 'Dinh Phung Long', '2/12/1990', 'phunglong@yahoo.com', null, 'AV1'),
('AV0807012', 'Nguyen Tuan Nam', '2/3/1990', 'tuannam@yahoo.com', null, 'AV1');

-- Chen du lieu vao bang Subjects
INSERT INTO Subjects
(SubjectID, SubjectName)
VALUES
('S001', 'SQL'),
('S002', 'Java Simplefield'),
('S003', 'Active Server Page');

-- Chen du lieu vao bang Mark 
INSERT INTO Mark
(StudentID, SubjectID, Theory, Practical, Date)
VALUES
('AV0807005', 'S001', 8, 25, '6/5/2008'),
('AV0807006', 'S002', 16, 30, '6/5/2008'),
('AV0807007', 'S001', 10, 25, '6/5/2008'),
('AV0807009', 'S003', 7, 13, '6/5/2008'),
('AV0807010', 'S003', 9, 16, '6/5/2008'),
('AV0807011', 'S002', 8, 30, '6/5/2008'),
('AV0807012', 'S001', 7, 31, '6/5/2008'),
('AV0807005', 'S002', 12, 11, '6/6/2008'),
('AV0807009', 'S002', 11, 20, '6/5/2008'),
('AV0807010', 'S001', 7, 6, '6/5/2008');

-- Truy van CSDL
--cau1--hiển thị nội dung bảng Students
SELECT * FROM Students

--cau2--hiển thị nội dung danh sách sinh viên lớp AV1
SELECT * FROM Students
WHERE Class='AV1'

--cau3--chuyển sinh viên có mã AV0807012 sang lớp AV2
UPDATE Students
SET Class = 'AV2'
WHERE StudentID = 'AV0807012'

--cau4-cach1--tính tổng sinh viên của từng lớp
SELECT Class, COUNT(Class)
FROM Students
GROUP BY Class

--cau4-cach2
SELECT Count(*) as 'Tong sinh vien lop AV1'
FROM Students
WHERE Class = 'AV1'
SELECT Count(*) as 'Tong sinh vien lop AV2'
FROM Students
WHERE Class = 'AV2'

--cau5--hiển thị danh sách sinh viên lớp AV2 được sắp xếp tăng dần theo StudentName
SELECT * FROM Students
WHERE Class = 'AV2'
ORDER BY StudentID ASC

--cau6-cach1--hiển thị danh sách sinh viên không đạt lí thuyết môn S001 thi ngày 6/5/2008
SELECT * FROM Students
WHERE StudentID IN (SELECT StudentID
					FROM Mark
					WHERE SubjectID='S001' AND Theory < 10 AND Date = '6/5/2008')

--cau6-cach2
SELECT Students.StudentID, StudentName, DateofBirth, Email, Phone, Class
FROM Students
INNER JOIN Mark
ON Students.StudentID = Mark.StudentID
WHERE Mark.SubjectID='S001' AND Theory < 10 AND Date = '6/5/2008'

--cau7-cach1--hiển thị tổng số sinh viên không đạt lí thuyết môn S001
SELECT COUNT(StudentID) AS 'Tong so SV truot'
FROM Students
WHERE StudentID IN (SELECT StudentID
					FROM Mark
					WHERE SubjectID='S001' AND Theory < 10)

--cau7-cach2
SELECT COUNT(*) AS 'Tong so SV truot'
FROM Mark
WHERE SubjectID='S001' AND Theory < 10

--cau8--hiển thị danh sách sinh viên học lớp AV1 và sinh sau ngày 1/1/1980
SELECT * FROM Students
WHERE (Class = 'AV1' AND DateofBirth > '1/1/1980')

--cau9--xoá sinh viên có mã AV0807011
DELETE FROM Students
WHERE (StudentID = 'AV0807011')

--cau10--hiển thị danh sách sinh viên dự thi môn có mã S001 ngày 6/5/2008 bao gồm các trường StudentID, StudentName, Theory, Practical, Date
SELECT Mark.StudentID, StudentName, Theory, Practical, Date
FROM Mark
INNER JOIN Students ON Students.StudentID = Mark.StudentID
INNER JOIN Subjects ON Subjects.SubjectID = Mark.SubjectID
WHERE (Mark.SubjectID = 'S001' AND Date = '6/5/2008')

--cau11-dua ra thong tin sinh vien co diem li thuyet cao hon diem li thuyet tat ca cac sinh vien hoc mon S001
SELECT MarK.StudentID, StudentName, Theory
FROM Mark
INNER JOIN Students ON Students.StudentID = Mark.StudentID
WHERE Theory > (SELECT MAX (Theory)
					FROM Mark
					WHERE (SubjectID = 'S001'))
--cau12-dua ra ten mon hoc duoc nhieu sinh vien dang ki nhat//chưa xong
SELECT SubjectName
FROM Mark
INNER JOIN Subjects ON Subjects.SubjectID = Mark.SubjectID
WHERE SubjectID IN (SELECT SubjectID
					FROM Mark
					GROUP BY SubjectID
					HAVING COUNT(SubjectID) = (SELECT MAX(NHIEU SV DANG KI NHAT)
												FROM (SELECT SubjectID, COUNT(SubjectID) as 'NHIEU SV DANG KI NHAT'
														FROM Mark
														GROUP BY SubjectID)))