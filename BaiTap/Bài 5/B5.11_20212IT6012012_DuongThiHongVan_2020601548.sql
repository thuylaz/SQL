use master
go
if(exists(select * from sysdatabases where name='QLKHO'))
	drop database QLKHO
go
/* create database*/
create database QLKHO
go
use QLKHO
go
/*create table*/
create table Ton
(
	MaVT char(10) not null primary key,
	TenVT nvarchar(30),
	SoLuongT int default 0
)
create table Nhap
(
	SoHDN nchar(10) not null,
	MaVT char(10) not null foreign key (MaVT) references Ton(MaVT) on update cascade on delete cascade,
	SoLuongN int,
	DonGiaN money default 0,
	NgayN datetime,
	Primary Key(SoHDN, MaVT)
)
create table Xuat
(
	SoHDX nchar(10) not null,
	MaVT char(10) not null foreign key (MaVT) references Ton(MaVT) on update cascade on delete cascade,
	SoLuongX int,
	DonGiaX money default 0,
	NgayX datetime,
	Primary Key(SoHDX, MaVT)
)
go
-- insert 
insert into Ton
values ('VT0001',N'Ống đồng',100),
		('VT0002',N'Ống thép D6',0),
		('VT0003',N'Ống thép D8',200),
		('VT0004',N'Thép lá',50),
		('VT0005',N'Thép U',90)
go

insert into Nhap
values('HDN0001','VT0001', 380, 50000, '1/20/2015'),
		('HDN0001','VT0004', 100, 18000, '1/20/2015'),
		('HDN0002','VT0005', 150, 30000, '2/1/2015'),
		('HDN0003','VT0003', 500, 85000, '3/22/2016'),
		('HDN0003','VT0001', 200, 52000, '3/22/2016')
insert into Xuat
values('HDX0001','VT0001', 10, 55000, '4/3/2015'),
		('HDX0001','VT0005', 52, 22000, '4/3/2015'),
		('HDX0002','VT0001', 50, 56000, '5/12/2020'),
		('HDX0002','VT0003', 150, 35000, '5/12/2020')
go
--test
select * from Ton
select * from Nhap
select * from Xuat
go
--2.Thống kê tiền bán theo mã vật tư gồm MaVT, TenVT, TienBan (TienBan=SoLuongX*DonGiaX)
create view TienBanVatTu
as
select Ton.MaVT, TenVT, SUM(SoLuongX*DonGiaX) as N'Tiền bán'
from Ton inner join Xuat on Ton.MaVT=Xuat.MaVT
group by Ton.MaVT, TenVT
go
select * from TienBanVatTu
go

--3.Thống kê soluongxuat theo tên vattu
create view VatTuDaXuat
as
select TenVT, sum(SoLuongX) as N'SL Xuất'
from Ton inner join Xuat on Ton.MaVT=Xuat.MaVT
group by TenVT
go
select * from VatTuDaXuat
go

--4. thống kê soluongnhap theo tên vật tư
create view VatTuDaNhap
as
select TenVT, sum(SoLuongN) as N'SL Nhập'
from Ton inner join Nhap on Ton.MaVT=Nhap.MaVT
group by TenVT
go
select * from VatTuDaNhap
go

--5. đưa ra tổng soluong còn trong kho  biết còn = nhap – xuất + tồn theo từng nhóm vật tư
create view SLVatTuCon
as
select Ton.MaVT, TenVT, sum(SoLuongN)-SUM(SoLuongX)+ sum(SoLuongT) as 'SoLuongCon'
from Ton inner join Nhap on Ton.MaVT=Nhap.MaVT
		 inner join Xuat on Ton.MaVT=Xuat.MaVT
group by Ton.MaVT, TenVT
go
select * from SLVatTuCon
go
