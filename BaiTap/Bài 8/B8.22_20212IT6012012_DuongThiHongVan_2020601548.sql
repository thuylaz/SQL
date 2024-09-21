--a (1đ). Tạo CSDL có tên QLNV
--b (2đ). Tạo các bảng dữ liệu sau trong CSDL vừa tạo với các chỉ định ràng buộc tương ứng 
--c (2đ). Chèn dữ liệu sau đây vào các bảng trên
--d (5đ). Yêu cầu:
--1. Tạo thủ tục có tham số đưa vào là MaNV, MaCV, TenNV, NgaySinh, LuongCB, 
--NgayCong, PhucCap. Trước khi chèn một bản ghi mới vào bảng NHANVIEN với danh 
--sách giá trị là giá trị của các biến phải kiểm tra xem MaCV đã tồn tại bên bảng ChucVu 
--chưa, nếu chưa trả ra 0.
--2. Sửa thủ tục ở câu một kiểm tra xem thêm MaNV được chèn vào có trùng với MaNV 
--nào đó có trong bảng không. Nếu MaNV đã tồn tại trả ra 0, nếu MaCV chưa tồn tại trả ra 
--1. Ngược lại cho phép chèn bản ghi.
--3. Tạo SP cập nhật trường NgaySinh cho các nhân viên (thủ tục có hai tham số đầu vào 
--gồm mã nhân viên, Ngaysinh). Nếu không tìm thấy bản ghi cần cập nhật trả ra giá trị 0. 
--Ngược lại, cho phép cập nhật.

create database QLNV
go 
use QLNV
go
create table tblChucvu
(
	MaCV nvarchar(2) primary key,
	TenCV nvarchar(30)
)
go 
create table tblNhanVien
(
	MaNV nvarchar(4) primary key, 
	MaCV nvarchar(2) not null foreign key (MaCV) references tblChucVu(MaCV) on update cascade on delete cascade,
	TenNV nvarchar(30),
	NgaySinh datetime,
	LuongCanBan float,
	NgayCong int,
	PhuCap float
)

go 
insert into tblChucvu values('BV', N'Bảo vệ')
insert into tblChucvu values('GD', N'Giám đốc')
insert into tblChucvu values('HC', N'Hành chính')
insert into tblChucvu values('KT', N'Kế toán')
insert into tblChucvu values('TQ', N'Thủ quỹ')
insert into tblChucvu values('VS', N'Vệ sinh')
go
select getdate()
insert into tblNhanVien values ('NV01', 'GD', N'Nguyễn Văn A', '12/12/1995',9000000, 25, 7000000)
insert into tblNhanVien values ('NV02', 'BV', N'Nguyễn Văn B', '1/12/1995',6000000, 25, 5000000)
insert into tblNhanVien values ('NV03', 'KT', N'Nguyễn Văn C', '1/1/1995',5000000, 25, 6000000)
insert into tblNhanVien values ('NV04', 'VS', N'Nguyễn Văn D', '12/7/1995',4000000, 25, 3000000)
insert into tblNhanVien values ('NV05', 'HC', N'Nguyễn Văn E', '24/7/1995',7000000, 25, 5000000)
go
select * from tblChucvu
select * from tblNhanVien

---1,
create proc cau1(@MaNV nvarchar(4),@MaCV nvarchar(2),@TenNV nvarchar(30),@NgaySinh datetime,@LuongCanBan float,@NgayCong int,@PhuCap float,@kq int output)
as
begin
	if(not exists(select*from tblChucVu where MaCV=@MaCV))
		set @kq=0
	else
		if(not exists(select*from tblNhanVien where MaNV=@MaNV and MaCV=@MaCV))
			set @kq=0
	else
		insert into tblNhanVien values(@MaNV,@MaCV,@TenNV,@NgaySinh,@LuongCanBan,@NgayCong,@PhuCap)
		return @kq
end
go
declare @ketq int
exec cau1 'NV06','GD',N'Nguyễn Thị A','1977/10/20',200000,26,100000,@ketq output
select @ketq
---------2,
alter proc cau1(@MaNV nvarchar(4),@MaCV nvarchar(2),@TenNV nvarchar(30),@NgaySinh datetime,@LuongCanBan float,@NgayCong int,@PhuCap float,@kq int output)
as
begin
	if(exists(select*from tblNhanVien where MaNV=@MaNV))
		set @kq=0
	else
		if(not exists(select*from tblNhanVien where MaCV=@MaCV ))
			set @kq=1
	else
		insert into tblNhanVien values(@MaNV,@MaCV,@TenNV,@NgaySinh,@LuongCanBan,@NgayCong,@PhuCap)
		return @kq
end
go
declare @kqua int
exec cau1 'NV07','GD',N'Nguyễn Thị B','1977/10/20',200000,26,100000,@kqua output
select @kqua

-------------3,

create proc cau3(@MaNV nvarchar(4) ,@NgaySinh datetime,@kq int output)
as
begin
	if(exists(select*from tblNhanVien where MaNV=@MaNV))
		update tblNhanVien set NgaySinh=@NgaySinh where MaNV=@MaNV
	else
		set @kq=0
		return @kq
end
go
declare @ketquas int
exec cau3 'NV09','1976/10/12',@ketquas output
select @ketquas