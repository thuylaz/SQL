use master
go
if(exists(select * from sysdatabases where name='QLSV'))
	drop database QLSV
go

--create database
use master
go
create database QLSV
go

--create table
use QLSV
go
create table LOP
(
	MaLop int not null identity primary key,
	TenLop nvarchar(50) not null,
	Phong int not null
)
create table SinhVien
(
	MaSV int not null identity primary key,
	TenSV nvarchar(50) not null,
	MaLop int not null,
	constraint fk_sinhvien_lop foreign key(MaLop) references LOP(MaLop)
)
go

--insert data
insert into LOP values('CD',1), ('DH',2),('LT',2), ('xy',4)
insert into SinhVien values('A',1), ('B',2), ('C',1), ('D',3)

go

--1.Viết hàm thống kê xem mỗi lớp có bao nhiêu sinh viên với malop là tham số truyền vào từ bàn phím.
create function fn_countsinhvien(@malop int)
returns int
as
	begin
		declare @count int
		set @count = (select COUNT(*) from SinhVien where MaLop=@malop)
		return @count
	end
go

select dbo.fn_countsinhvien(1) as N'Số sinh viên lớp 1';

go

--2. Đưa ra danh sách sinh viên(masv,tensv) học lớp với tenlop được truyền vào từ bàn phím.
create function fn_dsSVtheoLOP(@tenlop nvarchar(50))
returns @DSSVtheoLOP TABLE (MaSV int, TenSV nvarchar(50))
as
	begin
		insert into @DSSVtheoLOP
			select MaSV, TenSV from SinhVien where 
				SinhVien.MaLop = (select distinct MaLop from LOP where TenLop=@tenlop)
		return
	end
go

select * from fn_dsSVtheoLOP('DH')

go
--3. Đưa ra hàm thống kê sinhvien: malop,tenlop,soluong sinh viên trong lớp, với tên lớp
--được nhập từ bàn phím. Nếu lớp đó chưa tồn tại thì thống kê tất cả các lớp, ngược lại nếu
--lớp đó đã tồn tại thì chỉ thống kê mỗi lớp đó.
create function fn_thongkeSV(@tenlop nvarchar(50))
returns @ThongKe table (MaLop int, TenLop nvarchar(50), soluongSV int)
as
	begin
		if(not exists(select MaLop from LOP where TenLop=@tenlop))
		begin
			insert into @ThongKe
				select LOP.MaLop, TenLop, count(*) from LOP inner join SinhVien on SinhVien.MaLop = LOP.MaLop
				group by LOP.MaLop,TenLop
		end
		else
		begin
			insert into @ThongKe
				select LOP.MaLop, TenLop, count(*) from LOP inner join SinhVien on SinhVien.MaLop = LOP.MaLop
				where LOP.TenLop=@tenlop
				group by LOP.MaLop,TenLop
		end
	return
	end

go

select * from fn_thongkeSV('D')

go

--4. Đưa ra phòng học của tên sinh viên nhập từ bàn phím.
create function fn_phonghoc(@tensv nvarchar(50))
returns int
as
	begin
		declare @phonghoc int
		set @phonghoc = (select Phong from LOP where 
						MaLop = (select distinct MaLop from SinhVien where TenSV=@tensv)
						)
		return @phonghoc
	end
go

select dbo.fn_phonghoc('D') as N'Phòng học'

go

--5. Đưa ra thống kê masv,tensv, tenlop với tham biến nhập từ bàn phím là phòng. Nếu phòng
--không tồn tại thì đưa ra tất cả các sinh viên và các phòng. Neu phòng tồn tại thì đưa ra các
--sinh vien của các lớp học phòng đó (Nhiều lớp học cùng phòng).
create function fn_SVhocphong(@phong int)
returns @dsSVhoc table (MaSV int, TenSV nvarchar(50), TenLop nvarchar(50))
as
	begin
		if(not exists(select * from LOP where Phong=@phong))
			begin
				insert into @dsSVhoc
					select MaSV, TenSV, TenLop from SinhVien inner join LOP on SinhVien.MaLop=LOP.MaLop
			end
		else
			begin
				insert into @dsSVhoc
					select MaSV, TenSV, TenLop from SinhVien inner join LOP on SinhVien.MaLop=LOP.MaLop
					where phong=@phong
			end
	return
	end

go

select * from fn_SVhocphong(2)

go

--6.Viết hàm thống kê xem mỗi phòng có bao nhiêu lớp học. Nếu phòng không tồn tại trả về giá trị 0.
create function fn_thongkephong(@phonghoc int)
returns int
as
	begin
		declare @solop int
		if(not exists(select * from LOP where Phong=@phonghoc))
			set @solop = 0
		else
			set @solop = (select count(*) from LOP where Phong=@phonghoc)
		return @solop
	end

go

select dbo.fn_thongkephong(2) as N'Số lớp học phòng số 2'
go