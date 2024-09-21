CREATE DATABASE QLVT
ON ( 
	NAME = QLVT_dat,
	FILENAME = 'D:\QLVTDAT.mdf',
	SIZE = 50MB,
	MAXSIZE = 200MB,
	FILEGROWTH = 10MB )
LOG ON (
	NAME = QLVT_log,
	FILENAME = 'D:\QLVTLOG.ldf',
	SIZE = 10MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 5MB )
USE QLVT
GO
CREATE TABLE VatTu(
	MaVT	char(4)	PRIMARY KEY,
	TenVT	nvarchar(100) UNIQUE,
	DvTinh	nvarchar(10) DEFAULT '""',
	PhanTram	real CHECK(PhanTram >= 0 and PhanTram <= 100 ) )
CREATE TABLE NHaCC(
	MaNCC	char(3)	PRIMARY KEY,
	TenNCC	nvarchar(100)	 UNIQUE,
	DiaChi	nvarchar(200) UNIQUE,
	DienThoai	varchar(20) NOT NULL DEFAULT N'Chưa có' )
CREATE TABLE DonDH(
	SoDH	char(4) PRIMARY KEY,
	NgayDH	date DEFAULT GETDATE(),
	MaNCC		char(3) FOREIGN KEY (MaNCC) REFERENCES NHaCC(MaNCC) ON UPDATE CASCADE ON DELETE CASCADE)
CREATE TABLE CTDonDH (
	SoDH	char(4),
	MaVT	char(4),
	SLDat int NOT NULL CHECK(SLDat > 0),
	PRIMARY KEY (SoDH, MaVT),
	FOREIGN KEY (SoDH) REFERENCES DonDH(SoDH) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (MaVT) REFERENCES VatTu(MaVT) ON UPDATE CASCADE ON DELETE CASCADE )
CREATE TABLE PNhap (
	SoPN	char(4) PRIMARY KEY,
	NgayNhap	date	NOT NULL,
	SoDH	char(4) FOREIGN KEY (SoDH) REFERENCES DonDH(SoDH) ON UPDATE CASCADE ON DELETE CASCADE )
CREATE TABLE CTPNhap (
	SoPN	char(4),
	MaVT	char(4),
	SLNhap	int NOT NULL CHECK(SLNhap > 0),
	Dgnhap	money NOT NULL CHECK(Dgnhap > 0) )
CREATE TABLE PXuat (
	SoPX	char(4)	PRIMARY KEY,
	NgayXuat	date	NOT NULL,
	TenKH	nvarchar(100)	NOT NULL )
CREATE TABLE CTPXuat (
	SoPX	char(4),
	MaVT	char(4),
	SLXuat	int CHECK(SlXuat > 0)	NOT NULL,
	DgXuat	money CHECK(DgXuat > 0) NOT NULL,
	FOREIGN KEY (SoPX) REFERENCES PXuat(SoPX) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (MaVT) REFERENCES VatTu(MaVT) ON UPDATE CASCADE ON DELETE CASCADE )
CREATE TABLE TonKho (
	NamThang	char(6),
	MaVT	char(4),
	SLDau	int NOT NULL CHECK(SLDau >= 0)	DEFAULT 0,
	TongSLN	int NOT NULL CHECK(TongSLN >= 0)	DEFAULT 0,
	TongSLX	int NOT NULL CHECK(TongSLX >= 0)	DEFAULT 0,
	SLCuoi	int,
	PRIMARY KEY (NamThang, MaVT),
	FOREIGN KEY (MaVT) REFERENCES VatTu(MaVT) ON UPDATE CASCADE ON DELETE CASCADE )
USE QLVT
INSERT INTO NHaCC(MaNCC, TenNCC, DiaChi, DienThoai) VALUES ('C01',N'Lê Minh Trí', N'54 Hậu Giang Q6 HCM', '8781024')
SELECT * FROM NHACC
INSERT INTO NHaCC VALUES ('C02',N'Trần Minh Thạch', N'145 Hùng Vương Mỹ Tho', '7698154'),
						 ('C03',N'Hồng Phương', N'154/85 Lê Lai Q1 HCM', '9600125'),
						 ('C04',N'Nhật Thắng', N'198/40 Hương Lộ 14 QTB HCM', '8757757'),
						 ('C05',N'Lưu Nguyệt Quế', N'178 Nguyễn Văn Luông Đà Lạt', '7964251'),
						 ('C07',N'Cao Minh Trung', N'125 Lê Quang Sung Nha Trang',DEFAULT)
INSERT INTO VatTu(MaVT, TenVT, DvTinh, PhanTram) VALUES ('DD01',N'Đầu DVD Hitachi 1 đĩa', N'Bộ', 40)
SELECT * FROM VatTu
INSERT INTO VatTu VALUES ('DD02',N'Đầu DVD Hitachi 3 đĩa', N'Bộ', 40),
						 ('TL15',N'Tủ lạnh Sanyo 150 lít', N'Cái', 25),
						 ('TL90',N'Tủ lạnh Sanyo 90 lít', N'Cái', 20),
						 ('TV14',N'Tivi Sony 14 inches', N'Cái', 15),
						 ('TV21',N'Tivi Sony 21 inches', N'Cái', 10),
						 ('TV29',N'Tivi Sony 29 inches', N'Cái', 10),
						 ('VD01',N'Đầu VCD Sony 1 đĩa', N'Bộ', 30),
						 ('VD02',N'Đầu VCD Sony 3 đĩa', N'Bộ', 30)
INSERT INTO DonDH(SoDH, NgayDH, MaNCC) VALUES ('D001','01/15/2002', 'C03')
SELECT * FROM DonDH
INSERT INTO DonDH VALUES ('D002','01/30/2002', 'C01'),
						 ('D003','02/10/2002', 'C02'),
						 ('D004','02/17/2002', 'C05'),
						 ('D005','03/01/2002', 'C02'),
						 ('D006','03/12/2002', 'C05')
INSERT INTO PNhap(SoPN, NgayNhap, SoDH) VALUES ('N001','01/17/2002', 'D001')
SELECT * FROM PNhap
INSERT INTO PNhap VALUES ('N002','01/20/2002', 'D001'),
						 ('N003','01/31/2002', 'D002'),
						 ('N004','02/15/2002', 'D003')
INSERT INTO CTDonDH(SoDH, MaVT, SLDat) VALUES ('D001','DD01',10)
SELECT * FROM CTDonDH
INSERT INTO CTDonDH VALUES ('D001','DD02',15),
						   ('D002','VD02',30),
						   ('D003','TV14',10),
						   ('D003','TV29',20),
						   ('D004','TL90',10),
						   ('D005','TV14',10),
						   ('D005','TV29',20),
						   ('D006','TV14',10),
						   ('D006','TV29',20),
						   ('D006','VD01',20)
INSERT INTO CTPNhap(SoPN, MaVT, SLNhap, Dgnhap) VALUES ('N001','DD01',8, 2500000)
SELECT * FROM CTPNhap
INSERT INTO CTPNhap VALUES ('N001','DD02', 10, 3500000),
						   ('N002','DD01', 2, 2500000),
						   ('N002','DD02', 5, 3500000),
						   ('N003','VD02', 30, 2500000),
						   ('N004','TV14', 5, 2500000),
						   ('N004','TV29', 12, 3500000)
INSERT INTO PXuat(SoPX, NgayXuat, TenKH) VALUES ('X001','01/17/2002', N'Nguyễn Ngọc Phương Nhi')
SELECT * FROM PXuat
INSERT INTO PXuat VALUES ('X002','01/25/2002', N'Nguyễn Hồng Phương'),
						 ('X003','01/31/2002', N'Nguyễn Tuấn Tú')
INSERT INTO CTPXuat(SoPX, MaVT, SLXuat, DgXuat) VALUES ('X001','DD01', 2, 3500000)
SELECT * FROM CTPXuat
INSERT INTO CTPXuat VALUES ('X002','DD01', 1, 3500000),
						   ('X002','DD02', 5, 4900000),
						   ('X003','DD01', 3, 3500000),
						   ('X003','DD02', 2, 4900000),
						   ('X003','VD02', 10, 3250000)
INSERT INTO TonKho(NamThang, MaVT, SLDau, TongSLN, TongSLX, SLCuoi) VALUES ('200201','DD01', 0, 10, 6, 4)
SELECT * FROM TonKho
INSERT INTO TonKho VALUES ('200201','DD02', 0, 15, 7, 8),
						  ('200201','VD02', 0, 30, 10, 20),
						  ('200202','DD01', 4, 0, 0, 4),
						  ('200202','DD02', 8, 0, 0, 8),
						  ('200202','VD02', 20, 0, 0, 20),
						  ('200202','TV14', 5, 0, 0, 5),
						  ('200202','TV29', 12, 0, 0, 12)

--a.Tạo view có tên vw_DMVT bao gồm các thông tin sau: mã vật tư, tên vật tư. View 
--này dùng để liệt kê danh sách các vật tư hiện có trong bảng VATTU. 


--b.Tạo view có tên vw_DonDH_TongSLDatNhap bao gồm các thông tin sau: số đặt 
--hàng, tổng số lượng đặt, tổng số lượng nhập. View này được dùng để thống kê những 
--đơn đặt hàng nào đã được nhập hàng đầy đủ.
CREATE VIEW VW_DONHD_TONGSLDATNHAP
AS
SELECT SoDH, SUṂ̣̣(SLDat) AS TongSLD, SUM(SLNhap) AS TongSLN
FROM CTDonDH INNER JOIN VatTu ON CTDonDH.MaVT=VatTu.MaVT
			 INNER JOIN CTPNhap ON CTPNhap.MaVT=VatTu.MaVT
GROUP BY SoDH
--Hiển thị View
SELECT * FROM VW_DONHD_TONGSLDATNHAP
--c. Tạo view có tên vw_DonDH_DaNhapDu bao gồm các thông tin sau: số đặt hàng, đã 
--nhập đủ trong đó cột đã nhập đủ sẽ có 2 giá trị là “Đã nhập đủ” nếu đơn đặt hàng đó đã 
--nhập đủ hoặc “Chưa nhập đủ” nếu đơn đặt hàng đó chưa nhập đủ.
CREATE VIEW VW_DONDH_DANHAPDU
AS
SELECT SoDH, CASE
WHEN TongSLD=TongSLN THEN N'ĐÃ NHẬP ĐỦ'
ELSE N'CHƯA NHẬP ĐỦ'
END AS TrangThai
FROM VW_DONHD_TONGSLDATNHAP
--Hiển thị view
SELECT * FROM VW_DONDH_DANHAPDU
--d. Tạo view có tên vw_TongNhap bao gồm các thông tin sau: năm tháng, mã vật tư, 
--tổng số lượng nhập. View này dùng để thống kê số lượng nhập của các vật tư trong từng 
--năm tháng tương ứng. Chú ý: không sử dụng bảng TONKHO. 
CREATE VIEW VW_TONGNHAP
AS
SELECT MONTH(NgayNhap) AS Thang, YEAR(NgayNhap) AS NAM, MaVT, SUM(SLNhap) AS TongSLN
FROM CTPNhap INNER JOIN PNhap ON CTPNhap.SoPN= PNhap.SoPN
GROUP BY MONTH(NgayNhap), YEAR(NgayNhap), MaVT
--Hiện thị view
SELECT * FROM VW_TONGNHAP

--e. Tạo view có tên vw_TongXuat bao gồm các thông tin sau: năm tháng, mã vật tư, tổng 
--số lượng xuất. View này dùng để thống kê số lượng xuất của vật tư trong từng năm 
--tháng tương ứng. Chú ý: không sử dụng bảng TONKHO. 
CREATE VIEW VW_TONGXUAT
AS
SELECT MONTH(NgayXuat) AS Thang, YEAR(NgayXuat) AS NAM, SUM(SLXuat) AS SLNhap
FROM CTPXuat INNER JOIN PXuat
ON CTPXuat.SoPX=PXuat.SoPX
GROUP BY MONTH(NgayXuat), YEAR(NgayXuat), MaVT
--Hiển thị view
SELECT * FROM VW_TONGXUAT

--f. Tạo view có tên vw_DonDH_MaVTu_TongSLNhap bao gồm các thông tin sau: số
--đặt hàng, ngày đặt hàng, mã vật tư, tên vật tư, số lượng đặt, tổng số lượng đã nhập hàng 
CREATE VIEW vw_DonDH_MaVTu_TongSLNhap
AS
SELECT DonDH.SoDH, NgayDH, VatTu.MaVT, TenVT, CTDonDH.SLDat, TongSLN
FROM DonDH INNER JOIN CTDonDH ON CTDonDH.SoDH=DonDH.SoDH
INNER JOIN VatTu ON VatTu.MaVT=CTDonDH.MaVT
INNER JOIN TonKho ON VatTu.MaVT=TonKho.MaVT

SELECT * FROM vw_DonDH_MaVTu_TongSLNhap


--2a. Cho biết danh sách các phiếu đặt hàng chưa được nhập hàng
CREATE VIEW vw_DonDH_ChuaNhap
AS
SELECT SoDH
FROM vw_DonDH_TongSLDATNHAP
WHERE SoDH NOT IN(SELECT SoDH FROM vw_DonDH_TongSLDATNHAP)

SELECT * FROM vw_DonDH_ChuaNhap

--2b.Cho biết danh sách các mặt hàng chưa được đặt hàng bao giờ.
CREATE VIEW vw_DonDH_ChuaBhNhap
AS
SELECT *
FROM vw_DMVT
WHERE MaVT NOT IN(SELECT MaVT FROM vw_DMVT)

SELECT * FROM vw_DonDH_ChuaBhNhap

