use master
go
if(exists(select * from sysdatabases where name='QLBanHang'))
	drop database QLBanHang
go
/* create database*/
create database QLBanHang
go

use QLBanHang
go

/* create table*/
create table HANGSX
(
MaHangSX nchar(10) primary key,
TenHang nvarchar(20) not null,
DiaChi nvarchar(30) not null default N'Hà Nội',
SoDT nvarchar(20),
Email nvarchar(30)
)

create table SANPHAM
(
MaSP nchar(10) not null primary key,
MaHangSX nchar(10) not null foreign key(MaHangSX) references HangSX(MaHangSX) on update cascade on delete cascade,
TenSP nvarchar(20),
SoLuong int,
MauSac nvarchar(20),
GiaBan money,
DonViTinh nvarchar(20),
MoTa nvarchar(MAX),
)
create table NHANVIEN
(
MaNV nchar(10) not null primary key,
TenNV nvarchar(20) not null,
GioiTinh nchar(10),
DiaChi nvarchar(30),
SoDT nvarchar(20) not null unique,
Email nvarchar(30),
TenPhong nvarchar(30)
)
create table PNHAP
(
SoHDN nchar(10) not null primary key,
NgayNhap date,
MaNV nchar(10) foreign key(MaNV) references NHANVIEN(MaNV) on update cascade on delete cascade
)
create table NHAP
(
SoHDN nchar(10) not null foreign key(SoHDN) references PNHAP(SoHDN),
MaSP nchar(10) not null foreign key(MaSP) references SANPHAM(MaSP) on update cascade on delete cascade,
SoLuongN int check (SoLuongN>2),
DonGiaN money,
primary key(SoHDN,MaSP)
)
create table PXUAT
(
SoHDX nchar(10) not null primary key,
NgayXuat date not null default getdate(),
MaNV nchar(10) not null foreign key(MaNV) references NHANVIEN(MaNV) on update cascade on delete cascade
)
create table XUAT
(
SoHDX nchar(10) not null foreign key(SoHDX) references PXUAT(SoHDX) on update cascade on delete cascade,
MaSP nchar(10) not null foreign key(MaSP) references SANPHAM(MaSP) on update cascade on delete cascade,
SoLuongX int
primary key(SoHDX,MaSP)
)
go
/* insert data*/
insert into HANGSX 
values('H01', 'SamSung', 'Korea', '011-08271212', 'ss@gmail.com.kr'),
	  ('H02', 'OPPO', 'China', '086-082613122', 'opp0@gmail.com.cn'),
	  ('H03', 'Vsmart', N'Việt Nam', '084-01091997', 'vsmart@gmail.com.vn'),
	  ('H04', 'IPHONE', N'MỸ', '086-082613123', 'ipp0@gmail.com.cn')

insert into SANPHAM
 values('SP01', 'H02', 'F1 Plus', '100', N'Xám', '7000000', N'Chiếc', N'Hàng cận cao cấp'), 
       ('SP02', 'H01', 'Galaxy Note 11', '50', N'Đỏ', '19000000', N'Chiếc', N'Hàng cao cấp'),
	   ('SP03', 'H02', 'F3 lite', '200', N'Nâu', '3000000', N'Chiếc', N'Hàng phổ thông'),
       ('SP04', 'H03', 'Joy3', '200', N'Xám', '3500000', N'Chiếc', N'Hàng phổ thông'),
       ('SP05', 'H01', 'Galaxy V21', '500', N'Nâu', '8000000', N'Chiếc', N'Hàng cận cao cấp') 

insert into NHANVIEN 
values('NV01', N'Nguyễn Thị Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@gmail.com', N'Kế toán'), 
      ('NV02', N'Lê Văn Nam', N'Nam', N'Bắc Ninh', '0972525252 ', 'nam@gmail.com', N'Vật tư'), 
      ('NV03', N'Trần Hòa Bình', N'Nữ', N'Hà Nội', '0328388388 ', 'hb@gmail.com', N'Kế toán'),
	  ('NV04', N'Lê Văn Minh', N'Nam', N'Hồ Chí Minh', '0974525252 ', 'nam@gmail.com', N'Vật tư') 

insert into PNHAP 
values('N01', '02-05-2019', 'NV01'),
      ('N02', '04-07-2020', 'NV02'),
      ('N03', '05-17-2020', 'NV02'),
      ('N04', '03-22-2020', 'NV03'),
      ('N05', '07-07-2020', 'NV01')

insert into NHAP 
values('N01', 'SP02', '10', '17000000'),
      ('N02', 'SP01', '30', '6000000'),
      ('N03', 'SP04', '20', '1200000'),
      ('N04', 'SP01', '10', '6200000'),
      ('N05', 'SP05', '20', '7000000')

insert into PXUAT 
values('X01', '06-14-2020', 'NV02'),
      ('X02', '03-05-2019', 'NV03'),
      ('X03', '12-14-2020', 'NV01'),
      ('X04', '06-02-2020', 'NV02'),
      ('X05', '05-15-2020', 'NV01')

insert into XUAT 
values('X01', 'SP03', '50'),
      ('X02', 'SP01', '30'),
      ('X03', 'SP02', '10'),
      ('X04', 'SP03', '20'),
      ('X05', 'SP05', '10')
go 

 -- test
 select * from HANGSX
 select * from SANPHAM
 select * from NHANVIEN
 select * from PNHAP
 select * from NHAP
 select * from PXUAT
 select * from XUAT
 go
 --a,Hãy Đưa ra tổng tiền nhập của mỗi nhân viên trong tháng 5 – năm 2020 có tổng
--giá trị lớn hơn 100.000
select sum(SoLuongN*DonGiaN) as 'Tong so tien nhap', MaNV
from Nhap inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
where year(NgayNhap)=2020 and month(NgayNhap)=5
group by MaNV
having sum(SoLuongN*DonGiaN) >100000
--b,Hãy Đưa ra danh sách các sản phẩm đã nhập nhưng chưa xuất bao giờ.
select SanPham.MaSP,TenSP
From SanPham Inner join nhap on SanPham.MaSP = nhap.MaSP
Where SanPham.MaSP Not In (Select MaSP From Xuat)
--c,Hãy Đưa ra danh sách các sản phẩm đã nhập năm 2020 và đã xuất năm 2020.
select SanPham.MaSP, TenSP
from SanPham inner join Nhap on SanPham.MaSP=Nhap.MaSP
			 inner join Xuat on SanPham.MaSP=Xuat.MaSP
where SanPham.MaSP in (select Xuat.MaSP from Xuat 
                       inner join Pxuat on Xuat.SoHDX=Pxuat.SoHDX
					   where year(NgayXuat)=2020 and Xuat.MaSP in
					   (select Nhap.MaSP from Nhap 
					   inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
					   where year(NgayNhap)=2020)
                     )
--d,Hãy Đưa ra danh sách các nhân viên vừa nhập vừa xuất.
select NhanVien.MaNV, TenNV
from NhanVien inner join PNhap on PNhap.MaNV=NhanVien.MaNV
			  inner join Pxuat on NhanVien.MaNV=Pxuat.MaNV
where NhanVien.MaNV in (select PNhap.MaNV from PNhap
                         inner join Pxuat on PNhap.MaNV=Pxuat.MaNV
						 where PNhap.MaNV in
						 (select Pxuat.MaNV from Pxuat)
						 )
--e,Hãy Đưa ra danh sách các nhân viên không tham gia việc nhập và xuất.
select NhanVien.MaNV, TenNV
from NhanVien inner join PNhap on PNhap.MaNV=NhanVien.MaNV
			  inner join Pxuat on NhanVien.MaNV=Pxuat.MaNV
where NhanVien.MaNV not in (select PNhap.MaNV from PNhap
                         inner join Pxuat on PNhap.MaNV=Pxuat.MaNV
						 where PNhap.MaNV in
						 (select Pxuat.MaNV from Pxuat)
						 )