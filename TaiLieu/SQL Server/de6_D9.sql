use master
go
create database de6
use de6
go

--cau1:
create table benhvien
(mabv char(10) not null primary key,
tenbv nvarchar(100) not null
)
drop table benhvien

create table khoakham
(makhoa char(10) not null primary key,
tenkhoa nvarchar(100) not null,
sobn int not null,
mabv char(10) not null,
constraint fk2 foreign key (mabv) references benhvien(mabv) on update cascade on delete cascade
)
drop table khoakham

create table benhnhan
(mabn char(10) not null primary key,
hoten nvarchar(100) not null,
ngaysinh datetime not null,
gioitinh bit not null,
songaynv int not null,
makhoa char(10) not null,
constraint fk3 foreign key (makhoa) references khoakham(makhoa) on update cascade on delete cascade
)
drop table benhnhan

--insert into
insert into benhvien
values	('bv01', 'bach mai'),
		('bv02', 'viet duc');

insert into khoakham
values	('mk01', 'khoa noi', '100', 'bv01'),
		('mk02', 'khoa ngoai', '150', 'bv02');

insert into benhnhan
values	('bn01', 'Nguyen Van A', '01-02-1995', 0, 10, 'mk02'),
		('bn02', 'Nguyen Thi B', '02-03-1996', 1, 20, 'mk01'),
		('bn03', 'Nguyen Van C', '03-04-1997', 0, 30, 'mk02'),
		('bn04', 'Nguyen Thi D', '04-05-1998', 1, 40, 'mk01'),
		('bn05', 'Nguyen Van E', '05-06-1999', 0, 15, 'mk02'),
		('bn06', 'Nguyen Thi F', '06-07-1998', 1, 25, 'mk01'),
		('bn07', 'Nguyen Van G', '07-08-1997', 0, 35, 'mk02');

select * from benhvien
select * from khoakham
select * from benhnhan

--cau2: đưa ra những bệnh nhân có tuổi cao nhất: mabn, hoten, tuoi
select top 1 mabn, hoten, year(getdate())-year(ngaysinh) as 'tuoi'
from benhnhan
order by tuoi desc

--cau3: viết hàm với tham số mabn, hàm trả về một bảng gồm các thông tin: mabn, hoten, ngaysinh, gioitinh("nam" và "nữ"), tenkhoa, tenbv
create function cau3 (@mabn char(10))
returns @bn table
		(mabn char(10),
		hoten nvarchar(100),
		ngaysinh datetime,
		gioitinh char(5),
		tenkhoa nvarchar(100),
		tenbv nvarchar(100))
as
	begin
		insert into @bn	
			select mabn, hoten, ngaysinh, case gioitinh when 0 then 'nam' when 1 then 'nu' end as 'gioi tinh', tenkhoa, tenbv
			from khoakham inner join benhvien on benhvien.mabv = khoakham.mabv
							inner join benhnhan on khoakham.makhoa = benhnhan.makhoa
			where @mabn = mabn
		return 		
	end
go
drop function cau3
--test 
select * from cau3 ('bn01')
select * from cau3 ('bn02')
select * from cau3 ('bn03')
select * from cau3 ('bn04')
select * from cau3 ('bn05')
select * from cau3 ('bn06')
select * from cau3 ('bn07')

--cau4:  tạo trigger tự động tăng số bệnh nhân trong bảng khoakham, mỗi khi thêm data cho bảng benhnhan. nếu số bệnh nhân trong 1 khoa>100 thì k cho thêm và thông báo lỗi
create trigger cau4
on benhnhan
for insert 
as
	begin
		declare @sobenhnhan int
		select @sobenhnhan  = khoakham.sobn from khoakham inner join inserted on khoakham.makhoa = inserted.makhoa
		if (@sobenhnhan > 100)
			begin
				raiserror ('qua 100 benh nhan', 16, 1)
				rollback transaction
			end
		else
			begin
				update khoakham
				set sobn = sobn + 1
				from khoakham, inserted
				where khoakham.makhoa = inserted.makhoa
			end
	end
go
drop trigger cau4
--test
select * from benhvien
select * from khoakham
select * from benhnhan
--sobn < 100
insert into benhnhan
values ('bn08', 'Nguyen Thi H', '08-09-1996', 0, 45, 'mk01')
--sobn > 100
insert into benhnhan
values ('bn09', 'Nguyen Van I', '09-10-1995', 0, 55, 'mk02')