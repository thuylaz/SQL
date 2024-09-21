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
insert into HangBan values(1,2,3000,50)
insert into HangBan values(1,1,4000,60)
insert into HangBan values(2,2,3000,45)
insert into HangBan values(2,1,4000,70)
go
select * from Hang
select * from HDBan
select * from HangBan
go
----cau2
select HangBan.mahd,HangBan.mahang,count(HangBan.mahang) as 'So mat hang'
from HangBan
group by HangBan.mahd,HangBan.mahang
having HangBan.mahang>1
GO
-- câu 3:
CREATE FUNCTION cau3(@nam int)
RETURNS INT
AS 
BEGIN
	DECLARE @tongtien INT =0
	SELECT @tongtien = SUM(dongia*soluong) 
	FROM dbo.hangban INNER JOIN dbo.HDBan ON HDBan.mahd = hangban.mahd
	WHERE YEAR(ngayban)=@nam
	GROUP BY YEAR(ngayban)
	RETURN @tongtien
END 
GO 
-- test câu 3:
SELECT dbo.cau3(2000) AS 'Tổng tiền'
GO 
--cau 4:
CREATE PROCEDURE cau3_de2(@thang INT,@nam INT)
AS
BEGIN
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
	
END 

GO 
--test cau 4:
EXEC dbo.cau3_de2 @thang = 4, -- int
    @nam =2013 -- int
GO 