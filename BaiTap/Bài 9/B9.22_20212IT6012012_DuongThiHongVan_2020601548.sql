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

/* a (3đ). Tạo thủ tục nhập liệu cho bảng HangSX, với các tham biến truyền vào MaHangSX, 
TenHang, DiaChi, SoDT, Email. Hãy kiểm tra xem TenHang đã tồn tại trước đó hay chưa, 
nếu rồi trả về mã lỗi 1? Nếu có rồi thì không cho nhập và trả về mã lỗi 0.*/
create proc caua_p4(
	@MaHangSX nchar(10) ,
	@TenHang nvarchar(20),
	@DiaChi nvarchar(30) ,
	@SoDT nvarchar(20),
	@Email nvarchar(30))
as
begin
	if(exists(select *from HangSX where TenHang=@TenHang))
		print N'Tồn tại tên hãng'
	else
	begin
		insert into HangSX values (@MaHangSX,@TenHang,@DiaChi,@SoDT,@Email)
			print N'Thêm mới thành công'
	end
end
---Gọi thủ tục
--TH hang tồn tại:
exec caua_p4 'H01',N'SamSung',N'Việt Nam','0123456789','abc@gmail.com'
--TH thêm mới:
exec caua_p4 'H04',N'Nokia',N'Việt Nam','0123456789','abc@gmail.com'

/*b (3đ). Viết thủ tục nhập dữ liệu cho bảng Nhap với các tham biến SoHDN, MaSP, manv, 
NgayNhap, SoLuongN, DonGiaN. Kiểm tra xem MaSP có tồn tại trong bảng SanPham hay 
không, nếu không trả về 1? manv có tồn tại trong bảng NhanVien hay không nếu không trả
về 2? ngược lại thì hãy kiểm tra: Nếu SoHDN đã tồn tại thì cập nhật bảng Nhap theo 
SoHDN, ngược lại thêm mới bảng Nhap và trả về mã lỗi 0.*/
create proc caub_p4 (
	@SoHDN nchar(10),
	@MaSP nchar(10) ,
	@MaNV nchar(10),
	@NgayNhap datetime,
	@SoLuongN int ,
	@DonGiaN money

)
as
begin

	if(not exists(select*from SanPham where MaSP=@MaSP))
	print N'San Pham Không tồn tại'
	else if(not exists(select* from NhanVien where @MaNV=MaNV))
	print N'MaNV Không tồn tại'
	else
		begin
			if(exists(select*from Nhap where SoHDN=@SoHDN))
			update Nhap set MaSP=@MaSP,SoLuongN=@SoLuongN,DonGiaN=@DonGiaN where SoHDN=@SoHDN
			else
			insert into Nhap values(@SoHDN,@MaSP,@SoLuongN,@DonGiaN)
		end
end
---Gọi thủ tục
insert into PNhap values ('N06','2019/02/12','NV06')
--TH sản phẩm không tồn tại:
exec caub_p4 'N06','SP06','NV02','2019/02/12',1,2345
--TH manv không tồn tại:
exec caub_p4 'N06','SP06','NV06','2019/02/12',1,2345
--TH cập nhật:
exec caub_p4 'N03','SP02','NV02','2019/02/12',1,2346
---TH thêm mới:
exec caub_p4 'N06','SP02','NV06','2019/02/12',1,2345

/*c (4đ). Viết thủ tục nhập dữ liệu cho bảng Xuat với các tham biến SoHDX, MaSP, manv, 
NgayXuat, SoLuongX. Kiểm tra xem MaSP có tồn tại trong bảng SanPham hay không nếu 
không trả về 1? manv có tồn tại trong bảng NhanVien hay không nếu không trả về 2? 
SoLuongX <= SoLuong nếu không trả về 3? ngược lại thì hãy kiểm tra: Nếu SoHDX đã 
tồn tại thì cập nhật bảng Xuat theo SoHDX, ngược lại thêm mới bảng Xuat và trả về mã 
lỗi 0.*/
alter proc cauc_p4(

	@SoHDX nchar(10),
	@MaSP nchar(10) ,
	@MaNV nchar(10),
	@NgayXuat datetime,
	@SoLuongX int
	
)
as
begin
	declare @SoLuong int
	if(not exists(select*from SanPham where MaSP=@MaSP))
	print N'San pham không tồn tại'
	else if(not exists(select* from NhanVien where @MaNV=MaNV))
	print N'Nhan vien không tồn tại'
	else if (not exists (select @SoLuong from SanPham inner join Xuat on Xuat.MaSP=SanPham.MaSP where @SoLuong=@SoLuongX  ))
	print N'So luong xuat >So luong '
	else
		begin
			if(exists(select*from Xuat where SoHDX=@SoHDX))
			update Xuat set MaSP=@MaSP,SoLuongX=@SoLuongX where SoHDX=@SoHDX
			else
			insert into Xuat values(@SoHDX,@MaSP,@SoLuongX)
		end
end
----Gọi thủ tục
insert into PXuat values ('X06','2019/2/9','NV03' )
---TH sản phẩm không tồn tại:
exec cauc_p4 'X06','SP07','NV02','2019/2/9',2
---TH nhân viên không tồn tại:
exec cauc_p4 'X06','SP02','NV010','2019/2/9',2
---TH So luong xuat >So luong :
exec cauc_p4 'X06','SP02','NV02','2019/2/9',-2
---TH cập nhật:
exec cauc_p4 'X01','SP02','NV02','2019/2/9',12
--TH thêm mới:
exec cauc_p4 'X06','SP03','NV03','2019/2/9',2
select*from Xuat