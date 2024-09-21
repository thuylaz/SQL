CREATE DATABASE QLBanHangbai7trenlop

CREATE TABLE HangSX
(
	MaHangSX nchar(10) primary key,
	TenHang nvarchar(20),
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(20),
)

CREATE TABLE SanPham
(
	MaSP nchar(10) primary key,
	MaHangSX nchar(10),
	TenSP nvarchar(20),
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan money,
	DonViTinh nchar(10),
	MoTa nvarchar(max)
	constraint fk_SP_MaHangSX
	foreign key (MaHangSX)
	references HangSX(MaHangSX)
)

CREATE TABLE NhanVien
(
	MaNV nchar(10) primary key,
	TenNv nvarchar(20),
	GioiTinh nchar(10),
	DiaChi nvarchar(30),
	SoDT nvarchar(30),
	Email nvarchar(30),
	TenPhong nvarchar(30),
)

CREATE TABLE PNhap
(
	SoHDN nchar(10) primary key,
	NgayNhap datetime,
	MaNV nchar(10),
	constraint fk_NV_MaNV
	foreign key (MaNV)
	references NhanVien(MaNV)
)

CREATE TABLE PXuat
(
	SoHDX nchar(10) primary key,
	NgayXuat date,
	MaNV nchar(10),
	constraint fk_NV_MaNVPX
	foreign key (MaNv)
	references NhanVien(MaNV)
)

CREATE TABLE Nhap
(
	SoHDN nchar(10),
	MaSP nchar(10),
	SoLuongN int,
	DonGiaN money,
	primary key (SoHDN,MaSP),
	constraint fk_PN_SoHDN
	foreign key (SoHDN)
	references PNhap(SoHDN),
	constraint fk_SP_MaSP
	foreign key (MaSP)
	references SanPham(MaSP)
)

CREATE TABLE Xuat
(
	SoHDX nchar(10),
	MaSP nchar(10),
	SoLuongX int,
	primary key(SoHDX,MaSP),
	constraint fk_PX_SoHDX
	foreign key (SoHDX)
	references PXuat(SoHDX),
	constraint fk_SP_MaSPX
	foreign key (MaSP)
	references SanPham(MaSP)
)

INSERT INTO HangSX VALUES ('H01','Samsung','Korea','01108271717','ss@gmail.com.kr'),
                          ('H02','OPPO','China','08108626262','op@gmail.com.cn'),
                          ('H03','VinFone',N'Vi?t Nam','084098262626','vf@gmail.com.vn')


INSERT INTO NhanVien VALUES ('NV01',N'Nguyen Th? Thu',N'N?',N'Hà N?i','0982626521','thu@gmail.com',N'Kế toán'),
                            ('NV02',N'Lê V?n Nam',N'Nam',N'B?c Ninh','0972525252','nam@gmail.com',N'V?t t?'),
                            ('NV03',N'Tr?n Hòa Nình',N'N?',N'Hà N?i','0328388388','hb@gmail.com',N'Kế toán')


INSERT INTO SanPham VALUES ('SP01','H02','F1 Plus',100,N'Xám','7000000',N'Chi?c',N'Hàng c?n cao c?p'),
                           ('SP02','H01','Galyxy Note 11',50,N'??','19000000',N'Chi?c',N'Hàng c?n cao c?p'),
                           ('SP03','H02','F3 Lite',200,N'Nâu','3000000',N'Chi?c',N'Hàng c?n cao c?p'),
                           ('SP04','H03','Vjoy 3',200,N'Xám','1500000',N'Chi?c',N'Hàng c?n cao c?p'),
                           ('SP05','H01','Galaxy V21',500,N'Nâu','8000000',N'Chi?c',N'Hàng c?n cao c?p')

----nhap du lieu vao bang---
INSERT INTO PNhap VALUES ('N01','20190205','NV01'),
                         ('N02','20200407','NV02'),
                         ('N03','20200517','NV02'),
                         ('N04','20200322','NV03'),
                         ('N05','20200707','NV01')


INSERT INTO Nhap VALUES ('N01','SP02',10,'17000000'),
                        ('N02','SP01',30,'6000000'),
                        ('N03','SP04',20,'1200000'),
                        ('N04','SP01',10,'6200000'),
                        ('N05','SP05',20,'7000000')


INSERT INTO PXuat VALUES ('X01','20200614','NV02'),
                         ('X02','20200305','NV03'),
                         ('X03','20201212','NV01'),
                         ('X04','20200602','NV02'),
                         ('X05','20200518','NV01')


INSERT INTO Xuat VALUES ('X01','SP03',5),
                        ('X02','SP01',3),
                        ('X03','SP02',1),
                        ('X04','SP03',2),
                        ('X05','SP05',1)
select * from HangSX
select * from NhanVien
select * from SanPham
select * from PNhap
select * from Nhap
select * from PXuat
select * from Xuat
--tạo trigger
Create Trigger trg_Nhap
On Nhap
For Insert
As
Begin
 Declare @MaSP nvarchar(10),@manv nvarchar(10)
 Declare @sln int, @dgn float
 Select @MaSP=MaSP,@sln=SoLuongN,@dgn = DonGiaN From Inserted
 If(Not Exists(Select * From SanPham Where MaSP = @MaSP))
 Begin
 Raiserror(N'Không tồn tại sản phẩm trong danh mục sản phẩm',16,1)
 Rollback Transaction
 End
 Else
 If(@sln<=0 Or @dgn<=0)
 Begin
 Raiserror(N'Nhập sai SoLuong hoặc DonGia',16,1)
 Rollback Transaction
 End
 Else 
 -- Bây giờ mới được phép nhập, khi này cần thay đổi SoLuong --trong bảng SanPham
 Update SanPham Set SoLuong = SoLuong + @sln
 From SanPham Where MaSP = @MaSP
End
-- Gọi dữ liệu 3 bảng liên quan
Select * From SanPham
Select * From NhanVien
Select * From Nhap
-- Nhập sai:
Insert Into Nhap Values('N04','SP02', 0,1500000)
-- Nhập đúng:
Insert Into Nhap Values('N01','SP01', 300,1500000)
Select * From nhap
Select * From SanPham