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

/* a (5đ). Tạo thủ tục nhập liệu cho bảng HangSX, với các tham biến truyền vào MaHangSX, 
TenHang, DiaChi, SoDT, Email. Hãy kiểm tra xem TenHang đã tồn tại trước đó hay chưa? 
Nếu có rồi thì không cho nhập và Đưa ra thông báo.
b (5đ). Viết thủ tục thêm mới nhân viên bao gồm các tham số: MaNV, TenNV, GioiTinh, 
DiaChi, SoDT, Email, TenPhong và 1 biến Flag, Nếu Flag=0 thì nhập mới, ngược lại thì 
cập nhật thông tin nhân viên theo mã. Hãy kiểm tra:
- GioiTinh nhập vào có phải là Nam hoặc Nữ không, nếu không trả về mã lỗi 1.
- Ngược lại nếu thỏa mãn thì cho phép nhập và trả về mã lỗi 0. */ 

--Bài làm--

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


create proc caua(
	@MaHangSX nchar(10),
	@TenHang nvarchar(20),
	@DiaChi nvarchar(30),
	@SoDT nvarchar(20),
	@Email nvarchar(30)
)
as 
begin
	if(exists(select * from HangSX where TenHang=@TenHang))
		print N'Tồn tại tên hãng'
	else
	begin
		insert into HangSX values (@MaHangSX, @TenHang, @DiaChi, @SoDT, @Email)
			print N'Thêm mới thành công'
		end
end
--Gọi thủ tục
--TH hang ton tai:
exec caua 'H01', N'Samsung', N'Việt Nam', '0123456789', 'abc@gmail.com'
--TH them moi
exec caua 'H04', N'Nokia', N'VietNam', '0123456789', 'abc@gmail.com'

create proc caub(
	@MaNV nchar(10),
	@TenNV nvarchar(20),
	@GioiTinh nchar(10),
	@DiaChi nvarchar(30),
	@SoDT nvarchar(20),
	@Email nvarchar(30),
	@TenPhong nvarchar(30),
	@Flag int,
	@kq int output
)
as
begin
	if(@GioiTinh <> N'Nam' and @GioiTinh <> N'Nữ')
		set @kq=1
	else 
		begin 
		set @kq=0
		if(@Flag = 0)
			insert into NhanVien values(@MaNV, @TenNV, @DiaChi, @SoDT, @Email, @TenPhong)
				else
				if(@Flag = 1)
				update NhanVien 
				set TenNV=@TenNV, GioiTinh=@GioiTinh, DiaChi=@DiaChi, SoDT=@SoDT, Email=@Email, TenPhong=@TenPhong 
				where MaNV = @MaNV
				end
				return @kq
end
--Gọi thủ tục
declare @KQ1 int
exec cau1 'NV02',N'Nguyễn Văn B',N'abc',N'dgghhjh','13456','djfhhgjhkkk',N'Kế toán',1,@KQ1 output
select @KQ1
--TH them moi:
declare @KQ1 int
exec cau1 'NV07',N'Nguyễn Văn A',N'Nam',N'dgghhjh','13456','djfhhgjhkkk',N'Kế toán',0,@KQ1 output
select @KQ1
--TH cap nhat:
declare @KQ1 int
exec cau1 'NV06',N'Nguyễn Văn C',N'Nam',N'dgghhjh','13456','djfhhgjhkkk',N'Kế toán',1,@KQ1 output
select @KQ1
select*from NhanVien
