create database QLBanHang2

go 
use QLBanHang2
go

create table HangSX(
	MaHangSX nchar(10) not null primary key,
	TenHang nvarchar(20) not null,
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30),
)
create table NhanVien(
	MaNV nchar(10) not null primary key,
	TenNV nvarchar(20) ,
	GioiTinh nchar(10),
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30),
	TenPhong nvarchar(30),
)
create table SanPham(
	MaSP nchar(10) not null primary key,
	MaHangSX nchar(10) not null,
	TenSP nvarchar(20),
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan money,
	DonViTinh nchar(10),
	MoTa nvarchar(Max),
	constraint Fk_SP_HSX foreign key(MaHangSX)
		references HangSX(MaHangSX),
)
create table PNhap(
	SoHDN nchar(10) not null primary key,
	NgayNhap Date,
	MaNV nchar(10) not null,
	constraint FK_PN_NV foreign key(MaNV)
		references NhanVien(MaNV),
)
create table PXuat(
	SoHDX nchar(10) not null primary key,
	NgayXuat Date,
	MaNV nchar(10) not null,
	constraint FK_PX_NV foreign key(MaNV)
		references NhanVien(MaNV),
)
create table Nhap(
	SoHDN nchar(10) not null ,
	MaSP nchar(10) not null,
	SoLuongN int,
	DonGiaN money,
	tiennhap null,
	constraint PK_Nhap primary key(SoHDN, MaSP),
	constraint FK_N_PN foreign key(SoHDN)
		references PNhap(SoHDN),
	constraint FK_N_SP foreign key(MaSP)
		references SanPham(MaSP),
)
create table Xuat(
	SoHDX nchar(10) not null ,
	MaSP nchar(10) not null,
	SoLuongX int,
	constraint PK_X_Xuat primary key(SoHDX, MaSP),
	constraint FK_X_PX foreign key(SoHDX)
		references PXuat(SoHDX),
	constraint FK_X_SP foreign key(MaSP)
		references SanPham(MaSP),
)
--b
insert into HangSX values('H01', 'Sam Sung','Korea', '011-08271717' , 'ss@gmail.com'),
						 ('H02','OPPO','China','081-08626262','oppo@gmail.com'),
						 ('H03','Vinfone',N'Việt Nam','084-098262626','vf@gmail.com')

insert into NhanVien values ('NV01', N'Nguyễn Thị Thu',N'Nữ',N'Hà Nội',0982626521,'nam@gmail.com',N'kế toán'),
							('NV02',N'Lê Văn Nam','Nam',N'Bắc Ninh',0972525252,'nam@gmail.com',N'vật tư'),
							('NV03',N'Trần Hòa Bình',N'Nữ','Hà Nội',0328388388,'hb@gmail.com',N'Kế toán')

insert into SanPham values('SP01','H02','F1 Plus',100,N'Xám',7000000,N'Chiếc',N'Hàng cận cao cấp'),
						  ('SP02','H01','Galaxy note 11',50,N'Đỏ',19000000,N'Chiếc',N'Hàng cao cấp'),
						  ('SP03','H02','F3 lite',200,N'Nâu',3000000,N'Chiếc',N'Hàng phổ thông'),
						  ('SP04','H03','Vjoy 3',200,N'Xám',1500000,N'Chiếc',N'Hàng phổ thông'),
						  ('SP05','H01','Galaxy V21',500,N'Nâu',8000000,N'Chiếc',N'Hàng cận cao cấp'),
						  ('SP06','H01','galaxy not 11',300,N'Xám',30000000,N'Chiếc',N'Hàng cao cấp'),
						  ('SP07','H01','galaxy not 3',300,N'Xám',4000000,N'Chiếc',N'Hàng cao cấp')
insert into PNhap values('N01','02-05-2019','NV01'),
						('N02','04-07-2020','NV02'),
						('N03','05-17-2020','NV02'),
						('N04','03-22-2020','NV03'),
						('N05','07-07-2020','NV01'),
						('N06','02-05-2020','NV01'),
						('N07','02-05-2018','NV01')

insert into PXuat values('X01','06-14-2020','NV02'),
						('X02','03-05-2019','NV03'),
						('X03','12-12-2020','NV01'),
						('X04','06-02-2020','NV02'),
						('X05','05-18-2020','NV01')

insert into Nhap values ('N01','SP02',10,17000000),
					    ('N02','SP01',30,6000000),
						('N03','SP04',20,1200000),
						('N04','SP01',10,6200000),
						('N05','SP05',20,7000000),
						('N06','SP06',10,30000000),
						('N07','SP07',10,4000000)
insert into Xuat values('X01','SP03',5),
					   ('X02','SP01',3),
					   ('X03','SP02',1),
					   ('X04','SP03',2),
					   ('X05','SP05',1)


--cập nhật dữ liệu trên các bảng
update Nhap
set tongtienn = soluongn * dongian
--xóa dữ liệu trên các bảng
delete from xuat
--gọi dữ liệu các bảng
select * from SanPham
select * from HangSX
