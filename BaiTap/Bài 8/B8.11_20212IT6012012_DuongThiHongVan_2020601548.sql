--a (1đ). Tạo CSDL có tên QLNV
--b (2đ). Tạo các bảng dữ liệu sau trong CSDL vừa tạo với các chỉ định ràng buộc tương ứng 
--c (2đ). Chèn dữ liệu sau đây vào các bảng trên
--d (5đ). Yêu cầu:
--1. Viết thủ tục SP_Them_Nhan_Vien, biết tham biến là MaNV, MaCV, 
--TenNV,Ngaysinh,LuongCanBan,NgayCong,PhuCap. Kiểm tra MaCV có tồn tại 
--trong bảng tblChucVu hay không? nếu thỏa mãn yêu cầu thì cho thêm nhân viên 
--mới, nếu không thì đưa ra thông báo. 
--2. Viết thủ tục SP_CapNhat_Nhan_Vien ( không cập nhật mã), biết tham biến là 
--MaNV, MaCV, TenNV, Ngaysinh, LuongCanBan, NgayCong, PhuCap. Kiểm tra 
--MaCV có tồn tại trong bảng tblChucVu hay không? nếu thỏa mãn yêu cầu thì cho 
--cập nhật, nếu không thì đưa ra thông báo.
--3. Viết thủ tục SP_LuongLN với Luong=LuongCanBan*NgayCong PhuCap, biết 
--thủ tục trả về, không truyền tham biến.

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

--1.
create proc SP_Them_Nhan_Vien(@MaNV nvarchar(4), @MaCV nvarchar(2), @TenNV nvarchar(30),
							@NgaySinh datetime, @LuongCanBan float, @NgayCong int, @PhuCap float)
as
begin
	if(exists(select * from tblChucvu where MaCV=@MaCV))
		insert into tblNhanVien
	values(@MaNV, @TenNV, @NgaySinh, @LuongCanBan, @NgayCong, @PhuCap)
	else
		print N'Không có chức vụ này.'
end
go
select * from tblChucvu
select * from tblNhanVien
exec SP_Them_Nhan_Vien 'NV01', 'AB', N'Dương Thị Hồng Vân', '24/07/2002', 2000000, 27, 1000000

--2.
create proc SP_CapNhat_Nhan_Vien(@MaNV nvarchar(4), @MaCV nvarchar(2), @TenNV nvarchar(30),
							@NgaySinh datetime, @LuongCanBan float, @NgayCong int, @PhuCap float)
as
begin
	if(exists(select * from tblChucvu where MaCV=@MaCV))
		update tblNhanVien set MaNV=@MaNV, MaCV=@MaCV, TenNV=@TenNV, NgaySinh=@NgaySinh, 
		LuongCanBan=@LuongCanBan,NgayCong=@NgayCong, PhuCap=@PhuCap
			where MaCV=@MaCV
	else
		print N'Không có chức vụ này.'
end
go
exec SP_CapNhat_Nhan_Vien 'NV02', 'BV', N'Nguyễn Văn F', '24/07/2002', 2000000, 27, 1000000


--3. 
create proc SP_LuongLN
as
begin
		select MaNV, TenNV, (LuongCanBan*NgayCong+PhuCap) as N'Lương'
		from tblNhanVien
		return
end
go 
exec SP_LuongLN