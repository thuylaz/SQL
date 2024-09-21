use master
go
if(exists (select *from sysdatabases where  name ='QLibvien'))
drop database QLibvien
go
create database QLibvien
on primary (name='QLibvien_dat', filename='E:\QLibvien.mdf',size=5MB, maxsize=10MB, filegrowth=20%)
log on (name='QLibvien_log', filename='E:\QLibvien.ldf',size=1MB, maxsize=5MB, filegrowth=1MB)
go
use QLibvien
go
create table benhvien
(
mabv int primary key,
tenbv char(100) not null,
)

go

create table khoakham
(
	makhoa int primary key,
	tenkhoa char(100) not null,
	sobn int not null,
	mabv int,
	constraint fk1 foreign key (mabv) references benhvien(mabv) on update cascade on delete cascade
)
go

create table benhnhan
(
	mabn int primary key,
	hoten char(100) not null,
	ngaysinh datetime,
	gioitinh bit,
	songaynhapvien int,
	makhoa int,
	constraint fk2 foreign key (makhoa) references khoakham(makhoa) on update cascade on delete cascade
)
go

insert into benhvien values(1,'bach mai')
insert into benhvien values(2,'san nhi')
go
insert into khoakham values(1,'rang-ham-mat',100,1)
insert into khoakham values(2,'tai-mui-hong',150,2)
go
insert into benhnhan values(1,'nguyen thi hoa','1/1/1995',0,20,1)
insert into benhnhan values(2,'nguyen van tuan','1/2/1995',1,25,1)
insert into benhnhan values(3,'le thi ly','1/10/1996',0,5,2)
insert into benhnhan values(4,'vu van hoang','12/11/1995',1,10,2)
insert into benhnhan values(5,'ly thi lan','1/7/1997',0,3,1)
insert into benhnhan values(6,'nguyen ngoc loan','7/1/1995',0,2,1)
insert into benhnhan values(7,'nguyen van hung','1/12/1995',1,11,2)
go 
select*from benhvien
select*from khoakham
select*from benhnhan
go
--cau2--
select mabn, hoten, max(YEAR(getdate())-YEAR(ngaysinh)) as tuoi
from benhnhan
where YEAR(getdate())-YEAR(ngaysinh)=(select   max(YEAR(getdate())-YEAR(ngaysinh)) from benhnhan)
group by mabn, hoten
GO 
--câu 3:
GO 
CREATE FUNCTION cau_3(@mabn int)
RETURNS @table TABLE(mabn INT,hoten NVARCHAR(100),ngaysinh DATE,gioitinh NVARCHAR(3),tenkhoa NVARCHAR(100),tenbv NVARCHAR(100))
AS
BEGIN
	INSERT INTO @table 
	SELECT dbo.benhnhan.mabn,hoten,ngaysinh,CASE gioitinh 
	WHEN 0 THEN N'Nữ'
	WHEN 1 THEN N'Nam'
	END,tenkhoa,tenbv
	FROM dbo.benhnhan INNER JOIN dbo.khoakham ON khoakham.makhoa = benhnhan.makhoa
	INNER JOIN dbo.benhvien ON benhvien.mabv = khoakham.mabv
	WHERE dbo.benhnhan.mabn=@mabn
	RETURN;
END 
-- test câu 3:
GO 
SELECT * FROM dbo.cau_3(1)
GO
-- câu 4:
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

