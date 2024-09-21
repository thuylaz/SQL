use master
go
create database de1
go 
use de1
go

--cau1
create table khoa
(makhoa char(10) not null primary key,
tenkhoa nvarchar(100) not null
)
drop table khoa

create table lop
(malop char(10) not null primary key,
tenlop nvarchar(100) not null,
siso int not null,
makhoa char(10) not null,
constraint fk foreign key (makhoa) references khoa(makhoa) on update cascade on delete cascade
)
drop table lop

create table sinhvien
(masv char(10) not null primary key,
hoten nvarchar(100) not null,
ngaysinh datetime not null default(getdate()),
gioitinh bit not null,
malop char(10) not null,
constraint fk1 foreign key (malop) references lop(malop) on update cascade on delete cascade
)
drop table sinhvien

--chen du lieu
insert into khoa
(makhoa, tenkhoa)
values	('mk01', 'cntt'),
		('mk02', 'dien');

insert into lop
(malop, tenlop, siso, makhoa)
values	('ml01', 'httt1', 65, 'mk01'),
		('ml02', 'tdh1', 85, 'mk02');

insert into sinhvien
(masv, hoten, ngaysinh, gioitinh, malop)
values	('sv01', 'Nguyen Thi Quynh Trang', '05-06-2000', 1, 'ml01'),
		('sv02', 'Le Quang Huy', '12-17-2000', 0, 'ml02'),
		('sv03', 'Nguyen Van A', '01-06-1973', 0, 'ml02'),
		('sv04', 'Nguyen Thi B', '02-03-1979', 1, 'ml02'),
		('sv05', 'Nguyen Thi C', '05-27-2006', 1, 'ml01'),
		('sv06', 'Nguyen Van D', '09-30-2001', 0, 'ml02'),
		('sv07', 'Nguyen Thi E', '07-24-2010', 1, 'ml01');

select * from khoa
select * from lop
select * from sinhvien

--cau2: tạo view đưa ra thống kê số lớp của từng khoa gồm các thông tin: tên khoa, số lớp
create view v_cau2
as
	select tenkhoa, count(makhoa) as 'so lop'
	from khoa
	group by tenkhoa
go
drop view v_cau2
--test
select * from v_cau2

--cau3: viết hàm với tham số truyền vào là makhoa, trả về 1 bảng gồm: masv, hoten, ngaysinh, gioitinh("nam" hoặc "nữ"), tenlop, tenkhoa
create function f_cau3 (@makhoa char(10))
returns @sv table
		(masv char(10),
		hoten nvarchar(100),
		ngaysinh datetime,
		gioitinh char(5),
		tenlop nvarchar(100), 
		tenkhoa nvarchar(100)
		)
as
	begin
		insert into @sv
			select masv, hoten, ngaysinh, case gioitinh when 0 then N'Nam' when 1 then N'Nu' end as 'gioi tinh', tenlop, tenkhoa
			from lop inner join sinhvien on lop.malop = sinhvien.malop
					 inner join khoa on lop.makhoa = khoa.makhoa
			where lop.makhoa = @makhoa
		return
	end
go
drop function f_cau3
--test
select * from f_cau3('mk01')
select * from f_cau3('mk02')

--cau4: tạo trigger tự động tăng siso sinh viên trong bang lop mỗi khi thêm mới dữ liệu cho bảng sinhvien, nếu sĩ số trong lớp >80 thì không thêm và đưa ra thông báo lỗi
create trigger cau4
on sinhvien
for insert
as
	begin
		declare @siso int
		select @siso = lop.siso
		from lop inner join inserted
		on lop.malop = inserted.malop
		if(@siso > 80)
			begin
				raiserror ('khong the them', 16,1)
				rollback transaction
			end
		else
			begin
				update lop
				set siso = siso + 1
				from inserted, lop
				where lop.malop = inserted.malop
			end
	end
go
drop trigger cau4
--test 
insert into sinhvien
(masv, hoten, ngaysinh, gioitinh, malop)
values ('sv08', 'Nguyen Thi F', '04-14-2000', 0, 'ml01')

insert into sinhvien
(masv, hoten, ngaysinh, gioitinh, malop)
values ('sv10', 'Nguyen Thi K', '04-14-2000', 0, 'ml02')

select * from khoa
select * from lop
select * from sinhvien


--cau5: đưa ra sinh viên ít tuổi nhất (của 1 khoa nào đó) gồm masv, hoten, tuoi
select  masv, hoten, year(getdate())-year(ngaysinh) as 'tuoi'
from sinhvien
order by tuoi asc


--cau6: tạo thủ tục tìm kiếm sinh viên theo khoảng tuổi (2 tham số truyền vào là tutuoi, dentuoi)
--danh sách đưa ra gồm masv, hoten, ngaysinh, tenlop, tenkhoa, tuoi 
create function cau6(@TuTuoi int, @DenTuoi int)
returns @danhsach table
		(masv char(10), 
		hoten nvarchar(30), 
		ngaysinh datetime, 
		tenlop nvarchar(30), 
		tenkhoa nvarchar(30), 
		tuoi int)
as
	begin
		insert into @danhsach
			select masv, hoten, ngaysinh, tenlop, tenkhoa, YEAR(getdate())-YEAR(ngaysinh) as N'Tuổi'
			from khoa inner join lop on khoa.makhoa = lop.makhoa 
				inner join sinhvien on lop.malop = sinhvien.malop
			where YEAR(getdate())-YEAR(ngaysinh) between @TuTuoi and @DenTuoi
		return 
	end
go
drop function cau6
select * from cau6(18,20)

