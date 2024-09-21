use master
go
create database quanlbh
on primary(
	name= 'quanlbh_dat',
	filename= 'D:\quanlbh.mdf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

log on(
	name= 'quanlbh_log',
	filename= 'D:\quanlbh.ldf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

go
use quanlbh
go

create table Hangthuysx(
	mahangsx nchar(10) not null primary key,
	tenhang nvarchar(20),
	diachi nvarchar(10),
	sodt nvarchar(10),
	email nvarchar(30)
)

create table nv(
	manv nchar(10) not null primary key,
	tennv nvarchar(20),
	gioitinh nchar(10),
	diachi nvarchar(30),
	sodt nvarchar(20),
	email nvarchar(30),
	tenphong nvarchar(30)
)

create table sanpham(
	masp nchar(10) not null primary key,
	mahangsx nchar(10) not null,
	tensp nvarchar(20),
	sl int,
	mau nvarchar(20),
	gia money,
	donvitinh nchar(10),
	mota nvarchar(max),
	constraint fk_sp_hsx foreign key(mahangsx)
	references Hangthuysx(mahangsx)
)

create table pnhap(
	sohdn nchar(10) not null primary key,
	ngaynhap date,
	manv nchar(10) not null,
	constraint fk_pn_nhanvien foreign key(manv)
	references nv(manv)
)

create table Nhap(
	sohdn nchar(10) not null,
	masp nchar(10) not null,
	sln int,
	dongian money,
	constraint pk_nhap primary key(sohdn, masp),
	constraint fk_nhap_pnhap foreign key(sohdn)
	references pnhap(sohdn),
	constraint fk_nhap_sp foreign key(masp)
	references sanpham(masp)
)

create table pxuat(
	sohdx nchar(10) not null primary key,
	ngayxuat date,
	manv nchar(10)
	constraint fk_px_nhanvien foreign key(manv)
	references nv(manv)
)

create table Xuat(
	sohdx nchar(10) not null,
	masp nchar(10) not null,
	slx int,
	constraint pk_xuat primary key(sohdx,masp),
	constraint fk_xuat_pxuat foreign key(sohdx)
	references pxuat(sohdx),
	constraint fk_xuat_sp foreign key(masp)
	references sanpham(masp)
)

insert into Hangthuysx values
('H01','Samsung','Korea',01108271717,'ss@gmail.com.kr'),
('H02','OPPO','China',08108626262,'oppo@gmail.com.cn'),
('H03','Vinfone',N'Việt Nam',0840982626,'vf@gmail.com.vn')

insert into nv values
('NV01', N'Nguyễn Thị Thu', 'Nữ', N'Hà Nội', 0982626521, 'thu@gmail.com', N'Kế toán'),
('NV02', N'Nguyễn Thị Thu', 'Nữ', N'Hà Nội', 0982626521, 'thu@gmail.com', N'Kế toán'),
('NV03', N'Nguyễn Thị Thu', 'Nữ', N'Hà Nội', 0982626521, 'thu@gmail.com', N'Kế toán')

insert into sanpham values
('SP01', 'H02', 'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp'),
('SP02', 'H02', 'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp'),
('SP03', 'H02', 'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp'),
('SP04', 'H02', 'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp'),
('SP05', 'H02', 'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp')


insert into pnhap values
('N01', '02-05-2019', 'NV01'),
('N02', '02-05-2019', 'NV02'),
('N03', '02-05-2019', 'NV02'),
('N04', '02-05-2019', 'NV03'),
('N05', '02-05-2019', 'NV01')

insert into Nhap values
('N01', 'SP02', 10, 17000000),
('N02', 'SP02', 10, 17000000),
('N03', 'SP02', 10, 17000000),
('N04', 'SP02', 10, 17000000),
('N05', 'SP02', 10, 17000000)


insert into pxuat values
('X01', '06-14-2020', 'NV02'),
('X02', '06-14-2020', 'NV02'),
('X03', '06-14-2020', 'NV02'),
('X04', '06-14-2020', 'NV02'),
('X05', '06-14-2020', 'NV02')

insert into Xuat values
('X01', 'SP03', 5),
('X02', 'SP03', 5),
('X03', 'SP03', 5),
('X04', 'SP03', 5),
('X05', 'SP03', 5)


select*from Hangthuysx
select*from sanpham
select*from nv
select*from pnhap
select*from Nhap
select*from pxuat
select*from Xuat

update Hangthuysx 
set sodt= 084262626
where mahangsx= 'H03'
select * from Hangthuysx



