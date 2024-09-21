use master
go
if(exists (select *from sysdatabases where  name ='Qlkho'))
drop database Qlkho
go
create database Qlkho
on primary (name='Qlkho_dat', filename='E:\Qlkho.mdf',size=5MB, maxsize=10MB, filegrowth=20%)
log on (name='Qlkho_log', filename='E:\Qlkho.ldf',size=1MB, maxsize=5MB, filegrowth=1MB)
go
use Qlkho
go
create table ton
(
	 mavt int primary key,
	 tenvt char(100) not null,
	 soluongton int not null,
)
	
go
create table nhap
(
	sohdn int,
	mavt int,
	soluongnhap int not null,
	dongianhap float not null,
	ngaynhap date,
	PRIMARY KEY(sohdn,mavt),
	constraint fk1 foreign key (mavt) references ton(mavt) on update cascade on delete cascade
)
go
create table xuat
(
	sohdx int,
	mavt int,
	soluongxuat int not null,
	dongiaxuat float not null,
	ngayxuat date,
	PRIMARY KEY(sohdx,mavt),
	constraint fk2 foreign key (mavt) references ton(mavt) on update cascade on delete cascade
)
go
insert into ton values(1,'thep',1000)
insert into ton values(2,'kinh', 200)
insert into ton values(3,'gach', 44400)
insert into ton values(4,'xi mang', 300)
insert into ton values(5,'ngoi', 2000)
go
insert into nhap values(1,2,2000,45577,'1/1/2017')
insert into nhap values(2,1,1500,40000,'1/4/2017')
insert into nhap values(3,5,10000,43227,'2/1/2017')
go
insert into xuat values(1,1,200,30000,'2/3/2017')
insert into xuat values(2,2,120,3000,'2/6/2017')
insert into xuat values(1,2,200,30000,'2/3/2017')
insert into xuat values(2,1,120,3000,'2/6/2017')
go
select*from ton
select*from nhap
select*from xuat
go
--cau2--
create view cau2
as
select xuat.mavt,tenvt,SUM(soluongxuat*dongiaxuat) as tienban
from xuat inner join ton on xuat.mavt=ton.mavt
group by xuat.mavt,tenvt
GO
-- test câu 2:
select *from cau2

-- câu 3:
GO 
CREATE FUNCTION cau3(@mavt int)
RETURNS @table TABLE(mavt INT,tenvt NVARCHAR(100),tienban INT)
AS 
BEGIN
	INSERT INTO @table 
	SELECT ton.mavt,ton.tenvt,SUM(soluongxuat*dongiaxuat)
	 FROM dbo.xuat INNER JOIN dbo.ton ON ton.mavt = xuat.mavt
	 WHERE ton.mavt=@mavt
	GROUP BY ton.mavt,ton.tenvt
	RETURN
END 
-- test câu 3:
GO 
SELECT * FROM dbo.cau3(1)
GO 
-- câu 4:
GO 
-- đang trong quá trình thử nghiệm