create database qltruonghoc14597

go
use qltruonghoc14597
go

create table gv(
	magv nchar(10) not null primary key,
	tengv nchar(20)
)

create table lop(
	malop nchar(10) not null primary key,
	tenlop nchar(20),
	phong int,
	siso int,
	magv nchar(10) not null,
	constraint fk_l_gv foreign key(magv)
	references gv(magv)
)

create table sv(
	masv nchar(10) not null primary key,
	tensv nchar(20),
	gioitinh nchar(20),
	que nchar(20),
	malop nchar(10) not null,
	constraint fk_svv_l foreign key(malop)
	references lop(malop)
)

insert into gv values
('gv1', 'thuy'),
('gv2', 'nhung'),
('gv3', 'thien')

insert into lop values
('l1', 'sql', 601, 70, 'gv1'),
('l2', 'oop', 602, 65, 'gv2'),
('l3', 'gt', 603, 40, 'gv3')

insert into sv values
('sv1', 'hoang1', 'nam', 'hn', 'l1'),
('sv2', 'hoang2', 'nu', 'nd', 'l2'),
('sv3', 'hoang3', 'nu', 'hy', 'l1'),
('sv4', 'hoang4', 'nam', 'hn', 'l3'),
('sv5', 'hoang5', 'nam', 'vp', 'l2')


--function
create function a(@tl nchar(20), @tgv nchar(20))
returns @bang table(
					masv nchar(10),
					tensv nchar(20),
					gioitinh nchar(20),
					que nchar(20),
					malop nchar(10))
as
begin
	insert into @bang
	select masv, tensv, gioitinh, que, lop.malop from sv join lop
	on sv.malop=lop.malop
	join gv on gv.magv=lop.magv
	where @tl=tenlop and @tgv=tengv
	return
end

drop function a
select *from dbo.a('sql','thuy')

--proc
create proc b(@msv nchar(10), @tsv nchar(20), @gt nchar(20), @queq nchar(20), @tl nchar(20))
as
begin
	if(not exists(select *from lop where @tl=tenlop))
		print('loi k co ten lop')
	else
		begin
			declare @ml nchar(10)
			select @ml=malop from lop
			insert into sv values(@msv, @tsv, @gt, @queq, @ml)
		end
end

drop proc b
--k thuc thi
exec b 'sv6', 'hoang3', 'nu', 'hy', 'hshs'
select *from sv

-- thuc thi
exec b 'sv6', 'hoang3', 'nu', 'hy', 'sql'
select *from sv

--trigger
create trigger c
on sv
for update
as
begin
	declare @sstrc int
	set @sstrc=(select siso from lop join deleted
	on lop.malop=deleted.malop where lop.malop=deleted.malop)
	declare @sss int
	set @sss=(select siso from lop join inserted
	on lop.malop=inserted.malop 
	where lop.malop=inserted.malop)
	update lop set siso=siso-1
	from lop join deleted
	on lop.malop=deleted.malop
	update lop set siso=siso+1
	from lop join inserted
	on lop.malop=inserted.malop
end

select *from lop
select *from sv
update sv set malop='l2' where masv='sv3'
select *from lop
select *from sv