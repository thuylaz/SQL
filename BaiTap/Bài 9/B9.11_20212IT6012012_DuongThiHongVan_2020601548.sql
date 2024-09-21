create database qlbanhang4
go
use qlbanhang4
go
create table SanPham
(
	MaSP nchar(10) not null primary key,
	MaHangSX nchar(10) not null foreign key (MaHangSX) references HangSX(MaHangSX) on update cascade on delete cascade,
	TenSP nvarchar(20) not null,
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan money,
	DonViTinh nchar(10),
	MoTa nvarchar(max)
)
create table HangSX
(
	MaHangSX nchar(10) not null primary key,
	TenHang nvarchar(20) not null,
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30)
)
create table NhanVien
(
	MaNV nchar(10) not null primary key,
	TenNV nvarchar(20) not null,
	GioiTinh nchar(10) not null,
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30),
	TenPhong nvarchar(30)
)
create table Nhap
(
	SoHDN nchar(10) not null foreign key(SoHDN) references PNhap(SoHDN) on update cascade on delete cascade,
	MaSP nchar(10), not null foreign key(MaSP) references SanPham(MaSP) on update cascade on delete cascade,
	primary key(SoHDN, MaSP), 
	SoLuongN int,
	DonGiaN money
)
create table PNhap
(
	SoHDN nchar(10) not null primary key,
	NgayNhap date,
	MaNV nchar(10) not null foreign key(MaNV) references NhanVien(MaNV) on update cascade on delete cascade
)
create Xuat
(
	SoHDX nchar(10) not null foreign key(SoHDX) references PXuat(SoHDX) on update cascade on delete cascade, 
	MaSP nchar(10) not null foreign key(MaSP) references SanPham(MaSP) on update cascade on delete cascade,
	primary key(SoHDX, MaSP),
	SoLuongX int
)
create PXuat
(
	SoHDX nchar(10) not null primary key,	
	NgayXuat date,
	MaNV nchar(10) not null foreign key(MaNV) references NhanVien(MaNV) on update cascade on delete cascade
)

insert into HangSX values('H01','Samsung','Korea','011-08271717','ss@gmail.com.kr')
insert into HangSX values('H02','OPPO','China','081-08626262','oppo@gmail.com.cn')
insert into HangSX values('H03','Samsung','Korea','011-08271717','vf@gmail.com.vn')
insert into NhanVien values ('NV01',N'Nguyễn Thị Thu',N'Nữ',N'Hà Nội','0982626521','thu@gmail.com',N'Kế toán')
insert into NhanVien values ('NV02',N'Lê Văn Nam',N'Nam',N'Bắc Ninh','0972525252','nam@gmail.com',N'Vật tư')
insert into NhanVien values ('NV03',N'Trần Hòa Bình',N'Nữ',N'Hà Nội','03283883881','hb@gmail.com',N'Kế toán')
insert into SanPham values ('SP01','H02','F1 Plus',100,N'Xám',7000000,N'Chiếc',N'Hàng cận cao cấp')
insert into SanPham values ('SP02','H01','Galaxy Note11',50,N'Đỏ',19000000,N'Chiếc',N'Hàng cao cấp')
insert into SanPham values ('SP03','H02','F3 lite',200,N'Nâu',3000000,N'Chiếc',N'Hàng phổ thông')
insert into SanPham values ('SP04','H03','vojoy3',200,N'Xám',1500000,N'Chiếc',N'Hàng phổ thông')
insert into SanPham values ('SP05','H01','Galaxy V21',500,N'Nâu',8000000,N'Chiếc',N'Hàng cận cao cấp')
insert into PNhap values('N01','02-05-2019','NV01')
insert into PNhap values('N02','04-07-2020','NV02')
insert into PNhap values('N03','05-17-2020 ','NV02')
insert into PNhap values('N04','03-22-2020 ','NV03')
insert into PNhap values('N05','07-07-2020','NV01')
insert into Nhap values ('N01','SP02',10,17000000)
insert into Nhap values ('N02','SP01',30,60000000)
insert into Nhap values ('N03','SP04',20,1200000)
insert into Nhap values ('N04','SP01',10,6200000)
insert into Nhap values ('N05','SP05',20,70000000)
insert into PXuat values ('X01','06-14-2020','NV02')
insert into PXuat values ('X02','03-05-2019','NV03')
insert into PXuat values ('X03','12-12-2020','NV01')
insert into PXuat values ('X04','06-02-2020','NV02')
insert into PXuat values ('X05','05-18-2020','NV01')
insert into Xuat values ('X01','SP03',5)
insert into Xuat values ('X02','SP01',3)
insert into Xuat values ('X03','SP02',1)
insert into Xuat values ('X04','SP03',2)
insert into Xuat values ('X05','SP05',1)
select *from HangSX
select *from NhanVien
select *from SanPham
select*from PNhap
select*from Nhap
select *from PXuat
select*from Xuat

/* a (3đ). Viết thủ tục nhập dữ liệu cho bảng xuat với các tham biến SoHDX, MaSP, manv, 
NgayXuat, SoLuongX. Kiểm tra xem MaSP có tồn tại trong bảng SanPham hay không? 
manv có tồn tại trong bảng NhanVien hay không? SoLuongX <= SoLuong? Nếu không thì 
thông báo, ngược lại thì hãy kiểm tra: Nếu SoHDX đã tồn tại thì cập nhật bảng Xuat theo 
SoHDX, ngược lại thêm mới bảng Xuat.*/
alter proc caua_p3(

	@SoHDX nchar(10),
	@MaSP nchar(10) ,
	@MaNV nchar(10),
	@NgayXuat datetime,
	@SoLuongX int,
	@kq int output
	
)
as
begin
	declare @SoLuong int
	if(not exists(select*from SanPham where MaSP=@MaSP))
	 set @kq=1
	else if(not exists(select* from NhanVien where @MaNV=MaNV))
	 set @kq=2
	else if (not exists (select @SoLuong from SanPham inner join Xuat on Xuat.MaSP=SanPham.MaSP where @SoLuong=@SoLuongX  ))
	 set @kq=3
	else
		begin
			set @kq=0 
			if(exists(select*from Xuat where SoHDX=@SoHDX))
			update Xuat set MaSP=@MaSP,SoLuongX=@SoLuongX where SoHDX=@SoHDX
			else
			insert into Xuat values(@SoHDX,@MaSP,@SoLuongX)
		end
		return @kq
end
----Gọi thủ tục
insert into PXuat values ('X10','2019/2/9','NV03')
---TH sản phẩm không tồn tại
declare @KQ7 int 
exec caua_p3 'X06','SP10','NV02','2019/2/9',2,@KQ7 output
select @KQ7
---TH nhân viên không tồn tại:
declare @KQ7 int 
exec caua_p3 'X06','SP02','NV10','2019/2/9',2,@KQ7 output
select @KQ7
---TH So luong xuat > So luong :
declare @KQ7 int 
exec caua_p3 'X09','SP02','NV02','2019/2/9',-2,@KQ7 output
select @KQ7
---TH cập nhật:
declare @KQ7 int 
exec caua_p3 'X01','SP02','NV02','2019/2/9',12,@KQ7 output
select @KQ7
--TH thêm mới:
declare @KQ7 int 
exec caua_p3 'X10','SP03','NV03','2019/2/9',2,@KQ7 output
select @KQ7
select*from Xuat

/* b (3đ). Viết thủ tục xóa dữ liệu bảng NhanVien với tham biến là manv. Nếu manv chưa có 
thì thông báo, ngược lại xóa NhanVien với NhanVien bị xóa là manv. (Lưu ý: xóa 
NhanVien thì phải xóa các bảng Nhap, Xuat mà nhân viên này tham gia).*/
create proc caub_p3(@MaNV nchar(10), @kq int output)
as
begin
	if(not exists(select*from NhanVien where MaNV=@MaNV))
		set @kq=1
	else
		begin
			set @kq=0
			delete from PNhap where MaNV=@MaNV
			delete from PXuat where MaNV=@MaNV
			delete from NhanVien where MaNV=@MaNV
		end
		return @kq
end
---Gọi thủ tục
--TH MaNV chưa tồn tại:
declare @KQ3 int
exec caub_p3 'NV10',@KQ3 output
select @KQ3
--TH xóa MaNV:
declare @KQ3 int
exec caub_p3 'NV01',@KQ3 output
select @KQ3

/*c (4đ). Viết thủ tục xóa dữ liệu bảng SanPham với tham biến là MaSP. Nếu MaSP chưa có 
thì thông báo, ngược lại xóa SanPham với SanPham bị xóa là MaSP. (Lưu ý: xóa SanPham
thì phải xóa các bảng Nhap, Xuat mà SanPham này cung ứng).*/
create proc cauc_p3(@MaSP nchar(10),@kq int output)
as
begin
	if(not exists(select*from SanPham where MaSP=@MaSP))
		set @kq=1
	else
		begin
		set @kq=0
		delete from Nhap where MaSP=@MaSP
		delete from Xuat where MaSP=@MaSP
		delete from SanPham where MaSP=@MaSP
		end
		return @kq
end
---Gọi thủ tục
--TH không tồn tại:
declare @KQ4 int
exec cauc_p3 'SP12',@KQ4 output
select @KQ4
--TH tồn tại:
declare @KQ4 int
exec cauc_p3 'SP02',@KQ4 output
select @KQ4
