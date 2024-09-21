use master
go
if(exists(select * from sysdatabases where name='QLBenhvien'))
	drop database QLBenhvien
go
create database QLBenhvien
on primary(name='QLBenhvien_dat',filename='E:\QLBenhvien.mdf',size=5MB,maxsize=10MB,filegrowth=20%)
log on(name='QLBenhvien_log',filename='E:\QLBenhvien.ldf',size=1MB,maxsize=5MB,filegrowth=1MB)
go
use QLBenhvien
go
create table benhvien
(
	mabv int not null primary key,
	tenbv nvarchar(100) not null
)
create table khoakham
(
	makhoa int not null primary key,
	tenkhoa nvarchar(100) not null,
	sobn int,
	mabv int,
	constraint fk1 foreign key(mabv) references benhvien(mabv) on update cascade on delete cascade
)
create table benhnhan
(
	mabn int not null primary key,
	hoten nvarchar(100) not null,
	ngaysinh date,
	gioitinh bit,
	songaynv int,
	makhoa int,
	constraint fk2 foreign key(makhoa) references khoakham(makhoa) on update cascade on delete cascade
)
go
insert into benhvien values(1,'bach mai')
insert into benhvien values(2,'hoai duc')
go
insert into khoakham values(1,'than kinh',4,1)
INSERT INTO Khoakham VALUES(2,'Tieu hoa',3,2)
GO 
INSERT INTO benhnhan VALUES(1,'Nguyen trai','12-08-1997',1,10,2)
INSERT INTO benhnhan VALUES(2,'Nguyen ty','12-08-1997',0,11,1)
INSERT INTO benhnhan VALUES(3,'Nguyen binh','12-08-1997',0,12,2)
INSERT INTO benhnhan VALUES(4,'Nguyen trai','12-08-1997',0,12,2)
INSERT INTO benhnhan VALUES(5,'Nguyen du','12-08-1997',1,14,1)
INSERT INTO benhnhan VALUES(6,'Nguyen hue','12-08-1997',0,15,1)
INSERT INTO benhnhan VALUES(7,'Nguyen trung','12-08-1997',0,13,1)
GO 

SELECT * FROM dbo.benhvien
SELECT * FROM dbo.khoakham
SELECT * FROM dbo.benhnhan

GO 
-- cau2:
CREATE VIEW cau_2
AS
	SELECT dbo.khoakham.makhoa,dbo.khoakham.tenkhoa,COUNT(dbo.benhnhan.mabn) AS N'Số bệnh nhân'
	FROM dbo.benhnhan INNER JOIN dbo.khoakham ON khoakham.makhoa = benhnhan.makhoa
	WHERE gioitinh=0
	GROUP BY dbo.khoakham.makhoa,dbo.khoakham.tenkhoa
GO 
---test câu 2:
SELECT * FROM dbo.cau_2

GO 
-- cau 3:
CREATE PROCEDURE cau3(@makhoa INT,@tongtien INT OUTPUT)
AS
BEGIN
	SELECT @tongtien = SUM(dbo.benhnhan.songaynv*80000)
	FROM dbo.benhnhan INNER JOIN dbo.khoakham ON khoakham.makhoa = benhnhan.makhoa
	WHERE benhnhan.makhoa=@makhoa
	GROUP BY dbo.benhnhan.makhoa
	RETURN @tongtien
END 
GO 
--test câu 3:
DECLARE @tongtien INT =0
EXEC cau3 1,@tongtien
SELECT @tongtien
GO 
-- cau4:
CREATE TRIGGER cau4
ON dbo.benhnhan
FOR INSERT
AS
	BEGIN
    DECLARE @makhoa INT = (SELECT makhoa FROM Inserted)
	DECLARE @sobn INT = (SELECT sobn FROM dbo.khoakham WHERE makhoa=@makhoa)
	IF(@sobn>100)
	BEGIN
		RAISERROR(N'Số bệnh nhân đã quá 100 rồi',16,1)
		ROLLBACK TRANSACTION
	END 
	ELSE 
	BEGIN 
		UPDATE dbo.khoakham
		SET sobn=@sobn+1
		WHERE makhoa=@makhoa
	END 
	END
 GO 
 --test câu 4:
 SELECT * FROM dbo.benhnhan
 SELECT * FROM dbo.khoakham
 GO
 INSERT INTO benhnhan VALUES(10,N'Cao trung','10-10-1997',1,10,1)
 GO 
 SELECT * FROM dbo.benhnhan
 SELECT * FROM dbo.khoakham