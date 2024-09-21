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

/* Bài 1 (5đ). 
a. Tạo thủ tục nhập dữ liệu cho bảng sản phẩm với các tham biến truyền vào MaSP, 
TenHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa. Hãy kiểm tra xem 
nếu MaSP đã tồn tại thì cập nhật thông tin sản phẩm theo mã, ngược lại thêm mới sản phẩm 
vào bảng SanPham. */ 
create proc caua_b1(
	@MaSP nchar(10),
	@TenHang nvarchar(20),
	@TenSP nvarchar(20),
	@SoLuong int,
	@MauSac nvarchar(20),
	@GiaBan money,
	@DonViTinh nvarchar(10),
	@MoTa nvarchar(max)
)
as
begin
	if(not exists (select * from HangSX where TenHang = @TenHang))
		print N'Không tồn tại tên hãng này'
	else
		begin
		declare @MaHangSX nvarchar(10)
		select @MaHangSX = MaHangSX from HangSX where TenHang=@TenHang
		if(exists(select * from SanPham where MaSP=@MaSP))
		update SanPham set MaHangSX = @MaHangSX,
			TenSP=@TenSP,
			SoLuong=@SoLuong,
			MauSac=@MauSac,
			GiaBan=@GiaBan,
			DonViTinh=@DonViTinh,
			MoTa=@MoTa
		where MaSP=@MaSP
	else
		insert into SanPham values @MaSp, @MaHangSX, @TenSP, @SoLuong, @MauSac, @GiaBan, @DonViTinh, @MoTa)
	end
end
--Gọi thủ tục 
-- Trường hợp đúng: Cập nhật
Exec caua_b1 '01',N'Nokia','a11100',5,N'xanh',2000000,N'Chiếc',N'Sản phẩm phổ thông'
-- Trường hợp đúng: Thêm mới 
Exec caua_b1 '01',N'Nokia','a11100',5,N'xanh', 1950000, N'Chiếc', N'Sản phẩm phổ thông'
-- Trường hợp sai:”Không có sản phẩm Noki”
Exec caua_b1 '02',N'Noki','a11100',5,N'xanh',2000000,N'Chiếc',N'Sản phẩm phổ thông'


/* b. Viết thủ tục xóa dữ liệu bảng HangSX với tham biến là TenHang. Nếu TenHang chưa 
có thì thông báo, ngược lại xóa HangSX với hãng bị xóa là TenHang. (Lưu ý: xóa HangSX
thì phải xóa các sản phẩm mà HangSX này cung ứng). */
create proc caub_b1(@TenHang nvarchar(20))
as
begin
	if(not exists(select*from HangSX where TenHang=@TenHang))
		print N'Tên hãng khôg tồn tại'
	else
		begin
		declare @MaHangSX nchar(10)
		select @MaHangSX=MaHangSX from HangSX where TenHang=@TenHang
		delete from SanPham where MaHangSX=@MaHangSX
		delete from HangSX where MaHangSX=@MaHangSX
		print N'Xóa thành công'
		end 
end
-----Gọi thủ tục
--TH xóa thành công:
exec caub_b1 'SamSung'
--TH không tồn tại tên hàng:
exec caub_b1 'SamSung'

/* c. Viết thủ tục nhập dữ liệu cho bảng nhân viên với các tham biến manv, TenNV, GioiTinh, 
DiaChi, SoDT, Email, Phong, và 1 biến cờ Flag, Nếu Flag = 0 thì cập nhật dữ liệu cho bảng 
nhân viên theo manv, ngược lại thêm mới nhân viên này.*/
create proc cauc_b1(
    @MaNV nchar(10) ,
	@TenNV nvarchar(20) ,
	@GioiTinh nchar(10) ,
	@DiaChi nvarchar(30),
	@SoDT nvarchar(20),
	@Email nvarchar(30),
	@TenPhong nvarchar(30),
	@Flag int
	)
as
begin
	if(@Flag=0)
	update NhanVien set TenNV=@TenNV,GioiTinh=@GioiTinh,DiaChi=@DiaChi,SoDT=@SoDT,Email=@Email,TenPhong=@TenPhong
	where MaNV=@MaNV
	else
	if(@Flag=1)
	 insert into NhanVien values (@MaNV,@TenNV,@GioiTinh,@DiaChi,@SoDT,@Email,@TenPhong)
	
end
----Gọi thủ tục
--TH thêm mới:
exec cauc_b1 'NV06',N'Nguyễn Văn B',N'Nam',N'Abcd','12334','adc@gmail.com',N'Vật tư',1
--TH cập nhật:
exec cauc_b1 'NV01',N'Nguyễn Văn B',N'Nam',N'Abcd','12334','adc@gmail.com',N'Vật tư',0

/* d. Viết thủ tục nhập dữ liệu cho bảng Nhap với các tham biến SoHDN, MaSP, manv, 
NgayNhap, SoLuongN, DonGiaN. Kiểm tra xem MaSP có tồn tại trong bảng SanPham hay 
không? manv có tồn tại trong bảng NhanVien hay không? Nếu không thì thông báo, ngược 
lại thì hãy kiểm tra: Nếu SoHDN đã tồn tại thì cập nhật bảng Nhap theo SoHDN, ngược lại 
thêm mới bảng Nhap.*/
create proc caud_b1 (
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
exec caud_b1 'N06','SP06','NV02','2019/02/12',1,2345
--TH MaNV không tồn tại:
exec caud_b1 'N06','SP06','NV06','2019/02/12',1,2345
--TH Cập nhật:
exec caud_b1 'N03','SP02','NV02','2019/02/12',1,2346
---TH Thêm mới:
exec caud_b1 'N06','SP02','NV06','2019/02/12',1,2345



/* Bài 2 (5đ).
a. Viết thủ tục thêm mới sản phẩm với các tham biến MaSP, TenHang, TenSP, SoLuong, 
MauSac, GiaBan, DonViTinh, MoTa và 1 biến Flag. Nếu Flag=0 thì thêm mới sản phẩm, 
ngược lại cập nhật sản phẩm. Hãy kiểm tra:
- Nếu TenHang không có trong bảng HangSX thì trả về mã lỗi 1
- Nếu SoLuong <0 thì trả về mã lỗi 2
- Ngược lại trả về mã lỗi 0.*/
create proc caua_b2(
	@MaSP nchar(10) ,
	@TenHang nchar(20) ,
	@TenSP nvarchar(20) ,
	@SoLuong int ,
	@MauSac nvarchar(20),
	@GiaBan money,
	@DonViTinh nchar(10),
	@MoTa nvarchar(max),
	@Flag int,
	@kq int output
)
as
begin
	if(not exists(select*from HangSX where TenHang=@TenHang))
		set @kq=1
	else if(@SoLuong<0)
		set @kq=2
	else
		begin
			set @kq=0
			declare @MaHangSX nchar(10)
			select @MaHangSX=MaHangSX from HangSX where TenHang=@TenHang
			if(@Flag=0)
				insert into SanPham values(@MaSP,@MaHangSX,@TenSP,@SoLuong,@MauSac,@GiaBan,@DonViTinh,@MoTa)
			else 
			if(@Flag=1)
			update SanPham set TenSP=@TenSP,MaHangSX=@MaHangSX,SoLuong=@SoLuong,MauSac=@MauSac,GiaBan=@GiaBan,DonViTinh=@DonViTinh,MoTa=@MoTa
			where MaSP=@MaSP
		end
		return @kq
end
--Gọi thủ tục
--TH không có TenHang:
declare @KQ2 int
exec caua_b2 'SP02','SanSun','agghfhg',12,'ghhj',12445,'shnjkk','wjrhhrhthihiit',0,@KQ2 output
select @KQ2
---TH so luong<0
declare @KQ2 int
exec caua_b2 'SP02','SamSung','agghfhg',-2,'ghhj',12445,'shnjkk','wjrhhrhthihiit',0,@KQ2 output
select @KQ2
--TH thêm mới:
declare @KQ2 int
exec caua_b2 'SP09','Nokia','agghfhg',12,'ghhj',12445,'shnjkk','wjrhhrhthihiit',0,@KQ2 output
select @KQ2
--TH cập nhật:
declare @KQ2 int
exec caua_b2 'SP02','Nokia','agghfhg',22,'ghhj',12445,'shnjkk','wjrhhrhthihiit',1,@KQ2 output
select @KQ2
select*from SanPham


/* b. Viết thủ tục xóa dữ liệu bảng NhanVien với tham biến là manv. Nếu manv chưa có thì 
trả về 1, ngược lại xóa NhanVien với NhanVien bị xóa là manv và trả về 0. (Lưu ý: xóa 
NhanVien thì phải xóa các bảng Nhap, Xuat mà nhân viên này tham gia). */
create proc caub_b2(@MaNV nchar(10))
as
begin
	if(not exists(select*from NhanVien where MaNV=@MaNV))
		print N'Không tồn tại'
	else
		begin
		 delete from PNhap where MaNV=@MaNV
		 delete from PXuat where MaNV=@MaNV
		 delete from NhanVien where MaNV=@MaNV
		end
end
-----Gọi thủ tục
--TH không tồn tại:
exec caub_b2 'NV08'
--TH tồn tại:
exec caub_b2 'NV02'
/* c. Viết thủ tục xóa dữ liệu bảng SanPham với tham biến là MaSP. Nếu MaSP chưa có thì 
trả về 1, ngược lại xóa SanPham với SanPham bị xóa là MaSP và trả về 0. (Lưu ý: xóa 
SanPham thì phải xóa các bảng Nhap, Xuat mà SanPham này cung ứng). */
create proc cauc_b2(@MaSP nchar(10))
as
begin
	if(not exists(select*from SanPham where MaSP=@MaSP))
		print N'Không tồn tại'
	else
		begin
		delete from Nhap where MaSP=@MaSP
		delete from Xuat where MaSP=@MaSP
		delete from SanPham where MaSP=@MaSP
		end
end
---Gọi thủ tục
--TH không tồn tại:
exec cauc_b2 'SP08'
--TH tồn tại:
exec cauc_b2 'SP03'