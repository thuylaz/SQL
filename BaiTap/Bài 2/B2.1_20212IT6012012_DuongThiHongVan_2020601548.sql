CREATE DATABASE QLBanHang3
GO

USE QLBanHang3
GO

CREATE TABLE HANGSX(
MaHangSX NCHAR(10) NOT NULL PRIMARY KEY,
TenHang NVARCHAR(20) NOT NULL,
DiaChi NVARCHAR(20),
SoDT NVARCHAR(20),
Email NVARCHAR(30)
)
GO

CREATE TABLE SANPHAM(
MaSP NCHAR(10)NOT NULL PRIMARY KEY,
MaHangSX NCHAR(10) NOT NULL,
TenSP NVARCHAR(20),
SoLuong INT,
MauSac NVARCHAR(20),
GiaBan MONEY,
DonViTinh NCHAR(10),
Mota NVARCHAR(MAX),
CONSTRAINT fk_hsx_sanpham FOREIGN KEY(MaHangSX) REFERENCES HANGSX(MaHangSX),
)
GO

CREATE TABLE NHANVIEN(
MaNV NCHAR(10) NOT NULL PRIMARY KEY,
TenNV NVARCHAR(20) NOT NULL,
GioiTinh NCHAR(10),
DiaChi NVARCHAR(30),
SoDT NVARCHAR(20),
Email NVARCHAR(30),
TenPhong NVARCHAR(30)
)
GO

CREATE TABLE PNHAP(
SoHDN NCHAR(10) NOT NULL PRIMARY KEY,
NgayNhap DATE,
MaNV NCHAR(10) NOT NULL
CONSTRAINT fk_NHANVIEN_pnhap FOREIGN KEY(MaNV) REFERENCES NHANVIEN(MaNV)
)
GO

CREATE TABLE NHAP(
SoHDN NCHAR(10) NOT NULL,
MaSP NCHAR(10) NOT NULL,
SoLuongN INT,
DonGiaN MONEY,
CONSTRAINT pk_NHAP PRIMARY KEY(SoHDN,MaSP),
CONSTRAINT fk_Pn_nhap FOREIGN KEY(SoHDN) REFERENCES PNHAP(SoHDN),
CONSTRAINT fk_sph_nhap FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
)
GO

CREATE TABLE PXUAT(
SoHDX NCHAR(10) NOT NULL PRIMARY KEY,
NgayXuat DATE,
MaNV NCHAR(10) NOT NULL,
CONSTRAINT fk_NHANVIEN_pxuat FOREIGN KEY(MaNV) REFERENCES NHANVIEN(MaNV)
)
GO

CREATE TABLE XUAT(
SoHDX NCHAR(10) NOT NULL,
MaSP NCHAR(10) NOT NULL,
SoLuongX INT,
CONSTRAINT pk_XUAT PRIMARY KEY(SoHDX,MaSP),
CONSTRAINT fk_PX_xuat FOREIGN KEY(SoHDX) REFERENCES PXUAT(SoHDX),
CONSTRAINT fk_sanpham_xuat FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
)
GO


INSERT INTO HANGSX VALUES('H01', 'SamSung', 'Korea', '011-08271212', 'ss@gmail.com.kr')
INSERT INTO HANGSX VALUES('H02', 'OPPO', 'China', '086-082613122', 'opp0@gmail.com.cn')
INSERT INTO HANGSX VALUES('H03', 'Vsmart', N'Vi?t Nam', '084-01091997', 'vsmart@gmail.com.vn')

INSERT INTO SANPHAM VALUES('SP01', 'H02', 'F1 Plus', '100', N'X�m', '7000000', N'Chi?c', N'H�ng c?n cao c?p')
INSERT INTO SANPHAM VALUES('SP02', 'H01', 'Galaxy Note 11', '50', N'??', '19000000', N'Chi?c', N'H�ng cao c?p')
INSERT INTO SANPHAM VALUES('SP03', 'H02', 'F3 lite', '200', N'N�u', '3000000', N'Chi?c', N'H�ng ph? th�ng')
INSERT INTO SANPHAM VALUES('SP04', 'H03', 'Joy3', '200', N'X�m', '3500000', N'Chi?c', N'H�ng ph? th�ng')
INSERT INTO SANPHAM VALUES('SP05', 'H01', 'Galaxy V21', '500', N'N�u', '8000000', N'Chi?c', N'H�ng c?n cao c?p')

INSERT INTO NHANVIEN VALUES('NV01', N'Nguy?n Th? Thu', 'N?', N'H� N?i', '0982626521', 'thu@gmail.com', N'K? to�n')
INSERT INTO NHANVIEN VALUES('NV02', N'L� V?n Nam', 'Nam', N'B?c Ninh', '0972525252 ', 'nam@gmail.com', N'V?t t?')
INSERT INTO NHANVIEN VALUES('NV03', N'Tr?n H�a B�nh', 'N?', N'H� N?i', '0328388388 ', 'hb@gmail.com', N'K? to�n')

INSERT INTO PNHAP VALUES('N01', '02-05-2019', 'NV01')
INSERT INTO PNHAP VALUES('N02', '04-07-2020', 'NV02')
INSERT INTO PNHAP VALUES('N03', '05-17-2020', 'NV02')
INSERT INTO PNHAP VALUES('N04', '03-22-2020', 'NV03')
INSERT INTO PNHAP VALUES('N05', '07-07-2020', 'NV01')


INSERT INTO NHAP VALUES('N01', 'SP02', '10', '17000000')
INSERT INTO NHAP VALUES('N02', 'SP01', '30', '6000000')
INSERT INTO NHAP VALUES('N03', 'SP04', '20', '1200000')
INSERT INTO NHAP VALUES('N04', 'SP01', '10', '6200000')
INSERT INTO NHAP VALUES('N05', 'SP05', '20', '7000000')

INSERT INTO PXUAT VALUES('X01', '06-14-2020', 'NV02')
INSERT INTO PXUAT VALUES('X02', '03-05-2019', 'NV03')
INSERT INTO PXUAT VALUES('X03', '12-14-2020', 'NV01')
INSERT INTO PXUAT VALUES('X04', '06-02-2020', 'NV02')
INSERT INTO PXUAT VALUES('X05', '05-15-2020', 'NV01')

INSERT INTO XUAT VALUES('X01', 'SP03', '5')
INSERT INTO XUAT VALUES('X02', 'SP01', '3')
INSERT INTO XUAT VALUES('X03', 'SP02', '1')
INSERT INTO XUAT VALUES('X04', 'SP03', '2')
INSERT INTO XUAT VALUES('X05', 'SP05', '1')


SELECT* FROM HANGSX
SELECT* FROM SANPHAM
SELECT* FROM NHANVIEN
SELECT* FROM PNHAP
SELECT* FROM NHAP
SELECT* FROM PXUAT
SELECT* FROM XUAT








