use master
go
if (exists(select * from sysdatabases where name ='QLNV'))
drop database QLNV
go
create database QLNV
on primary (
name='QLNV_dat', filename='E:\QLNV.mdf', size=2MB, maxsize=10MB, filegrowth=20%)
log on (name='QLNV_log', filename='E:\QLNV.ldf', size=1MB, maxsize=5MB, filegrowth=1MB)
go
use QLNV
go

--tao bang
create table ChucVu
(MaCV nvarchar(2) not null primary key,
TenCV nvarchar(30) not null
)
drop table ChucVu

create table NhanVien
(MaNV nvarchar(4) not null primary key,
MaCV nvarchar(2) not null,
TenNV nvarchar(30) not null,
NgaySinh datetime not null check(NgaySinh<=getdate()),
LuongCanBan float not null check(LuongCanBan>0),
NgayCong int not null check(NgayCong>0 and NgayCong<31),
PhuCap float not null check(PhuCap>=0),
constraint fk foreign key(MaCV) references Chucvu(MaCV) on update cascade on delete cascade
)
drop table NhanVien

--chen du lieu
INSERT INTO ChucVu 
(MaCV, TenCV)
VALUES
('BV', 'Bao Ve'),
('GD', 'Giam Doc'),
('HC', 'Hanh Chinh'),
('KT', 'Kiem Tra'),
('TQ', 'Thu Quy'),
('VS', 'Ve Sinh');

INSERT INTO NhanVien
(MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
VALUES
('NV01', 'GD', 'Nguyen Van An', '12/12/1977', 700000, 25, 500000), 
('NV02', 'BV', 'Bui Van Ti', '10/10/1978', 400000, 24, 100000),
('NV03', 'KT', 'Tran Thanh Nhat', '9/9/1977', 600000, 26, 400000),
('NV04', 'VS', 'Nguye Thi Ut', '10/10/1980', 300000, 26, 300000),
('NV05', 'HC', 'Le Thi Ha', '10/10/1979', 500000, 27, 200000);

select * from ChucVu
select * from NhanVien

--câu a
create proc sp_them_nhan_vien
	(@MaNV nvarchar(4),
	@MaCV nvarchar(2),
	@TenNV nvarchar(30),
	@NgaySinh datetime,
	@LuongCanBan float,
	@NgayCong int,
	@PhuCap float
	)
as
	begin
		if (not exists(select * from ChucVu where MaCV = @MaCV)) 
			print N'Không có chức vụ này trong bảng'
		else
			if(@NgayCong > 30)
				print N'Nhập sai ngày công'
			else 
				insert into NhanVien values
				(@MaNV,
				@MaCV,
				@TenNV,
				@NgaySinh,
				@LuongCanBan,
				@NgayCong,
				@PhuCap
				)
	end
drop proc sp_them_nhan_vien
--test khong co chuc vu
exec sp_them_nhan_vien 'NV01', 'HH', 'Nguyen Van An', '12/12/1977', 700000, 25, 500000
--test nhap sai ngay cong
exec sp_them_nhan_vien 'NV01', 'GD', 'Nguyen Van An', '12/12/1977', 700000, 35, 500000
--test insert
exec sp_them_nhan_vien 'NV06', 'TQ', 'Nguyen Van Binh', '12/12/1978', 800000, 28, 400000
select * from NhanVien

--câu b
create proc sp_capnhat_nhan_vien
	(@MaNV nvarchar(4),
	@MaCV nvarchar(2),
	@TenNV nvarchar(30),
	@NgaySinh datetime,
	@LuongCanBan float,
	@NgayCong int,
	@PhuCap float
	)
as
	begin
		if (not exists(select * from ChucVu where MaCV = @MaCV)) 
			print N'Không có chức vụ này trong bảng'
		else
			if(@NgayCong > 30)
				print N'Nhập sai ngày công'
			else 
				update NhanVien set
				MaNV = @MaNV,
				MaCV = @MaCV,
				TenNV = @TenNV,
				NgaySinh = @NgaySinh,
				LuongCanBan = @LuongCanBan,
				NgayCong = @NgayCong,
				PhuCap = @PhuCap
				where MaNV = @MaNV
	end
drop proc sp_capnhat_nhan_vien
--test khong co chuc vu
exec sp_capnhat_nhan_vien 'NV01', 'HH', 'Nguyen Van An', '12/12/1977', 700000, 25, 500000
--test nhap sai ngay cong
exec sp_capnhat_nhan_vien 'NV01', 'GD', 'Nguyen Van An', '12/12/1977', 700000, 35, 500000
--test update
exec sp_capnhat_nhan_vien 'NV05', 'TQ', 'Nguyen Van B', '12/12/1972', 800000, 28, 400000
select * from NhanVien

