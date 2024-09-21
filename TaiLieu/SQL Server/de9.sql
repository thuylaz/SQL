use master
go
create database de9
use de9
go

--cau1:
create table tg
(matg char(10) not null primary key,
tentg nvarchar(100) not null
)
drop table tg

create table nxb
(manxb char(10) not null primary key,
tennxb nvarchar(100) not null
)
drop table nxb

create table sach
(masach char(10) not null primary key,
tensach nvarchar(100) not null,
slco int not null check(slco>=0),
ngayxb datetime not null,
matg char(10) not null,
manxb char(10) not null,
constraint fk foreign key (matg) references tg(matg) on update cascade on delete cascade, 
constraint fk1 foreign key (manxb) references nxb(manxb) on update cascade on delete cascade
)
drop table sach

--chen du lieu
insert into tg
values	('tg01', 'Nguyen Van A'),
		('tg02', 'Nguyen Thi B');

insert into nxb
values	('nxb01', 'Khoa hoc xa hoi'),
		('nxb02', 'Giao duc');

insert into sach
values	('ms01', 'toan', 256, '03-26-2019', 'tg01', 'nxb02'),
		('ms02', 'ly', 526, '04-27-2020', 'tg01', 'nxb02'),
		('ms03', 'hoa', 625, '05-28-2018', 'tg02', 'nxb01'),
		('ms04', 'anh', 652, '06-29-2019', 'tg01', 'nxb02'),
		('ms05', 'van', 265, '07-30-2020', 'tg02', 'nxb01');

select * from tg
select * from nxb
select * from sach

--cau2: tạo view đưa ra thông tin tổng hợp theo từng tác giả: matg, tentg, số sách đã viết
create view cau2
as
	select tg.matg, tentg, sum(slco) as 'so sach da viet'
	from tg inner join sach
	on tg.matg = sach.matg
	group by tg.matg, tentg
drop view cau2
--test 
select * from cau2

--cau3: tạo hàm đưa ra thông tin tổng hợp theo từng tác giả; matg, tentg, số sách đã viết với tham số truyền vào là matg
create function cau3 (@matg char(10))
returns @ds table
		(matg char(10),
		tentg nvarchar(100),
		sosach int)
as
	begin
		insert into @ds
			select  tg.matg, tentg, sum(slco) as 'so sach da viet'
			from tg inner join sach
			on tg.matg = sach.matg
			where @matg = tg.matg
			group by tg.matg, tentg
		return
	end
go
drop function cau3
--test 
select * from cau3 ('tg01')
select * from cau3 ('tg02')

--cau4: tạo trigger thêm 1 sách mới, kiểm tra ngayxb <= ngày hiện tại
create trigger cau4
on sach 
for insert 
as
	begin
		if (select ngay from inserted <= getdate())
		begin
			raiserror ('loi ngay', 16, 1)
			rollback transaction 
		end
	end
go
--test
insert sach
values ('ms06', 'sinh', 254, '07-29-2019', 'tg02', 'nxb02')
select * from sach