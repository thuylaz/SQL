use master
go
if(exists(select * from sysdatabases where name='QLBanhang'))
	drop database QLBanhang
go
create database QLBanhang
on primary(name='QLBanhang_dat',filename='E:\QLBanhang_mlf',size=5MB,maxsize=10MB,filegrowth=20%)
log on(name='QLBanhang_log',filename='E:\QLBanhang_ldf',size=1MB,maxsize=5MB,filegrowth=1MB)
go
use QLBanhang
go
create table Hang
(
	mahang int not null primary key,
	tenhang nvarchar(100) not null,
	DVtinh char(10) not null,
	slton int
)
GO 
create table HDBan
(
	mahd int not null primary key,
	ngayban date,
	tenkhach nvarchar(100) not null
)
GO 
create table HangBan
(	
	mahd int not null,
	mahang int not null,
	dongia float,
	soluong int,
	constraint pk1 primary key(mahd,mahang),
	constraint fk1 foreign key(mahd) references HDBan(mahd) on update cascade on delete cascade,
	constraint fk2 foreign key(mahang) references Hang(mahang) on update cascade on delete cascade
)
go
insert into Hang values(1,'ti vi','kg',34)
insert into Hang values(2,'tu lanh','lit',20)
go
insert into HDBan values(1,'2/1/2011','nguyen thi my linh')
insert into HDBan values(2,'4/5/2013','nguyen ngoc anh')
go
insert into HangBan values(1,2,30000,50)
insert into HangBan values(1,1,40000,60)
insert into HangBan values(2,2,30000,45)
insert into HangBan values(2,1,40000,70)
go
select * from Hang
select * from HDBan
select * from HangBan
go
----cau2
CREATE VIEW cau_2
AS
SELECT dbo.HDBan.mahd,SUM(dbo.HangBan.soluong*dbo.HangBan.dongia) AS N'tổng tiền'
FROM dbo.HangBan INNER JOIN dbo.HDBan ON HDBan.mahd = HangBan.mahd
GROUP BY dbo.HDBan.mahd
HAVING SUM(dbo.HangBan.soluong*dbo.HangBan.dongia)>1000000
GO 
-- test câu 2:
SELECT * FROM dbo.cau_2
GO 
-- câu 3:
CREATE PROCEDURE cau3(@mahang INT)
AS
BEGIN
	IF (EXISTS(SELECT * FROM dbo.Hang WHERE mahang=@mahang))
		BEGIN
			DELETE FROM dbo.HangBan
			WHERE mahang=@mahang
			DELETE FROM dbo.Hang
			WHERE mahang=@mahang
		END 
	ELSE PRINT(N'mã hàng '+@mahang+' không tồn tại')
END 
GO 
-- test câu 3:
GO 
SELECT * FROM dbo.HangBan
SELECT * FROM dbo.Hang
GO
EXEC dbo.cau3 @mahang = 1 
GO 
SELECT * FROM dbo.HangBan
SELECT * FROM dbo.Hang
GO 
-- câu 4:
GO 
CREATE TRIGGER cau4
ON dbo.HDBan
FOR INSERT
AS
 BEGIN
	DECLARE @ngay DATE = (SELECT ngayban FROM Inserted)
	DECLARE @kt DATE = (SELECT FORMAT(GETDATE(),'yyyy-MM-dd'))
	IF(@ngay!=@kt)
	BEGIN 
		RAISERROR(N'Ngày bán không phải là ngày hiện tại',16,1)
		ROLLBACK TRANSACTION
	END 
	ELSE PRINT(N'Thêm mới thành công')
 END 
 GO 
 -- test câu 4:
 GO 
 SELECT * FROM dbo.HDBan
 GO 
 INSERT INTO HDban VALUES(11,'12-09-2017',N'Steve jobs')
 INSERT INTO HDban VALUES(13,'12-10-2017',N'Steve jobs')
 GO 
  SELECT * FROM dbo.HDBan