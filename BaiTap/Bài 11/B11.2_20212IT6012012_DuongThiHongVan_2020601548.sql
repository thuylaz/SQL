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

/* a (1đ). Tạo Trigger cho việc cập nhật lại số lượng xuất trong bảng xuất, hãy kiểm tra xem
số lượng xuất thay đổi có nhỏ hơn SoLuong trong bảng SanPham hay ko? số bản ghi thay
đổi >1 bản ghi hay không? nếu thỏa mãn thì cho phép Update bảng xuất và Update lại
SoLuong trong bảng SanPham.*/
create trigger trg_updateXuat
on Xuat
for update 
as
begin
	if(@@ROWCOUNT>1) --hàm hệ thống trả về số Record sẽ bị cập nhật
		begin
			raiserror(N'Không được cập nhật nhiều honw 1 bản ghi cùng lúc',16,1)
			rollback transaction
		end
	else
		begin
			declare @truoc int, @sau int, @slco int
			declare @MaSP nvarchar(10)
				select @truoc = SoLuongX, @MaSP = MaSP from deleted
				select @sau = SoLuongX from inserted
				select @slco = SoLuong from SanPham where MaSP=@MaSP
				if(@truoc<>@sau) --if(update(SoLuongX))
					begin 
						if(@slco<(@sau-@truoc))
							begin
								raiserror(N'Không đủ hàng xuất',16,1)
								rollback transaction
							end
						else
							update SanPham set SoLuong = SoLuong -(@sau-@truoc)
							from SanPham
							where MaSP=@MaSP
					end
		end
end
--Thực thi trigger
select * from SanPham
select * from Xuat
--TH nhiều hơn 1 bản ghi
update Xuat set SoLuongX=10 where MaSP='SP02'
--TH không đủ số lượng
update Xuat set  SoLuongX=1000 where MaSP='SP05'
--TH đúng
update Xuat set SoLuongX=10 where MaSP='SP05'
disable trigger  trg_updateXuat on Xuat

/* b (1đ). Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng nhập, hãy kiểm tra các ràng buộc
toàn vẹn: MaSP có trong bảng sản phẩm chưa? Kiểm tra các ràng buộc dữ liệu: SoLuongN
và DonGiaN>0? Sau khi nhập thì SoLuong ở bảng SanPham sẽ được cập nhật theo.*/
create trigger trg_Nhap
on Nhap
for insert
as 
begin
	declare @MaSP char(10), @MaNV char(10)
	declare @sln int, @dgn float
	select @MaSP=MaSP, @sln=SoLuongN, @dgn=DonGia from inserted
	if(not exists(select * from SanPham where MaSP=@MaSP))
		begin
			raiserror(N'Không tồn tại sản phẩm trong danh mục sản phẩm', 16,1)
			rollback transaction
		end
	else 
		if(@sln<=0 or @dgn<=0)
			begin
				raiserror(N'Nhập sai SoLuong hoặc DonGia',16,1)
				rollback transaction
			end
		else  -- Bây giờ mới được phép nhập, khi này cần thay đổi SoLuong --trong bảng SanPham
			update SanPham set SoLuong=SoLuong + @sln
			from SanPham where MaSP=@MaSP
end
--Thực thi Trigger
insert into Nhap values('HDN01', 'SP01', 300, 1500000)
select * from Nhap
select * from SanPham

/*c (2đ). Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng xuất, hãy kiểm tra các ràng buộc
toàn vẹn: MaSP có trong bảng sản phẩm chưa? kiểm tra các ràng buộc dữ liệu: SoLuongX
< SoLuong trong bảng SanPham? Sau khi xuất thì SoLuong ở bảng SanPham sẽ được cập
nhật theo.*/ 
create trigger trg_insertXuat
on Xuat
for insert
as
	begin
		declare @MaSP nvarchar(10)
		declare @slx int, @SoLuong float
		select @MaSP=MaSP, @slx=SoLuongX from inserted
		if(not exists(select * from SanPham where MaSP=@MaSP))
			begin
				raiserror(N'Không tồn tại sản phẩm trong danh mục sản phẩm',16,1)
				rollback transaction
			end
		else
			begin
				select @SoLuong=SoLuong from SanPham where MaSP=@MaSP
				if(@slx>@SoLuong)
					begin
						raiserror(N'Không đủ số lượng sản phẩm để xuất',16,1)
						rollback transaction
					end
				else 
					update SanPham set SoLuong=SoLuong-@slx
					from SanPham where MaSP=@MaSP
			end
	end
--Thực thi Trigger
Insert Into Xuat Values('HDX01','SP02',70)
Select * From SanPham
Select * From Xuat
/* d (2đ). Tạo Trigger kiểm soát việc xóa phiếu xuất, khi phiếu xuất xóa thì số lượng hàng
trong bảng SanPham sẽ được cập nhật tăng lên.*/
create trigger trg_deleteXuat
on Xuat
for delete
as
begin
	declare @MaSP char(10)
	declare @slx int
	select @MaSP=MaSP, @slx= SoLuongX from deleted
	if(not exists(select * from SanPham where MaSP=@MaSP))
		begin
			raiserror(N'Không tồn tại sản phẩm trong danh mục sản phẩm', 16, 1)
			rollback transaction
		end
	else
		update SanPham set SoLuong=SoLuong + @slx
		from SanPham where MaSP=@MaSP
end
--Thực thi Trigger

/* e (2đ). Tạo Trigger cho việc cập nhật lại số lượng Nhập trong bảng Nhập, Hãy kiểm tra
xem số bản ghi thay đổi >1 bản ghi hay không? nếu thỏa mãn thì cho phép Update bảng
Nhập và Update lại SoLuong trong bảng SanPham.*/

/*f (2đ). Tạo Trigger kiểm soát việc xóa phiếu nhập, khi phiếu nhập xóa thì số lượng hàng
trong bảng SanPham sẽ được cập nhật giảm xuống.*/
create trigger trg_deleteNhap
on Nhap
for delete
as
begin
	declare @sln int, @MaSP char(10), @SoLuong int
	select @MaSP=MaSP, @sln=SoLuongN from deleted
	if(not exists(select * from SanPham where MaSP=@MaSP))
		begin 
			raiserror(N'Không có sản phẩm',16,1)
			rollback transaction
		end
	else 
		update SanPham set SoLuong=SoLuong-@sln
		from SanPham where MaSP=@MaSP
end
--Thực thi trigger
select * from SanPham
select * from Nhap
--TH không có sản phẩm
delete from Nhap where MaSP='SP06'
--TH đúng
delete from Nhap where SoHDN='HDN03'