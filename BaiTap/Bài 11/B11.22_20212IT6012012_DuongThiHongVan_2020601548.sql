CREATE DATABASE QLBANHANG
GO
drop database QLBANHANG
/*DIEU HUONG CSDL TU MASTER SANG QLBANHANG1*/
USE QLBANHANG
GO
CREATE TABLE HangSX(
	MaHangSX	char(10) PRIMARY KEY,
	TenHang		nvarchar(30) NOT NULL,
	DiaChi		nvarchar(50) NOT NULL,
	SoDT		varchar(11) NOT NULL,
	Email		varchar(40)
)
CREATE TABLE SanPham(
	MaSP		char(10) PRIMARY KEY,
	MaHangSX	char(10) FOREIGN KEY(MaHangSX) REFERENCES HangSX(MaHangSX) ON UPDATE CASCADE ON DELETE CASCADE,
	TenSP		nvarchar(30) NOT NULL,
	SoLuong		int ,
	Mau			varchar(11),
	GiaBan		money,
	DonViTinh	nvarchar(20),
	MoTa		nvarchar(50)
)
CREATE TABLE NhanVien(
	MaNV		char(10) PRIMARY KEY,
	TenNV		nvarchar(30) NOT NULL,
	GioiTinh	bit,
	DiaChi		nvarchar(50),
	SoDT		varchar(11) NOT NULL UNIQUE,
	Email		varchar(50),
	TenPhong	nvarchar(30)
)
CREATE TABLE PNhap(
	SoHDN		char(10) PRIMARY KEY,
	NgayNhap	date NOT NULL,
	MaNV		char(10) FOREIGN KEY(MaNV) REFERENCES NhanVien(MaNV) ON UPDATE CASCADE ON DELETE CASCADE
)
CREATE TABLE Nhap(
	SoHDN		char(10) FOREIGN KEY(SoHDN) REFERENCES PNhap(SoHDN) ON UPDATE CASCADE ON DELETE CASCADE,
	MaSP		char(10) FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP) ON UPDATE CASCADE ON DELETE CASCADE,
	SoLuongN	int,
	DonGia		money,
	PRIMARY KEY(SoHDN, MaSP)
)
CREATE TABLE PXuat(
	SoHDX		char(10) PRIMARY KEY,
	NgayXuat	date NOT NULL DEFAULT GETDATE(),
	MaNV		char(10) FOREIGN KEY(MaNV) REFERENCES NhanVien(MaNV) ON UPDATE CASCADE ON DELETE CASCADE
)
CREATE TABLE Xuat(
	SoHDX		char(10) FOREIGN KEY(SoHDX) REFERENCES PXuat(SoHDX) ON UPDATE CASCADE ON DELETE CASCADE,
	MaSP		char(10) FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP) ON UPDATE CASCADE ON DELETE CASCADE,
	SoLuongX	int check(SoLuongX > 0 AND SoLuongX < 100)
	PRIMARY KEY(SoHDX, MaSP)
)
INSERT INTO HangSX VALUES	('HSX01', N'HẢI HÀ', N'HỒ CHÍ MINH','01234567891', 'HAI@gmail.com'),
							('HSX02', N'HẢI CHÂU', N'HỒ CHÍ MINH','01234567891', 'HAIC@gmail.com'),
							('HSX03', N'HẢI ĐỨC', N'Hà Nội','03214567891', 'HADC@gmail.com'),
							('HSX04', N'HẢI HƯNG', N'Sài Gòn','01432567891', 'HAIH@gmail.com')
SELECT * FROM HangSX
INSERT INTO SanPham VALUES ('SP01','HSX01', N'Kẹo socola', 100, N'nâu', 200000, N'Gói', N'Chất lượng cao'),
 ('SP02','HSX02', N'Kẹo dẻo', 120, N'cam', 100000, N'Gói', N'Chất lượng cao'),
 ('SP03','HSX04', N'Bánh Quy', 150, N'vàng', 150000, N'Hộp', N'Chất lượng cao'),
 ('SP04','HSX04', N'Sữa', 300, N'vàng', 150000, N'Hộp', N'Chất lượng cao')
SELECT * FROM SanPham

INSERT INTO NhanVien VALUES ('NV01',N'Nguyễn Thị Nga', 1, N'HÀ Nội', '02131252312', 'A@gmail.com', N'Phòng nhân sự'),
('NV02',N'Phạm Vũ Anh Đức', 0, N'HÀ Nội', '08690034373', 'D@gmail.com', N'Phòng kinh doanh'),
('NV03',N'Phạm Thị Mai', 1, N'Sài Gòn', '03690034373', 'M@gmail.com', N'Phòng kinh doanh'),
('NV04',N'Phạm Văn Minh', 0, N'Hà Nội', '03940034373', 'Mi@gmail.com', N'Phòng kế hoạch')
SELECT * FROM NhanVien

-- Hàm phiếu nhập
INSERT INTO PNhap VALUES ('HDN01','2022-03-15','NV01'),
('HDN02','2022-03-01','NV04'),
('HDN03','2022-02-12','NV03'),
('HDN04','2022-01-15','NV02')
-- hàm trả về ngày tháng năm hiện tại 
SELECT GETDATE()
SELECT * FROM PNhap

INSERT INTO Nhap VALUES ('HDN01','SP01',3, 4000),
('HDN02','SP04',5, 2000),
('HDN03','SP02',4, 8000),
('HDN04','SP03',6, 7000)
SELECT * FROM Nhap

INSERT INTO PXuat VALUES ('HDX01','2022-01-15','NV01'),
('HDX02','2022-02-11','NV01'),
 ('HDX03','2022-03-10','NV01'),
('HDX04','2022-02-11','NV01')
SELECT * FROM PXuat

INSERT INTO Xuat VALUES ('HDX04','SP02',20),
('HDX01','SP03',25),
('HDX03','SP01',22),
('HDX02','SP02',12),
('HDX03','SP03',5)
SELECT * FROM Xuat


/* Hãy tạo các Trigger kiểm soát ràng buộc toàn vẹn và kiểm tra ràng buộc dữ liệu sau:
- Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng xuất, hãy kiểm tra các ràng buộc toàn 
vẹn: MaSP có trong bảng sản phẩm chưa? kiểm tra các ràng buộc dữ liệu: SoLuongX < 
SoLuong trong bảng SanPham? Sau khi xuất thì SoLuong ở bảng SanPham sẽ được cập 
nhật theo. */
Create Trigger trg_insertXuat
On Xuat
For Insert
As
Begin
		Declare @MaSP nvarchar(10)
		Declare @slx int, @SoLuong float
		Select @MaSP=MaSP,@slx=SoLuongX From Inserted 
		If(Not Exists(Select * From SanPham Where MaSP = @MaSP))
			Begin
				Raiserror(N’Không tồn tại sản phẩm trong danh mục sản phẩm’,16,1)
				Rollback Transaction
			End
		Else
			Begin
				Select @SoLuong = SoLuong From SanPham Where MaSP = @MaSP
				If(@slx>@SoLuong)
					Begin
						Raiserror(N’Không đủ số lượng sản phẩm để xuất’,16,1)
						Rollback Transaction
					End
				Else 
					Update SanPham set SoLuong = SoLuong - @slx
					From SanPham Where MaSP = @MaSP
			End
End
--Thực thi Trigger:
Select * From SanPham
Select * From NhanVien
Select * From Xuat
--Sai số lượng
Insert Into xuat Values('X01' , 'SP01', 600)
--Đúng
Insert Into xuat Values('X01' , 'SP01' , 170) 
Select * From SanPham
Select * From Xuat