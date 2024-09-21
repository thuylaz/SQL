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
CREATE TABLE HANGSX(
MaHangSX NCHAR(10) PRIMARY KEY,
TenHang NVARCHAR(20) NOT NULL,
DiaChi NVARCHAR(30) NOT NULL DEFAULT N'Hà Nội',
SoDT NVARCHAR(20),
Email NVARCHAR(30)
)

CREATE TABLE SANPHAM(
MaSP NCHAR(10) NOT NULL PRIMARY KEY,
MaHangSX NCHAR(10) NOT NULL,
TenSP NVARCHAR(20),
SoLuong INT,
MauSac NVARCHAR(20),
GiaBan MONEY,
DonViTinh NVARCHAR(20),
MoTa NVARCHAR(MAX),
CONSTRAINT FK_HANGSX_SANPHAM FOREIGN KEY(MaHangSX) REFERENCES HangSX(MaHangSX)
)
CREATE TABLE NHANVIEN(
MaNV NCHAR(10) NOT NULL PRIMARY KEY,
TenNV NVARCHAR(20) NOT NULL,
GioiTinh NCHAR(10),
DiaChi NVARCHAR(30),
SoDT NVARCHAR(20) NOT NULL UNIQUE,
Email NVARCHAR(30),
TenPhong NVARCHAR(30)
)
CREATE TABLE PNHAP(
SoHDN NCHAR(10) NOT NULL PRIMARY KEY,
NgayNhap DATE,
MaNV NCHAR(10),
CONSTRAINT FK_NHANVIEN_PNHAP FOREIGN KEY(MaNV) REFERENCES NHANVIEN(MaNV) ON UPDATE CASCADE ON DELETE CASCADE 
)

CREATE TABLE NHAP(
SoHDN NCHAR(10) NOT NULL,
MaSP NCHAR(10) NOT NULL,
SoLuongN INT CHECK (SoLuongN>2),
DonGiaN MONEY,
PRIMARY KEY(SoHDN,MaSP),
CONSTRAINT FK_PN_NHAP FOREIGN KEY(SoHDN) REFERENCES PNHAP(SoHDN),
CONSTRAINT FK_SANPHAM_NHAP FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
)
CREATE TABLE PXUAT(
SoHDX NCHAR(10) NOT NULL PRIMARY KEY,
NgayXuat DATE NOT NULL DEFAULT GETDATE(),
MaNV NCHAR(10) NOT NULL,
CONSTRAINT FK_NHANVIEN_PXUAT FOREIGN KEY(MaNV) REFERENCES NHANVIEN(MaNV)
)
CREATE TABLE XUAT(
SoHDX NCHAR(10) NOT NULL,
MaSP NCHAR(10) NOT NULL,
SoLuongX INT
PRIMARY KEY(SoHDX,MaSP),
CONSTRAINT FK_PX_XUAT FOREIGN KEY(SoHDX) REFERENCES PXUAT(SoHDX),
CONSTRAINT FK_SANPHAM_XUAT FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
)
GO
/* insert data*/
INSERT INTO HANGSX 
VALUES('H01', 'SamSung', 'Korea', '011-08271212', 'ss@gmail.com.kr'),
	  ('H02', 'OPPO', 'China', '086-082613122', 'opp0@gmail.com.cn'),
	  ('H03', 'Vsmart', N'Việt Nam', '084-01091997', 'vsmart@gmail.com.vn'),
	  ('H04', 'IPHONE', 'MỸ', '086-082613123', 'ipp0@gmail.com.cn')

INSERT INTO SANPHAM
VALUES('SP01', 'H02', 'F1 Plus', '100', N'Xám', '7000000', N'Chiếc', N'Hàng cận cao cấp'), 
       ('SP02', 'H01', 'Galaxy Note 11', '50', N'Đỏ', '19000000', N'Chiếc', N'Hàng cao cấp'),
	   ('SP03', 'H02', 'F3 lite', '200', N'Nâu', '3000000', N'Chiếc', N'Hàng phổ thông'),
       ('SP04', 'H03', 'Joy3', '200', N'Xám', '3500000', N'Chiếc', N'Hàng phổ thông'),
       ('SP05', 'H01', 'Galaxy V21', '500', N'Nâu', '8000000', N'Chiếc', N'Hàng cận cao cấp') 

INSERT INTO NHANVIEN 
VALUES('NV01', N'Nguyễn Thị Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@gmail.com', N'Kế toán'), 
      ('NV02', N'Lê Văn Nam', N'Nam', N'Bắc Ninh', '0972525252 ', 'nam@gmail.com', N'Vật tư'), 
      ('NV03', N'Trần Hòa Bình', N'Nữ', N'Hà Nội', '0328388388 ', 'hb@gmail.com', N'Kế toán'),
	  ('NV04', N'Lê Văn Minh', N'Nam', N'Hồ Chí Minh', '0974525252 ', 'nam@gmail.com', N'Vật tư') 

INSERT INTO PNHAP 
VALUES('N01', '02-05-2019', 'NV01'),
      ('N02', '04-07-2020', 'NV02'),
      ('N03', '05-17-2020', 'NV02'),
      ('N04', '03-22-2020', 'NV03'),
      ('N05', '07-07-2020', 'NV01')

INSERT INTO NHAP 
VALUES('N01', 'SP02', '10', '17000000'),
      ('N02', 'SP01', '30', '6000000'),
      ('N03', 'SP04', '20', '1200000'),
      ('N04', 'SP01', '10', '6200000'),
      ('N05', 'SP05', '20', '7000000')

insert into PXUAT 
VALUES('X01', '06-14-2020', 'NV02'),
      ('X02', '03-05-2019', 'NV03'),
      ('X03', '12-14-2020', 'NV01'),
      ('X04', '06-02-2020', 'NV02'),
      ('X05', '05-15-2020', 'NV01')

INSERT INTO XUAT 
VALUES('X01', 'SP03', '5'),
      ('X02', 'SP01', '3'),
      ('X03', 'SP02', '1'),
      ('X04', 'SP03', '2'),
      ('X05', 'SP05', '1')
GO

 -- test
 SELECT * FROM HANGSX
 SELECT * FROM SANPHAM
 SELECT * FROM NHANVIEN
 SELECT * FROM PNHAP
 SELECT * FROM NHAP
 SELECT * FROM PXUAT
 SELECT * FROM XUAT
 GO
--b,Đưa ra thông tin MaSP, TenSP, TenHang,SoLuong, MauSac, GiaBan, DonViTinh,
--MoTa của các sản phẩm sắp xếp theo chiều giảm dần giá bán.
SELECT MaSP, TenSP, TenHang,SoLuong, MauSac, GiaBan, DonViTinh,MoTa
FROM SANPHAM INNER JOIN HANGSX
ON SANPHAM.MaHangSX= HANGSX.MaHangSX
ORDER BY GiaBan DESC

--c, Đưa ra thông tin các sản phẩm có trong cữa hàng do công ty có tên hãng là Samsung sản xuất.
SELECT * FROM SANPHAM INNER JOIN HANGSX
ON SANPHAM.MaHangSX= HANGSX.MaHangSX
WHERE TenHang='SamSung'

--d,Đưa ra thông tin các nhân viên Nữ ở phòng ‘Kế toán’.
SELECT * FROM NHANVIEN
WHERE GioiTinh=N'Nữ' AND TenPhong = N'Kế toán'

--e,Đưa ra thông tin phiếu nhập gồm: SoHDN, MaSP, TenSP, TenHang, SoLuongN,
--DonGiaN, TienNhap=SoLuongN*DonGiaN, MauSac, DonViTinh, NgayNhap, TenNV,
--TenPhong, sắp xếp theo chiều tăng dần của hóa đơn nhập.
SELECT PNHAP.SoHDN, SANPHAM.MaSP, TenSP, TenHang, SoLuongN,DonGiaN, SoLuongN*DonGiaN AS N'Tiền nhập', MauSac, DonViTinh, NgayNhap, TenNV,TenPhong
FROM NHAP INNER JOIN SANPHAM ON NHAP.MaSP=SANPHAM.MaSP
		  INNER JOIN PNHAP ON NHAP.SoHDN=PNHAP.SoHDN
		  INNER JOIN NHANVIEN ON PNHAP.MaNV=NHANVIEN.MaNV
		  INNER JOIN HANGSX ON HANGSX.MaHangSX=SANPHAM.MaHangSX
ORDER BY SoHDN ASC

--f,Đưa ra thông tin phiếu xuất gồm: SoHDX, MaSP, TenSP, TenHang, SoLuongX,
--GiaBan, tienxuat=SoLuongX*GiaBan, MauSac, DonViTinh, NgayXuat, TenNV,
--TenPhong trong tháng 06 năm 2020, sắp xếp theo chiều tăng dần của SoHDX.
SELECT PXUAT.SoHDX, SANPHAM.MaSP, TenSP, TenHang, SoLuongX, GiaBan, SoLuongX*GiaBan AS N'Tiền xuất', MauSac, DonViTinh, NgayXuat, TenNV,TenPhong
FROM XUAT INNER JOIN SANPHAM ON XUAT.MaSP=SANPHAM.MaSP
		  INNER JOIN PXUAT ON XUAT.SoHDX=PXUAT.SoHDX
		  INNER JOIN NHANVIEN ON PXUAT.MaNV=NHANVIEN.MaNV
		  INNER JOIN HANGSX ON HANGSX.MaHangSX=SANPHAM.MaHangSX
WHERE month(NgayXuat)=06 AND YEAR(NgayXuat)=2020
ORDER BY SoHDX ASC