use master
go

create database truonghoc
on primary(
	name= 'truonghoc_dat',
	filename= 'D:\SQL\truonghoc.mdf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

log on(
	name= 'truonghoc_log',
	filename= 'D:\SQL\truonghoc.ldf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

go
use truonghoc
go

create table hs(
	mahs char(5) not null primary key,
	ten varchar(30),
	nam bit, 
	ngaysinh datetime,
	diachi varchar(20),
	diemtb float
)

create table gv(
	magv char(5) not null primary key,
	ten varchar(30),
	nam bit, 
	ngaysinh datetime,
	diachi varchar(20),
	luong money
)

create table lop(
	malop char(5) not null primary key,
	tenlop nvarchar(30),
	sl int
)


delete dbo.hs

--Xóa những giáo viên có lương hơn 5000:
delete dbo.gv where luong>5000

--Xóa những học sinh có điểm TB là 1; 8; 9
delete dbo.hs where diemtb in(1,8,9)

--Xóa những học sinh có địa chỉ không phải ở Đà Lạt.delete dbo.hs where diachi not like 'DALAT'

--Cập nhập Lương của tất cả giáo viên thành 10000
UPDATE dbo.gv SET LUONG = 10000
--Cập nhập lương của tất cả giáo viên thành 10000 và địa chỉ tại DALAT
UPDATE dbo.gv SET LUONG = 10000, DIACHI ='DALAT'
--Cập nhập lương của những giáo viên nam thành 1
UPDATE dbo.gv SET LUONG = 1
WHERE Nam='1'
