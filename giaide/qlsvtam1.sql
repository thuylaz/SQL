create database qlsvtam1

go
use qlsvtam1
go

create table khoa(
	mak nchar(10) not null primary key,
	tenk nchar(20),
)

create table lop(
	mal nchar(10) not null primary key,
	tenl nchar(20),
	siso int,
	mak nchar(10) not null,
	constraint fk_l_k foreign key(mak)
	references khoa(mak)
)

create table sv(
	masv nchar(10) not null primary key,
	hoten nchar(20),
	ngays datetime,
	gioi bit,
	mal nchar(10) not null,
	constraint fk_l_s foreign key(mal)
	references lop(mal)
)

insert into khoa values
('k1', 'cntt'),
('k2', 'kt'),
('k3', 'nn')

insert into lop values
('l4', 'nna', 85, 'k3'),
('l1', 'sql', 45, 'k1'),
('l2', 'qtkd', 70, 'k2'),
('l3', 'nna', 75, 'k3')

insert into sv values
('sv1', 'thuy', '03-22-2006',1, 'l1'),
('sv2', 'nhung', '10-25-2006',1, 'l2'),
('sv3', 'thien', '07-07-2006',0, 'l3'),
('sv4', 'lan', '12-06-2006',1, 'l2'),
('sv5', 'trang', '03-14-2006',1, 'l1')

--ham 
create view a
as
	select tenk, count(mal) as 'so_lop' from lop join khoa
	on lop.mak=khoa.mak
	group by khoa.tenk
drop view a
select *from a

--ham
create function b(@mk nchar(10))
returns @bang table(
					masv nchar(10),
					hoten nchar(20),
					ngays datetime,
					gioi nchar(20),
					tenl nchar(20),
					tenk nchar(20))
as
begin
	insert into @bang
	select masv, hoten, ngays,
	case gioi when 0 then 'nam' else 'nu' end, 
	tenl, tenk 
	from lop join khoa
	on lop.mak=khoa.mak
	join sv on sv.mal=lop.mal
	where @mk=khoa.mak
	return
end
drop function b
select *from dbo.b('k1')

--trigger
create trigger c
on sv
for insert
as
begin
	declare @ss int
	set @ss=(select siso from lop join inserted
					on lop.mal=inserted.mal)
	if(@ss>80)
		begin
			raiserror('loi k dc them',16,1)
			rollback tran
		end
	else
		begin
			update lop set siso=siso+1
			from lop join inserted
			on lop.mal=inserted.mal
			where lop.mal=inserted.mal
		end
end

drop trigger c
--k thuc thi
insert into sv values('sv6', 'mai', '03-14-2006',1, 'l4')

--thuc thi
select *from lop
select *from sv
insert into sv values('sv6', 'mai', '03-14-2006',1, 'l2')
select *from lop
select *from sv