create database QLBanHang
go 
use QLBanHang
go

create table SanPham(
	MaSP		char(10) primary key,
	MaHangSX	char(10) foreign key (MaHangSX) references MaHangSX(HangSX) on update cascade on delete cascade,
	TenSP		nvarchar(30)not null,
	SoLuong		int,
	MauSac		nvarchar(30),
	GiaBan		money,
	DonViTinh   nvarchar(30),
	MoTa		nvarchar(50)
	)
create table HangSX(
	MaHangSX	char(10) primary key,
	TenHang		nvarchar(30) not null,
	DiaChi		nvarchar(50) not null,
	SoDT		varchar(12) not null,
	Email		varchar(30)	
)
create table NhanVien(
	MaNV		char(10) primary key,
	TenNV		nvarchar(30) not null,
	GioiTinh	bit,
	DiaChi		nvarchar(50),
	SoDT		varchar(12) not null UNIQUE,
	Email		varchar(30),
	TenPhong	nvarchar(30)
)
create table PNhap(
	SoHDN		char(10) primary key,
	NgayNhap	date not null,
	MaNV		char(10) foreign key (MaNV) references NhanVien(MaNV) on update cascade on delete cascade
)
create table Nhap(
	SoHDN		char(10) foreign key (SoHDN) references PNhap(SoHDN)on update cascade on delete cascade,
	MaSP		char(10) foreign key (MaSP) references SanPham(MaSP)on update cascade on delete cascade,
	SoLuongN	int,
	DonGiaN		money,
	primary key(SoHDN, MaSP)
)
create table PXuat(
	SoHDX		char(10) primary key,
	NgayXuat	int not null default getdate(),
	MaNV		char(10) foreign key (MaNV) references NhanVien(MaNV) on update cascade on delete cascade
)
create table Xuat(
	SoHDX		char(10) foreign key (SoHDX) references PXuat(SoHDX)on update cascade on delete cascade,
	MaSP		char(10) foreign key (MaSP) references SanPham(MaSP)on update cascade on delete cascade,
	SoLuongX	int check (SoLuongX >0 and SoLuongX < 100)
	primary key(SoHDX, MaSP)
)
insert into SanPham values	('SP01','HSX01', N'Kẹo socola', 100, N'nâu', 200000, N'Gói', N'Chất lượng cao'),
							('SP02','HSX02', N'Kẹo dẻo', 120, N'cam', 100000, N'Gói', N'Chất lượng cao'),
							('SP03','HSX04', N'Bánh Quy', 150, N'vàng', 150000, N'Hộp', N'Chất lượng cao'),
							('SP04','HSX04', N'Sữa', 300, N'vàng', 150000, N'Hộp', N'Chất lượng cao')

select * from SanPham

insert into HANGSX values	('HSX01', N'HẢI HÀ', N'HỒ CHÍ MINH','01234567891', 'HAI@gmail.com'),
							('HSX02', N'HẢI CHÂU', N'HỒ CHÍ MINH','01234567891', 'HAIC@gmail.com'),
							('HSX03', N'HẢI ĐỨC', N'Hà Nội','03214567891', 'HADC@gmail.com'),
							('HSX04', N'HẢI HƯNG', N'Sài Gòn','01432567891', 'HAIH@gmail.com')
select * from HANGSX

insert into NhanVien values ('NV01',N'Nguyễn Thị Nga', 1, N'HÀ Nội', '02131252312', 'A@gmail.com', N'Phòng nhân sự'),
							('NV02',N'Phạm Vũ Anh Đức', 0, N'HÀ Nội', '08690034373', 'D@gmail.com', N'Phòng kinh doanh'),
							('NV03',N'Phạm Thị Mai', 1, N'Sài Gòn', '03690034373', 'M@gmail.com', N'Phòng kinh doanh'),
							('NV04',N'Phạm Văn Minh', 0, N'Hà Nội', '03940034373', 'Mi@gmail.com', N'Phòng kế hoạch')
select * from NhanVien

insert into PNhap values('HDN01','2022-03-15','NV01'),
						('HDN02','2022-03-01','NV04'),
						('HDN03','2022-02-12','NV03'),
						('HDN04','2022-01-15','NV02')
select * from PNhap

insert into Nhap values ('HDN01','SP01',3, 4000),
						('HDN02','SP04',5, 2000),
						('HDN03','SP02',4, 8000),
						('HDN04','SP03',6, 7000)
select * from Nhap

insert into PXuat values('HDX01','2022-01-15','NV01'),
						('HDX02','2022-02-11','NV01'),
						('HDX03','2022-03-10','NV01'),
						('HDX04','2022-02-11','NV01')
select * from PXuat

insert into Xuat values ('HDX04','SP02',20),
						('HDX01','SP03',25),
						('HDX03','SP01',22),
						('HDX02','SP02',12),
						('HDX03','SP03',5)
select * from Xuat

/* Hãy tạo các Trigger kiểm soát ràng buộc toàn vẹn và kiểm tra ràng buộc dữ liệu sau:
- Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng nhập, hãy kiểm tra các ràng buộc toàn 
vẹn: MaSP có trong bảng sản phẩm chưa? Kiểm tra các ràng buộc dữ liệu: SoLuongN và 
DonGiaN>0? Sau khi nhập thì SoLuong ở bảng SanPham sẽ được cập nhật theo */
create trigger trg_insertNhap
on Nhap
for insert
as
begin
	declare @MaSP char(10)
	declare @sln int, @dgn float
	select @MaSP=MaSP,@sln=SoLuongN,@dgn = DonGiaN From Inserted 
	if(Not Exists(select * from SanPham where MaSP = @MaSP))
	begin
		raiserror(N'Không tồn tại sản phẩm trong danh mục sản phẩm',16,1)
		rollback transaction
	end
	else
	if(@sln<=0 Or @dgn<=0)
	Begin
		raiserror(N'Nhập sai SoLuong hoặc DonGia',16,1)
		rollback transaction
	end
	else 
	update SanPham set SoLuong = SoLuong + @sln
	from SanPham where MaSP = @MaSP
end
--Thực thi Trigger:
-- Gọi dữ liệu 3 bảng liên quan
select * from SanPham
select * from NhanVien
select * from Nhap
-- Nhập sai:
insert into Nhap values('N04','SP02', 0,1500000)
-- Nhập đúng:
insert into Nhap values('N01','SP01', 300,1500000)
select * from nhap
select * from SanPham