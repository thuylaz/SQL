use master
go
if(exists(select * from sysdatabases where name='QLHang'))
	drop database QLHang
go
create database QLHang
on primary(name='QLHang_dat',filename='E:\QLHang_mdf',size=5MB,maxsize=10MB,filegrowth=20%)
log on(name='QLHang_log',filename='E:\QLHang_ldf',size=1MB,maxsize=5MB,filegrowth=1MB)
go
use QLHang
GO 

create table vattu
(
	mavt int not null primary key,
	tenvt nvarchar(100) not null,
	DVtinh char(10) not null,
	slcon int
)
GO 
create table hdban
(
	mahd int not null primary key,
	ngayxuat date,
	tenkhach nvarchar(100)
)
GO 
create table hangxuat
(	
	mahd int,
	mavt int,
	dongia float,
	slban int,
	constraint pk1 primary key(mahd,mavt),
	constraint fk1 foreign key(mahd) references hdban(mahd) on update cascade on delete cascade,
	constraint fk2 foreign key(mavt) references vattu(mavt) on update cascade on delete cascade
)
GO 
insert into vattu values(1,'tu lanh','lit',30)
insert into vattu values(2,'may giat','kg',25)
GO 
insert into hdban values(1,'12/08/2017','nguyen thi my linh')
insert into hdban values(2,'12/09/2017','nguyen ngoc anh')
GO 
insert into hangxuat values(1,1,3000,40)
insert into hangxuat values(1,2,4000,60)
insert into hangxuat values(2,1,3000,70)
insert into hangxuat values(2,2,4000,50)
GO 
select * from vattu
select * from hdban
select * from hangxuat
go

-------cau2

GO 
CREATE FUNCTION cau_3(@mahd int)
RETURNS @cau_3 TABLE(mahd INT,ngayxuat DATE,mavt INT,dongia FLOAT,solban INT,ngaythu NVARCHAR(20))
AS
BEGIN
	--thu_2
	INSERT INTO @cau_3 
	SELECT dbo.hdban.mahd,dbo.hdban.ngayxuat,dbo.vattu.mavt,dbo.hangxuat.dongia,dbo.hangxuat.slban, CASE DATEPART(WEEKDAY,ngayxuat)
	WHEN 2 THEN N'Thứ hai'
	WHEN 3 THEN N'Thứ ba'
	WHEN 4 THEN N'Thứ tư'
	WHEN 5 THEN N'Thứ năm'
	WHEN 6 THEN N'Thứ sáu'
	WHEN 7 THEN N'Thứ bảy'
	WHEN 8 THEN N'chủ nhật'
	END 
	 FROM dbo.hangxuat INNER JOIN dbo.vattu ON vattu.mavt = hangxuat.mavt
	INNER JOIN dbo.hdban ON hdban.mahd = hangxuat.mahd
	WHERE  dbo.hdban.mahd=@mahd
	RETURN
END 

go
SELECT * FROM cau_3(1)
GO

-- câu 3 đề 5: vì là database giống nhau nên làm chung
GO 
CREATE FUNCTION cau_3_de5(@year int)
RETURNS int 
AS
BEGIN

	DECLARE @tongtien INT =0
		SELECT @tongtien =  SUM(dbo.hangxuat.dongia*dbo.hangxuat.slban)
		FROM dbo.hangxuat INNER JOIN dbo.hdban ON hdban.mahd = hangxuat.mahd
		WHERE DATEPART(yy,ngayxuat)=@year
		GROUP BY DATEPART(yy,ngayxuat)
	RETURN @tongtien
END 

GO 
SELECT dbo.cau_3_de5(2010)

GO 
-- cau4:procedure tra ve gia tri

GO 
CREATE PROCEDURE cau_4(@thang INT,@nam INT,@tongtien INT OUTPUT)
AS
	BEGIN
	SELECT @tongtien = SUM(dbo.hangxuat.dongia*dbo.hangxuat.slban) 
	FROM dbo.hangxuat INNER JOIN dbo.hdban ON hdban.mahd = hangxuat.mahd
	INNER JOIN dbo.vattu ON vattu.mavt = hangxuat.mavt
	GROUP BY dbo.vattu.mavt
	RETURN @tongtien
	END 

GO 
DECLARE @kq INT =0
EXEC cau_4 12,2017,@kq OUTPUT
SELECT @kq AS N'Tổng tiền'
GO 
CREATE PROCEDURE cau_4_1(@thang INT,@nam INT)
AS
	BEGIN
		SELECT * FROM dbo.hdban WHERE DATEPART(mm,ngayxuat)=@thang AND DATEPART(yy,ngayxuat)=@nam
	END 
GO 
EXEC dbo.cau_4_1 12,2017


