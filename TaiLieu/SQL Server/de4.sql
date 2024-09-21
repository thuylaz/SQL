use master
go
create database de4
use de4
go

--cau1
create table khoa
(makhoa char(10) not null primary key,
tenkhoa nvarchar(100) not null,
sodienthoai char(20) not null
)
drop table khoa

create table lop
(malop char(10) not null primary key,
tenlop nvarchar(100) not null,
siso int not null check(siso>0),
makhoa char(10) not null,
constraint fk foreign key (makhoa) references khoa(makhoa) on update cascade on delete cascade
)
drop table lop

create table sinhvien
(masv char(10) not null primary key,
hoten nvarchar(100) not null,
gioitinh char(5) not null,
ngaysinh datetime not null,
malop char(10) not null,
constraint fk1 foreign key (malop) references lop(malop) on update cascade on delete cascade
)
drop table sinhvien

--insert into
insert into khoa
(makhoa, tenkhoa, sodienthoai) 
values	('mk01', 'cntt', 0123456789),
		('mk02', 'dien', 1234567890),
		('mk03', 'hoa', 2345678901);

insert into lop
(malop, tenlop, siso, makhoa)
values	('ml01', 'httt1', 65, 'mk01'),
		('ml02', 'tdh1', 80, 'mk02'),
		('ml03', 'hoa1', 75, 'mk03');
		
insert into sinhvien
(masv, hoten, gioitinh, ngaysinh, malop)
values	('sv01', 'Nguyen Trang', 'Nu', '05-06-2000', 'ml01'),
		('sv02', 'Le Huy', 'Nam', '12-17-2000', 'ml02'),
		('sv03', 'Nguyen Chau', 'Nu', '05-27-2000', 'ml03'),
		('sv04', 'Nguyen Duy', 'Nam', '01-06-2000', 'ml02'),
		('sv05', 'Nguyen Huyen', 'Nu', '02-03-2000', 'ml01');

select * from khoa
select * from lop
select * from sinhvien

--cau2: tạo hàm đưa ra danh sách lớp của 1 khoa gồm: malop, tenlop, siso với tenkhoa được nhập từ bàn phím
create function cau2 (@tenkhoa nvarchar(100))
returns @ds table
		(malop char(10),
		tenlop nvarchar(100),
		siso int)
as
	begin
		insert into @ds
		select malop, tenlop, siso
		from lop inner join khoa
		on lop.makhoa = khoa.makhoa
		where tenkhoa = @tenkhoa
		return
	end
go
drop function cau2
--test
select * from cau2('cntt')
select * from cau2('dien')
select * from cau2('hoa')


--cau3: tạo thủ tục thêm mới 1 sinh viên với các tham biến truyền vào là: masv, hoten, ngaysinh, gioitinh, tenlop. kiểm tra tên đó có tồn tại trong bảng lớp không. 
--nếu không thì đưa ra thông báo
create proc cau3 
				(@masv char(10), 
				@hoten nvarchar(100), 
				@ngaysinh datetime, 
				@gioitinh char(5), 
				@tenlop nvarchar(100)
				)
as
	begin
		if (not exists (select * from lop where tenlop = @tenlop))
			print('khong co ten trong bang lop')
		else
			begin
				declare @malop char(10)
				select @malop = malop from lop where tenlop = @tenlop
				insert into sinhvien 
				values (@masv, @hoten, @ngaysinh, @gioitinh, @malop)
			end
	end
go
drop proc cau3
--test
exec cau3 'sv06', 'Nguyen Chu', '06-27-2000', 'Nam', 'cntt2' --lỗi không có tên lớp
exec cau3 'sv07', 'Nguyen Huy', '06-04-2000', 'Nam', 'hoa1'
select * from sinhvien

--cau4: tạo trigger cập nhật lại mã lớp của 1 sinh viên (chuyển sang lớp khác), khi đó cập nhật lại sĩ số các lớp có sự thay đổi
--nếu sĩ sỗ lớp chuyển đến >=80 thì đưa ra thông báo lỗi
create trigger cau4
on sinhvien
for update
as
	begin
		declare @malop1 char(10)
		set @malop1 = (select malop from deleted)
		declare @malop2 char(10) 
		set @malop2 = (select malop from inserted)
		declare @siso int
		set @siso =(select siso from lop where malop = @malop2)
		if(@siso >= 80)
			begin
				raiserror(N'Không thể thêm sinh viên vào lớp này!',16,1)
				rollback transaction
			end
		else
			begin
				update lop
				set siso = siso-1
				where malop = @malop1
				
				update lop
				set siso = siso+1
				where malop = @malop2 
			end 
	end
go
drop trigger cau4
-- test
select * from sinhvien
select * from lop

update sinhvien 
set malop ='ml01'
where masv ='sv02'
