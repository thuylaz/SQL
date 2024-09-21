--Bài tập. Cho 2 bảng dữ liệu sau:
		--Khoa(Makhoa,Tenkhoa,Dienthoai)
		--Lop(Malop,Tenlop,Khoa,Hedt,Namnhaphoc,Makhoa)
--Câu 1 (5đ). Viết thủ tục nhập dữ liệu vào bảng KHOA với các tham biến:
--makhoa,tenkhoa, dienthoai, hãy kiểm tra xem tên khoa đã tồn tại trước đó hay chưa, 
--nếu đã tồn tại đưa ra thông báo, nếu chưa tồn tại thì nhập vào bảng khoa, test với 2 
--trường hợp.
--Câu 2 (5đ). Hãy viết thủ tục nhập dữ liệu cho bảng Lop với các tham biến Malop,
--Tenlop, Khoa,Hedt,Namnhaphoc,Makhoa nhập từ bàn phím.
		--Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì thông báo
		--Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì thông báo
		--Nếu đầy đủ thông tin thì cho nhập

create database QLSV
go
use QLSV
go
create table Khoạ̣̣
̣(
	MaKhoa int primary key,
	TenKhoa nvarchar(20) not null,
	DienThoai nvarchar(20) not null
)
go
create table Lop
(
	MaLop int primary key,
	TenLop nvarchar(20) not null,
	Khoa int not null,
	Hedt nvarchar(10) not null,
	Namnhaphoc int,
	MaKhoa int not null foreign key (MaKhoa) references Khoa(MaKhoa) on update cascade on delete cascade
)
go 
insert into Khoa values (1, N'CNTT', '123456789')
insert into Khoa values	(2, N'Kế toán', '123456781')
insert into Khoa values	(3, N'Điện tử', '123456782')
insert into Khoa values	(4, N'Cơ khí', '123456783')
go
insert into Lop values	(01, N' Hệ thống thông tin 1 ', 15, 'K15', 2020,1)
insert into Lop values	(02, N' Hệ thống thông tin 2 ', 15, 'K15', 2020,1)
insert into Lop values	(03, N' Kế toán 1 ', 15, 'K15', 2020, 8)
insert into Lop values	(04, N' Kĩ thuật máy tính 1 ', 15, 'K15', 2020,2)
insert into Lop values	(05, N' Cơ khí 2 ', 15, 'K15', 2020, 8)
go

											--Câu 1--
--cách 1: 
create proc cau1(@MaKhoa int, @TenKhoa nvarchar(20), @DienThoai nvarchar(20))
as
begin	
	if(exists(select * from Khoa where TenKhoa = @TenKhoa))
	print N'Tên khoa' +  @TenKhoa + N' Đã tồn tại.'
	else
		begin
		insert into Khoa
		values(@MaKhoa, @TenKhoa, @DienThoai)
			print N'Nhập thành công.'
			end
end
go
select * from Khoa
exec cau1 6, N'CNTT1', '123456789'

--cách 2:
create proc cau1s(@MaKhoa int, @TenKhoa nvarchar(20), @DienThoai nvarchar(20))
as
begin
	declare @dem int
	select @dem=count(*) from Khoa where TenKhoa = @TenKhoa
	if(@dem=0)
		insert into Khoa values (@MaKhoa, @TenKhoa, @DienThoai)
	else 
	print N'Khoa đã tồn tại'
end
											--Câu 2--
create proc cau2(@MaLop int, @TenLop nvarchar(20), @Khoa int, @Hedt nvarchar(10), @Namnhaphoc int, @Makhoa int)
as
begin
	if(exists(select * from Lop where TenLop = @TenLop))
		print N'Lớp đã có. '
	else
		if(not exists(select * from Khoa where MaKhoa = @MaKhoa))
			print N'Khoa không tồn tại'
		else 
			insert into Lop
values(@MaLop, @TenLop, @Khoa, @Hedt, @Namnhaphoc, @Makhoa)
end
go
select * from Khoa
select * from Lop
exec cau2 01, N'Hệ thống thông tin 1', 15, 'K15', 2020,1




