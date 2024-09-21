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
	hoten char(100) not null,
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
insert into benhnhan values(6,'nguyen ngoc loan','7/1/1995',0)
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
CREATE VIEW cau2
AS
SELECT ngay,N'Nữ' AS gioitinh,COUNT(benhnhan.mabn) AS soluong
FROM dbo.benhnhan INNER JOIN dbo.phieukham ON phieukham.mabn = benhnhan.mabn
WHERE gioitinh=0
GROUP BY ngay
-- test câu 2:
GO 
SELECT * FROM cau2
GO 

-- câu 3:
GO 
CREATE PROCEDURE cau3(@ngay DATE,@tongtien INT OUTPUT)
AS 
BEGIN
	SELECT @tongtien = SUM(sl*gia) 
	FROM dbo.phieukham INNER JOIN dbo.dv ON dv.madv = phieukham.madv
	WHERE ngay=@ngay
	GROUP BY ngay
	RETURN @tongtien
END 
GO 
--test câu 3:
GO 
DECLARE @tongtien INT =0
EXEC cau3 '12-10-2017',@tongtien OUTPUT
SELECT @tongtien AS N'Tổng tiền'
GO 
-- câu 4:
GO 
CREATE TRIGGER cau4
ON dbo.phieukham
FOR INSERT
AS
BEGIN
	DECLARE @ngay DATE = (SELECT ngay FROM Inserted)
	DECLARE @kt DATE = (SELECT FORMAT(GetDate(), 'yyyy-MM-dd'))
	IF(@ngay!=@kt)
	BEGIN
		RAISERROR(N'Không thể thêm, vì không bằng ngày hiện tại',16,1)
		ROLLBACK TRANSACTION
    END 
	ELSE 
		PRINT N'Thêm thành công phiếu khám'
END
GO 
-- test câu 4:
GO 
SELECT * FROM dbo.phieukham
GO 
INSERT INTO phieukham VALUES(10,1,1,'12-08-2017',10)
INSERT INTO phieukham VALUES(11,2,1,'11-08-2017',11)
GO 
SELECT * FROM dbo.phieukham
GO 

