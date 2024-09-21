create database QLBanHang922

go
use QLBanHang922
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


--thu tuc
--a
create proc a(@mahang nchar(10), @tenh nvarchar(20), @dc nvarchar(10), @sdt nvarchar(10), @e nvarchar(30), @kq int out)
as
begin
	if(not exists(select *from hangsx where tenhang=@tenh))
	begin
		insert into hangsx
		values(@mahang, @tenh, @dc, @sdt, @e)
		set @kq=1
	end
	else
		set @kq=0
end

declare @bien int
exec a 'H04', 'NEO', N'Malaysia', 2392932829, 'op@gmail.com.vn', @bien out
select @bien

select *from hangsx

--b
create proc b(@shdn nchar(10), @msp nchar(10), @mnv nchar(10), @ngayn date, @slnn int, @dgn money, @kq int out)
as
begin
	if(not exists(select *from sanpham where masp=@msp))
		set @kq=1
	else
		if(not exists(select *from nv where manv=@mnv))
		set @kq=2
	else
		if(exists(select *from Nhap where sohdn=@shdn))
			begin
				update Nhap set masp=@msp,
							sln=@slnn,
							dongian=@dgn
						where sohdn=@shdn
			end
		else
			begin
				set @kq=0
				insert into Nhap
				values(@shdn,@msp,@slnn,@dgn)
				insert into pnhap
				values(@shdn, @ngayn, @mnv)
				return @kq
			end
			
end

drop proc b

declare @bien int
exec b 'N0988', 'SP02','NV01', '02-05-2019', 10, 17000000,  @bien out
select @bien

select *from Nhap

--c
create proc c(@shdx nchar(10), @msp nchar(10), @mnv nchar(10), @ngayx date, @slxx int, @kq int out)
as
begin
	if(not exists(select *from sanpham where masp=@msp))
		set @kq=1
	else
		if(not exists(select *from nv where manv=@mnv))
		set @kq=2
	else
		if(@slxx>(select slx from Xuat))
			set @kq=3
	else
		if(exists(select *from Xuat where sohdx=@shdx))
			begin
				update Xuat set masp=@msp,
							slx=@slxx
						where sohdx=@shdx
			end
		else
			begin
				set @kq=0
				insert into Xuat
				values(@shdx,@msp,@slxx)
				insert into pxuat
				values(@shdx, @ngayx, @mnv)
			end
end

drop proc c

declare @bien int
exec c 'X0445', 'SP05','NV02', '06-14-2020', 5, @bien out
select @bien

select *from Xuat
select *from pxuat
