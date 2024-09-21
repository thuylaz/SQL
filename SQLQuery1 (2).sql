use master 
go
create database QLBH
on primary(
   name= 'QLBH_dat',
   filename= 'D:\QLBH.mdf',
   size= 10MB,
   maxsize= 100MB,
   filegrowth= 10MB
)

log on(
   name= 'QLBH_log',
   filename= 'D:\QLBH.ldf',
   size= 1MB,
   maxsize= 5MB,
   filegrowth= 20%
)

go
use QLBH
go
create table CongTy(
	MaCT nchar(10) not null primary key,
	TenCT nvarchar(20) not null,
	TrangThai nchar(10),
	ThanhPho nvarchar(20)
)

create table SanPham(
	MaSP nchar(10) not null primary key,
	TenSP nvarchar(20),
	MauSac nchar (10) default N'Đỏ',
	Gia money,
	SoLuongCo int,
	constraint unique_SP unique(TenSp)
)

create table CungUng(
	MaCT nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuongBan int,
	constraint PK_CungUng Primary key(MaCT, MaSP),
	constraint chk_SLB check(SoLuongBan>0),
	constraint FK_CU_SP foreign key(MaSP)
	references SanPham(MaSP),
	constraint FK_CU_SP foreign key(MaCT)
	references CongTy(MaCT)
)



	



