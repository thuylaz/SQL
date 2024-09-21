create database QLKHO

--a. Tạo CSDL QLKHO gồm 3 bảng
create  table Ton
(
MaVT nchar(10) not null primary key,
TenVT nvarchar(20) not null,
SoLuongT int
)
create table Nhap
(
SoHDN nchar(10) not null,
MaVT nchar(10) not null,
SoLuongN int,
DonGiaN money,
NgayN datetime
constraint Pk_N primary key(SoHDN,MaVT),
constraint Fk_Ton_N foreign key (MaVT) references Ton(MaVT)
)
create table Xuat
(
SoHDX nchar(10) not null,
MaVT nchar(10) not null,
SoLuongX int,
DonGiaX money ,
NgayX datetime,
constraint Pk_X_T primary key(SoHDX,MaVT),
constraint Fk_X_T foreign key (MaVT) references Ton(MaVT)
)

--b,c. 3 phiếu nhập, 2 phiếu xuất, 5 vật tư khác nhau
insert into Ton 
values  ('vt1', 'a', 1),
		('vt2', 'b', 4),
		('vt3', 'c', 2),
		('vt4', 'd', 2),
		('vt5', 'e', 1)

insert into Nhap 
values	('p1', 'vt1', 3, 100000, '01/01/2020'),
		('p2', 'vt2', 1, 200000, '02/01/2020'),
		('p3', 'vt4', 2, 300000, '03/01/2020')

insert into Xuat
values 
		('p1', 'vt3', 3, 50000, '01/01/2020'),
		('p2', 'vt4', 1, 200000, '02/01/2020')

select * from Ton
select * from Nhap
select * from Xuat

--d. Xóa các vật tư có DonGiaX < DonGiaN
delete	from Ton 
		from Nhap
inner join Ton on  Nhap.MaVT=Ton.MaVT
inner join Xuat  on Xuat.MaVT =Ton.MaVT
where  DonGiaX<DonGiaN
alter table Ton nocheck constraint all
alter table Nhap nocheck constraint all
alter table Xuat nocheck constraint all

alter table Ton check constraint all
alter table Nhap check constraint all
alter table Xuat check constraint all

--e. Cập nhật NgayX = NgayN nếu NgayX < NgayN của các mặt hàng có MaVT giống nhau 
update Xuat 
set NgayX= NgayN from Xuat 
inner Join Ton on Xuat.MaVT=Ton.MaVT
inner join Nhap on Nhap.MaVT= Ton.MaVT
where NgayX < NgayN and Xuat.MaVT in 
(select Nhap.MaVT from Nhap 
inner join Ton on Nhap.MaVT =Ton.MaVT
inner join Xuat on Xuat.MaVT=Ton.MaVT)