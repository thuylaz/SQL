--Bài tập. Cho 2 bảng dữ liệu sau:
		--Khoa(Makhoa,Tenkhoa,Dienthoai)
		--Lop(Malop,Tenlop,Khoa,Hedt,Namnhaphoc,Makhoa)
--Câu 1 (5đ). Viết thủ tục nhập dữ liệu vào bảng KHOA với các tham biến: 
--makhoa,tenkhoa, dienthoai, hãy kiểm tra xem tên khoa đã tồn tại trước đó hay chưa, 
--nếu đã tồn tại trả về giá trị 0, nếu chưa tồn tại thì nhập vào bảng khoa, test với 2 
--trường hợp.
--Câu 2 (5đ). Hãy viết thủ tục nhập dữ liệu cho bảng lop với các tham biến 
--malop,tenlop,khoa,hedt,namnhaphoc,makhoa.
	--- Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì trả về 0.
	--- Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì trả về 1.
	--- Nếu đầy đủ thông tin thì cho nhập và trả về 2.

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
--Câu 1: 
create proc bt1(@MaKhoa int, @TenKhoa nvarchar(20), @DienThoai nvarchar(20), @kq int output)
as
begin
	if(exists(select * from Khoa where TenKhoa = @TenKhoa))
		set @kq=0
	else
		insert into Khoa
		values(@MaKhoa, @TenKhoa,, @DienThoai)
			return @kq
end
go
declare @ketqua int
exec bt1 8, N'Quản trị văn phòng', '123456717', @ketqua output
select @ketqua

--Caau2:
create proc bt2(@MaLop int, @TenLop nvarchar(20), @Khoa int, @Hedt nvarchar(10), 
@Namnhaphoc int, @MaKhoa int, @kq int output)
as
begin
	if(exists(select * from Lop where TenLop = @TenLop))
			set @kq=0
	else 
		if(not exists(select * from Khoa where MaKhoa = @MaKhoa))
				set @kq=1
			else
				insert into Lop
				values(@MaLop, @TenLop, @Khoa, @Hedt, @Namnhaphoc, @MaKhoa)
						set @kq=2
						return @kq
end
go declare @kqua int
exec bt2 09, N'Du lịch 1', 15, 'K15', 2020, , @kqua output
select @kqua