use master
go

create database quanlsv
on primary(
	name= 'quanlsv_dat',
	filename= 'D:\SQL\quanlsv.mdf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

log on(
	name= 'quanlsv_log',
	filename= 'D:\SQL\quanlsv.ldf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

go
use quanlsv
go

create table lop(
	malop char(20) not null primary key,
	tenlop nvarchar(30),
	phong int
)

create table sv(
	masv char(20) not null primary key,
	tensv nvarchar(20),
	malop char(20) not null,
	constraint fk_Sv_l foreign key(malop)
	references lop(malop)
)

insert into lop values
(1, 'CD', 1),
(2, 'DH', 2),
(3, 'LT', 2),
(4, 'CH', 4)

insert into sv values
(1, 'A', 1),
(2, 'B', 2),
(3, 'C', 1),
(4, 'D', 3)

--1
create function cau1(@malop char(20))
returns int
as begin
declare @sl int
select @sl= count(sv.masv)
from sv, lop
where sv.malop= lop.malop and sv.malop= @malop
group by lop.tenlop
return @sl
end

select dbo.cau1(1)

--2
create function cau2(@tenlop nvarchar(30))
returns @cau1 table(
	malop char(20),
	tenlop nvarchar(30),
	sl int
) 
as begin
if(not exists (select malop from lop where tenlop= @tenlop))
insert into @cau1
select lop.malop, tenlop, count(sv.masv)
from lop,sv
where lop.malop= sv.malop
group by lop.malop, tenlop
else
insert into @cau1
select lop.malop, tenlop, count(sv.masv)
from lop,sv
where lop.malop= sv.malop and tenlop= @tenlop
group by lop.malop, tenlop
return 
end

select *from dbo.cau2('CH')