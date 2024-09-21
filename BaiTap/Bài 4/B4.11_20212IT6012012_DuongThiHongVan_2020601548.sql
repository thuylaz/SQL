use master
go 
if(exists(select * from sysdatabases where name = 'QLBanHang'))
		drop database QLBanHang
go

/* create database */
create database QLBanHang
go
use QLBanHang
go

/* create table */

create table HANGSX(
	MaHangSX nchar(10) primary key,
	TenHang nvarchar(20) not null,
	DiaChi nvarchar(30) not null default N'Hà Nội',
	SoDT nvarchar(20),
	Email nvarchar(30)
)

create table SANPHAM(
	MaSP nchar(10) not null primary key,
	MaHangSX nchar(10) not null,
	TenSP nvarchar(20),
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan money,
	DonViTinh nvarchar(20),
	MoTa nvarchar(MAX),
	constraint FK_HANGSX_SANPHAM foreign key(MaHangSX) references HangSX(MaHangSX) on update cascade on delete cascade
	)

	create table NHANVIEN(
		MaNV nchar(10) not null primary key,
		TenNV nvarchar(20) not null,
		GioiTinh nchar(10),
		DiaChi nvarchar(30),
		SoDT nvarchar(20) not null unique,
		Email nvarchar(30),
		TenPhong nvarchar(30)
	)

	create table PNHAP(
		SoHDN nchar(10)not null primary key,
		NgayNhap date,
		MaNV nchar(10),
		constraint FK_NHANVIEN_PNHAP foreign key(MaNV) references NHANVIEN(MaNV) on update cascade  on delete cascade
	)

	create table NHAP(
		SoHDN nchar(10) not null,
		MaSP nchar(10) not null,
		SoLuongN int check(SoLuongN >2),
		DonGia money,
		primary key (SoHDN, MaSP),
		constraint FK_PN_NHAP foreign key(SoHDN) references PNHAP(SoHDN),
		constraint FK_SANPHAM_NHAP foreign key(MaSP) references SANPHAM(MaSP) on update cascade on delete cascade
	)

	create table PXUAT(
		SoHDX nchar(10) not null primary key,
		NgayXuat date not null default getdate(),
		MaNV nchar(10) not null,
		constraint FK_NHANVIEN_PXUAT foreign key(MaNV) references NHANVIEN(MaNV) on update cascade on delete cascade
	)

	create table XUAT(
		SoHDX nchar(10) not null,
		MaSP nchar(10) not null,
		SoLuongX int,
		primary key(SoHDX, MaSP),
		constraint FK_PX_XUAT foreign key(SoHDX) references PXUAT(SoHDX),
		constraint FK_SANPHAM_XUAT foreign key(MaSP) references SANPHAM(MaSP) on update cascade on delete cascade
	
	)
go

/* insert data */

insert into HANGSX
values('H01', 'SamSung', 'Korea', '011-08271212', 'ss@gmail.com.kr'),
	  ('H02', 'OPPO', 'China', '086-082613122', 'opp0@gmail.com.cn'),
	  ('H03', 'Vsmart', N'Việt Nam', '084-01091997', 'vsmart@gmail.com.vn'),
	  ('H04', 'IPHONE', 'MỸ', '086-082613123', 'ipp0@gmail.com.cn')

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

--a. Đưa ra 3 mặt hàng có SoLuongN nhiều nhất trong năm 2020
select top 3 NHAP.SoHDN, NgayNhap, SoLuongN
from NHAP inner join PNHAP on NHAP.SoHDN=PNHAP.SoHDN
where Year(NgayNhap)=2020

--b. Đưa ra MaSP,TenSP của các sản phẩm do công ty ‘Samsung’ sản xuất do nhân viên có mã ‘NV01’ nhập.
select MaSP, TenSP
from SANPHAM inner join HANGSX on SANPHAM.MaHangSX=HANGSX.MaHangSX
			 inner join NHANVIEN on NHANVIEN.MaNV=HANGSX.
where TenHang='SamSung' and MaNV='NV01'

--c. Đưa ra SoHDN,MaSP,SoLuongN,ngayN của mặt hàng có MaSP là ‘SP02’được nhân viên ‘NV02’ xuất.
select PNHAP.SoHDN,MaSP,SoLuongN,NgayNhap from PNHAP
inner join NHAP on PNHAP.SoHDN = NHAP.SoHDN
inner join PXUAT on PXUAT.MaNV = PNHAP.MaNV
where MaSP= 'SP02' and PXUAT.MaNV = 'NV02'

--d. Đưa ra manv,TenNV đã xuất mặt hàng có mã ‘SP02’ ngày ‘03-02-2020
select NHANVIEN.MaNV, TenNV from NHANVIEN
inner join PXUAT on NHANVIEN.MaNV=PXUAT.MaNV
inner join XUAT on PXUAT.SoHDX=XUAT.SoHDX
where MaSP= 'SP02' and NgayXuat= '03/02/2020'









