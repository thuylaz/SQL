use master
go

create database Quanlsv
on primary(
	name= 'Quanlsv_dat',
	filename= 'D:\SQL\Quanlsv.mdf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

log on(
	name= 'Quanlsv_log',
	filename= 'D:\SQL\Quanlsv.ldf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

go
use Quanlsv
go

create table lop(
	malop char(20) not null primary key,
	tenlop nvarchar(20),
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
create function c1(@malop char(20))
returns int
as begin
declare @sl int
select @sl= count(sv.masv)
from sv join lop
on sv.malop= lop.malop
where @malop= lop.malop
group by lop.tenlop
return @sl
end

--c2
create function c2(@tenlop nvarchar(20))
returns @ds table(masv char(20), tensv nvarchar(20))
as begin
insert into @ds
select masv, tensv
from sv join lop
on sv.malop= lop.malop
where @tenlop= tenlop
return
end

select *from c2('LT')

--c3
create function c3(@tenlop nvarchar(20))
returns @tksv table(malop char(20), tenlop nvarchar(20), sl int)
as begin 
if(not exists(select malop from lop where tenlop=@tenlop))
insert into @tksv
select lop.malop, tenlop, count(masv)
from lop join sv
on lop.malop= sv.malop
group by lop.malop, tenlop
else
insert into @tksv
select lop.malop, tenlop, count(masv)
from lop join sv
on lop.malop= sv.malop
where @tenlop= lop.tenlop
group by lop.malop, tenlop
return
end

select *from c3('LT')

--c4
create function c4(@tensv nvarchar(20))
returns int
as begin
declare @tenp int
select @tenp= phong
from sv join lop
on sv.malop= lop.malop
where @tensv=tensv
return @tenp
end

select dbo.c4('A')

--c5
create function c5(@phong int)
returns @tksv1 table(masv char(20), tensv nvarchar(20), tenlop nvarchar(20))
as begin 
if(not exists(select masv, phong from sv join lop
				on sv.malop= lop.malop
				where @phong= phong))
insert into @tksv1
select masv, tensv, tenlop
from sv join lop
on sv.malop= lop.malop
else
insert into @tksv1
select masv, tensv, tenlop
from sv join lop
on sv.malop= lop.malop
where @phong= phong
return 
end

select *from c5('3')

--c6
create function c6(@phong int)
returns int
as begin
declare @sll int
select @sll= count(lop.malop)
from lop
where @phong= phong
return @sll
end

select dbo.c6('3')
