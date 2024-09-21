create database QLBanHang62

go
use QLBanHang62
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

--a
create view a
as
select Nhap.sohdn, sanpham.masp, tensp, sln, dongian, ngaynhap, tennv, tenphong
from Nhap join sanpham
on Nhap.masp= sanpham.masp
join pnhap
on pnhap.sohdn= Nhap.sohdn
join hangsx
on hangsx.mahangsx= sanpham.mahangsx
join nv
on pnhap.manv= nv.manv
where tenhang= 'Samsung' and year(ngaynhap)= 2019

select *from a

--b
create view b
as
select sanpham.masp, tensp, gia
from sanpham
where gia between 1000000 and 5000000

select *from b

--c
create view c
as
select sum(sln*dongian) as tong_tien_nhap
from Nhap join pnhap
on Nhap.sohdn= pnhap.sohdn
where year(ngaynhap)= 2019

select *from c

--d
create view d
as
select sum(slx*gia) as tong_tien_xuat
from Xuat join pxuat
on Xuat.sohdx= pxuat.sohdx
join sanpham
on sanpham.masp= Xuat.masp
where ngayxuat= '06-14-2020'

select *from d

--e
create view e
as
select Nhap.sohdn, ngaynhap, sln*dongian as tong_sp
from Nhap join pnhap
on Nhap.sohdn= pnhap.sohdn
where year(ngaynhap)= 2019 and sln*dongian= (select max(sln*dongian)
												from Nhap join pnhap
												on Nhap.sohdn= pnhap.sohdn
												where year(ngaynhap)= 2019)

select *from e

--f
Create view f
as
select hangsx.mahangsx, tenhang, Count(*) As N'Số lượng sp'
from hangsx join sanpham
on sanpham.mahangsx= hangsx.mahangsx
group by hangsx.mahangsx, tenhang

select *from f

--g
create view g
as
select sanpham.masp, tensp, sln*dongian as tong_tien_nhap
from sanpham join Nhap
on sanpham.masp= Nhap.masp
join pnhap
on pnhap.sohdn= Nhap.sohdn
where year(ngaynhap)= 2019

select *from g

--h
create view h
as
select sanpham.masp, tensp, slx
from sanpham join Xuat
on sanpham.masp= Xuat.masp
join pxuat
on Xuat.sohdx= pxuat.sohdx
join hangsx
on hangsx.mahangsx= sanpham.mahangsx
where year(ngayxuat)= 2020 and slx>0 and tenhang= 'Samsung'

select *from h

--i
create view i
as
select manv, tennv
from nv
where gioitinh= 'Nam'

select *from i

--j
create view j
as
select hangsx.mahangsx, tenhang, sln
from hangsx join sanpham
on hangsx.mahangsx= sanpham.mahangsx
join Nhap
on sanpham.masp= Nhap.masp
join pnhap
on pnhap.sohdn= Nhap.sohdn
where year(ngaynhap)= 2019

select *from j

--k
create view k
as
select nv.manv, tennv, slx*gia as tien_xuat
from nv join pxuat
on nv.manv= pxuat.manv
join Xuat
on Xuat.sohdx= pxuat.sohdx
join sanpham
on sanpham.masp= Xuat.masp
where year(ngayxuat)= 2020

select *from k
