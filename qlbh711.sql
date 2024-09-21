create database qlbh711

go
use qlbh711
go

create table hangsx(
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
	references hangsx(mahangsx)
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

insert into hangsx values
('H01','Samsung','Korea',01108271717,'ss@gmail.com.kr'),
('H02','OPPO','China',08108626262,'oppo@gmail.com.cn'),
('H03','Vinfone',N'Việt Nam',0840982626,'vf@gmail.com.vn')

insert into nv values
('NV01', N'Nguyễn Thị Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@gmail.com', N'Kế toán'),
('NV02', N'Lê VănNam', 'Nam', N'Bắc Ninh', '0972525252', 'nam@gmail.com', N'Vật tư'),
('NV03', N'TrầnHòaBình', N'Nữ', N'Hà Nội', '0328388388', 'hb@gmail.com', N'Kế toán')


insert into sanpham values
('SP01', 'H02', 'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp'),
('SP02', 'H01', 'Galaxy Note 11', 50, N'đỏ', 19000000, N'Chiếc', N'Hàng cao cấp'),
('SP03', 'H02', 'F3 lite', 200, N'nâu', 3000000, N'Chiếc', N'Hàng phổ thông'),
('SP04', 'H03', 'Vjoy3', 200, N'Xám', 1500000, N'Chiếc', N'Hàng phổ thông'),
('SP05', 'H01', 'Galaxy V21', 500, N'nâu', 8000000, N'Chiếc', N'Hàng cận cao cấp')


insert into pnhap values
('N01', '02-05-2019', 'NV01'),
('N02', '04-07-2019', 'NV02'),
('N03', '05-17-2019', 'NV02'),
('N04', '03-22-2019', 'NV03'),
('N05', '07-07-2019', 'NV01')

insert into Nhap values
('N01', 'SP02', 10, 17000000),
('N02', 'SP01', 30, 6000000),
('N03', 'SP04', 20, 1200000),
('N04', 'SP01', 10, 6200000),
('N05', 'SP05', 20, 7000000)


insert into pxuat values
('X01', '06-14-2020', 'NV02'),
('X02', '03-05-2020', 'NV03'),
('X03', '12-12-2020', 'NV01'),
('X04', '06-02-2020', 'NV02'),
('X05', '05-18-2020', 'NV01')

insert into Xuat values
('X01', 'SP03', 5),
('X02', 'SP01', 3),
('X03', 'SP02', 1),
('X04', 'SP03', 2),
('X05', 'SP05', 1)


--function
--a
create function a(@a nvarchar(20), @x datetime)
returns int
as
begin
declare @gtx int
set @gtx= (select sum(slx*gia)
				from sanpham join Xuat
				on sanpham.masp= Xuat.masp
				join pxuat on pxuat.sohdx= Xuat.sohdx
				join hangsx on hangsx.mahangsx= sanpham.mahangsx
				where tenhang=@a and year(ngayxuat)= @x)
return @gtx;
end

select dbo.a('OPPO', 2020)

--b
create function b(@tp nvarchar(30))
returns int
as
begin
declare @thongke int
set @thongke= (select count(manv)
				from nv
				where tenphong=@tp
				group by tenphong)
return @thongke
end

select dbo.b(N'Kế toán')


--c
create function c(@x nvarchar(20), @y datetime)
returns int
as
begin
declare @dem int
set @dem= (select count(sanpham.masp)
					from sanpham join Xuat
					on sanpham.masp= Xuat.masp
					join pxuat on pxuat.sohdx= Xuat.sohdx
					where tensp= @x and day(ngayxuat)=@y)
return @dem
end

select dbo.c('Galaxy Note 11',12)

--d
create function d(@hdx nchar(10))
returns nvarchar(20)
as
begin
declare @sddt nvarchar(20)
set @sddt= (select sodt
				from nv join pxuat
				on nv.manv= pxuat.manv
				where sohdx= @hdx)
return @sddt
end

select dbo.d('X03')

--e
create function e(@x nvarchar(20), @y datetime)
returns int
as
begin
declare @td int
set @td= (select sln-slx
			from Nhap join Xuat
			on Nhap.masp= Xuat.masp
			join sanpham on sanpham.masp= Xuat.masp
			join pxuat on Xuat.sohdx= pxuat.sohdx
			where tensp=@x and year(ngayxuat)=@y)
return @td
end

select dbo.e('Galaxy Note 11', 2020)

--f
create function f(@x nvarchar(20))
returns int 
as
begin 
declare @sl int 
set @sl= (select count(masp)
				from hangsx join sanpham
				on hangsx.mahangsx= sanpham.mahangsx
				where tenhang=@x)
return @sl
end

select dbo.f('OPPO')

