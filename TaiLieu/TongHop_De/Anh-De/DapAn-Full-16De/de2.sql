use master
go
if(exists(select * from sysdatabases where name='QLBanHang'))
	drop database QLBanHang
go
create database QLBanHang
on primary(name='QLBanHang_dat',filename='E:\QLBanHang_mlf',size=5MB,maxsize=10MB,filegrowth=20%)
log on(name='QLBanHang_log',filename='E:\QLBanHang_ldf',size=1MB,maxsize=5MB,filegrowth=1MB)
go
use QLBanHang
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
insert into Hang values(1,'ti vi','cm',34)
insert into Hang values(2,'tu lanh','dm',20)
go
insert into HDBan values(1,'12/08/2017','nguyen thi my linh')
insert into HDBan values(2,'12/05/2017','nguyen ngoc anh')
go
insert into HangBan values(1,2,3000,4)
insert into HangBan values(2,2,3000,8)
go
select * from Hang
select * from HDBan
select * from HangBan
go

-----cau2
create view cau2
as
select HDBan.mahd,HDBan.ngayban,SUM(HangBan.dongia*HangBan.soluong) as 'tien hang ban'
from HangBan inner join HDBan on HangBan.mahd=HDBan.mahd
group by HDBan.mahd,HDBan.ngayban
go 
select * from cau2
go


--cau 3: tao procedure
GO 
/*procedure*/
CREATE PROCEDURE cau3_de2(@thang INT,@nam INT)
AS
BEGIN
	-- thu2
	--INSERT INTO @table
	SELECT dbo.Hang.mahang,dbo.Hang.tenhang,dbo.HDBan.ngayban,dbo.HangBan.soluong, CASE DATEPART(WEEKDAY,ngayban)
	WHEN 2 THEN N'Thứ hai' 
	WHEN 3 THEN N'Thứ ba'
	WHEN 4 THEN N'Thứ tư'
	WHEN 5 THEN N'Thứ năm'
	WHEN 6 THEN N'Thứ sáu'
	WHEN 7 THEN N'Thứ bảy'
	WHEN 8 THEN N'chủ nhật'
	END AS 'Ngày thứ'
	FROM dbo.HangBan INNER JOIN dbo.HDBan ON HDBan.mahd = HangBan.mahd
	INNER JOIN dbo.Hang ON Hang.mahang = HangBan.mahang
	WHERE   DATEPART(mm,ngayban)=@thang AND DATEPART(yy,ngayban)=@nam
	--thu3
	
END 

GO 

EXEC dbo.cau3_de2 @thang = 12, -- int
    @nam = 2017 -- int

GO 
-- function
CREATE FUNCTION cau3_de2_ham(@thang INT,@nam INT)
RETURNS @table TABLE(mahang INT,tenhang NVARCHAR(100),ngayban DATE,soluong INT,ngaythu NVARCHAR(100))
AS 
BEGIN
	-- thu2
	INSERT INTO @table
	SELECT dbo.Hang.mahang,dbo.Hang.tenhang,dbo.HDBan.ngayban,dbo.HangBan.soluong, CASE DATEPART(WEEKDAY,ngayban)
	WHEN 2 THEN N'Thứ hai' 
	WHEN 3 THEN N'Thứ ba'
	WHEN 4 THEN N'Thứ tư'
	WHEN 5 THEN N'Thứ năm'
	WHEN 6 THEN N'Thứ sáu'
	WHEN 7 THEN N'Thứ bảy'
	WHEN 8 THEN N'chủ nhật'
	END --AS 'Ngày thứ'
	FROM dbo.HangBan INNER JOIN dbo.HDBan ON HDBan.mahd = HangBan.mahd
	INNER JOIN dbo.Hang ON Hang.mahang = HangBan.mahang
	WHERE   DATEPART(mm,ngayban)=@thang AND DATEPART(yy,ngayban)=@nam
	--thu3
	RETURN
	
END 

GO

SELECT * FROM dbo.cau3_de2_ham(12,2017) 
-----cau3
/*
CREATE PROCEDURE cau_3(@thang INT,@nam int)
AS
BEGIN 
	DECLARE @wd INT 
	DECLARE @ngaythu NVARCHAR(10)
	SELECT h.mahang,h.tenhang,hd.ngayban,hb.soluong,@ngaythu AS N'Ngày thứ' FROM dbo.HangBan hb INNER JOIN dbo.Hang h
	ON hb.mahang=h.mahang INNER JOIN dbo.HDBan hd 
	ON hb.mahd = hd.mahd
	WHERE YEAR(hd.ngayban)=@nam AND MONTH(hd.ngayban)=@thang 
END 
GO 
*/
GO 
CREATE TRIGGER cau4
ON dbo.HangBan
FOR INSERT
AS
	BEGIN 

		DECLARE @mahang INT = (SELECT i.mahang FROM Inserted i)
		DECLARE @soluongt INT =(SELECT slton FROM dbo.Hang WHERE dbo.Hang.mahang=@mahang)
		DECLARE @soluong INT = (SELECT i.soluong FROM Inserted i)

		IF (@soluong>@soluongt)
		BEGIN
			RAISERROR(N'Số lượng phải nhỏ hơn số lượng tồn',16,1)
			ROLLBACK TRANSACTION
		END
		ELSE 
		BEGIN
			UPDATE dbo.Hang
			SET slton=@soluongt-@soluong
			WHERE mahang=@mahang
			PRINT N'Thành công update'
		END 
	END
 GO 

 SELECT * FROM  dbo.Hang
 SELECT * FROM dbo.HangBan
 GO 
insert into HangBan values(1,1,3000,8)
GO 
SELECT * FROM dbo.Hang
SELECT * FROM dbo.HangBan