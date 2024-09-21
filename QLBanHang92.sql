create database QLBanHang92

go
use QLBanHang92
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
create proc a(@msp nchar(10), @mh nchar(10), @tsp nvarchar(20), @sll int, @maus nvarchar(20), @g money, @dvt nchar(10), @mta nvarchar(max))
as
begin
	if(exists(select *from sanpham where masp=@msp))
		update sanpham set mahangsx=@mh, 
		tensp= @tsp, 
		sl= @sll, 
		mau= @maus, 
		gia= @g, 
		donvitinh= @dvt, 
		mota= @mta
		where masp=@msp
	else 
	begin
		insert into sanpham
		values(@msp, @mh, @tsp, @sll, @maus, @g, @dvt, @mta)
	end
end

exec a 'SP06', 'H01', 'Galaxy Note 11', 50, N'đỏ', 19000000, N'Chiếc', N'Hàng cao cấp'
exec a 'SP02', 'H01', 'Galaxy Note 10', 50, N'đỏ', 19000000, N'Chiếc', N'Hàng cao cấp'
select *from sanpham

--b
create proc b(@tenh nvarchar(20))
as
begin
	if(not exists(select *from hangsx where tenhang=@tenh))
		print('ten hang nay chua co')
	else
		begin
			declare @mahang nchar(10)
			select @mahang= mahangsx from hangsx where tenhang=@tenh
			delete from Nhap where masp in (select distinct masp from Nhap)
			delete from Xuat where masp in (select distinct masp from Xuat)			
			delete from sanpham where mahangsx=@mahang
			delete from hangsx where mahangsx=@mahang
		end
end

exec b N'Samsung'
select *from hangsx
select *from sanpham

--c
create proc c(@mnv nchar(10), @tnv nvarchar(20), @gt nchar(10), @dc nvarchar(30), @sdt nvarchar(20), @e nvarchar(30), @tenp nvarchar(30), @flag int)
as
begin
	if(@flag=0)
		update nv set tennv=@tnv,
					gioitinh=@gt,
					diachi=@dc,
					sodt=@sdt,
					email=@e,
					tenphong=@tenp
				where manv=@mnv
	else
		insert into nv
			values(@mnv, @tnv, @gt, @dc, @sdt, @e, @tenp)
end


exec c 'NV04', N'Lê Văn Nam', 'Nam', N'Bắc Ninh', '0972525252', 'nam@gmail.com', N'Vật tư', 1
select *from nv		

--d
create proc d(@shdn nchar(10), @msp nchar(10), @slnn int, @dgn money, @mnv nchar(10), @ngayn date)
as
begin
	if(not exists(select *from sanpham where masp=@msp))
		print('san pham nay khong co')
	else
		if(not exists(select *from nv where manv=@mnv))
		print('nhan vien nay khong co')
	else
		if(exists(select *from Nhap where sohdn=@shdn))
		begin
			update Nhap set masp=@msp,
							sln=@slnn,
							dongian=@dgn
					where sohdn=@shdn
			update pnhap set ngaynhap= @ngayn,
							manv=@mnv
							where sohdn=@shdn

		end
		else
		begin
			insert into Nhap 
			values(@shdn, @msp, @slnn, @dgn)
			insert into pnhap
			values(@shdn, @ngayn, @mnv)
		end
end

exec d 'N01', 'SP02', 10, 17000000, 'NV01', '02-05-2019'
select *from Nhap
select *from pnhap

--b2
--a
create proc aa(@msp nchar(10), @mh nchar(10), @tsp nvarchar(20), @sll int, @maus nvarchar(20), @g money, @dvt nchar(10), @mta nvarchar(max), @flag int, @kq int out)
as
begin
	if(not exists(select *from hangsx where mahangsx=@mh))
		set @kq=1
	else if(@sll<0)
		set @kq=2
	else	
		if(@flag=0)
			insert into sanpham 
			values(@msp, @mh, @tsp, @sll, @maus, @g, @dvt, @mta)
		else 
			update sanpham set mahangsx=@mh, 
					tensp= @tsp, 
					sl= @sll, 
					mau= @maus, 
					gia= @g, 
					donvitinh= @dvt, 
					mota= @mta
					where masp=@msp
end

declare @bien1 int
exec aa 'SP01', 'h02', 'F3 lite', 200, N'nâu', 3000000, N'Chiếc', N'Hàng phổ thông', 1, @bien1 out
select @bien1
select *from sanpham

--b
create proc bb(@mnv nchar(10), @kq int out)
as
begin
	if(not exists(select *from nv where manv=@mnv))
		set @kq=1
	else
	begin
		delete from pnhap where manv= @mnv
		delete from pxuat where manv= @mnv
		delete from nv where manv= @mnv
		set @kq=0
	end
end

declare @bien3 int
exec bb 'NV01', @bien3 out

select *from nv
		
--c
create proc cc(@msp nchar(10), @kq int out)
as
begin
	if(not exists(select *from sanpham where masp=@msp))
		set @kq=1
	else
		begin
			delete from Nhap where masp=@msp
			delete from Xuat where masp=@msp
			delete from sanpham where masp=@msp
			set @kq=0
		end
		
end

declare @bien4 int
exec cc 'SP01', @bien4 out
select @bien4

select *from sanpham