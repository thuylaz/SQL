use master
go
if(exists (select *from sysdatabases where  name ='Quanlibv'))
drop database Quanlibv
go
create database Quanlibv
on primary (name='Quanlibv_dat', filename='E:\Quanlibv.mdf',size=5MB, maxsize=10MB, filegrowth=20%)
log on (name='Quanlibv_log', filename='E:\Quanlibv.ldf',size=1MB, maxsize=5MB, filegrowth=1MB)
go
use Quanlibv
go
create table dv
(
madv INT PRIMARY KEY,
tendv NVARCHAR(100),
gia float
)
go
create table benhnhan
(
	mabn int primary key,
	hoten nvarchar(100) not null,
	ngaysinh date,
	gioitinh bit
)
go
create table phieukham
(
	sophieu INT,
	madv INT,
	mabn INT,
	ngay DATE,
	sl INT,
	PRIMARY KEY(sophieu,madv),
	CONSTRAINT fk_1 FOREIGN KEY(mabn) REFERENCES benhnhan(mabn) ON UPDATE CASCADE ON DELETE CASCADE
)
go

insert into dv values(1,'tai mui hong',200)
insert into dv values(2,'rang ham mat',300)
go
insert into benhnhan values(1,'nguyen thi hoa','1/1/1995',0)
insert into benhnhan values(2,'nguyen van tuan','1/2/1995',0)
insert into benhnhan values(3,'le thi ly','1/10/1996',0)
insert into benhnhan values(4,'vu van hoang','12/11/1995',1)
insert into benhnhan values(5,'ly thi lan','1/7/1997',0)
insert into benhnhan values(6,'nguyen ngoc loan','7/1/1994',0)
insert into benhnhan values(7,'nguyen van hung','1/12/1995',1)
go
insert into phieukham values(1,1,1,'11-10-2017',3)
insert into phieukham values(2,2,2,'12-10-2017',4)

go 
select*from dv
select*from dbo.phieukham
select*from benhnhan
go
--cau2
GO 
SELECT mabn,YEAR(GETDATE())-YEAR(ngaysinh) AS N'Tuổi' FROM dbo.benhnhan 
WHERE YEAR(GETDATE())-YEAR(ngaysinh)=
(SELECT MAX(YEAR(GETDATE())-YEAR(ngaysinh)) FROM dbo.benhnhan)
GO 
-- câu 3:
GO 
CREATE FUNCTION cau3(@mabn int)
RETURNS @table TABLE(mabn INT,hoten NVARCHAR(100),ngaysinh DATE,gioitinh NVARCHAR(5))
AS
BEGIN
	INSERT INTO @table 
	SELECT mabn,hoten,ngaysinh,CASE gioitinh
	WHEN 0 THEN N'Nữ'
	WHEN 1 THEN N'Nam'
	end
	 FROM dbo.benhnhan
RETURN
END 
GO 
-- test câu 3:
GO 
SELECT * FROM dbo.cau3(1)
-- câu 4:
GO 
CREATE TRIGGER cau4
ON benhnhan 
FOR INSERT 
AS 
BEGIN
	DECLARE @ngay DATE = (SELECT ngaysinh FROM Inserted)
	DECLARE @kt DATE = (SELECT FORMAT(GETDATE(),'yyyy-MM-dd'))
	IF (@ngay>@kt)
	BEGIN 
		RAISERROR(N'phải nhập ngày nhỏ hơn ngày hiện tại',16,1)
		ROLLBACK TRANSACTION
	END 
	ELSE PRINT (N'thêm mới thành công')
END 
GO 
-- test câu 4:
GO 
SELECT * FROM dbo.benhnhan
GO 
INSERT INTO benhnhan VALUES(34,N'nam trần','12-08-2017',1)
INSERT INTO benhnhan VALUES(35,N'nam trần','12-15-2017',1)
GO 
SELECT * FROM dbo.benhnhan
