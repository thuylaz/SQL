create database qlsv19

go
use qlsv19
go

create table khoa(
	mak nchar(10) not null primary key,
	tenk nchar(20),
	ngaytl datetime
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
	mal nchar(10) not null,
	constraint fk_l_s foreign key(mal)
	references lop(mal)
)

insert into khoa values
('k1', 'cntt', '09-22-2003'),
('k2', 'kt', '10-01-2003'),
('k3', 'nn', '02-22-2003')

insert into lop values
('l1', 'sql', 45, 'k1'),
('l2', 'qtkd', 70, 'k2'),
('l3', 'nna', 75, 'k3')

insert into sv values
('sv1', 'thuy', '03-22-2006', 'l1'),
('sv2', 'nhung', '10-25-2006', 'l2'),
('sv3', 'thien', '07-07-2006', 'l3'),
('sv4', 'lan', '12-06-2006', 'l2'),
('sv5', 'trang', '03-14-2006', 'l1')

--c2
create function a(@tk nchar(20), @tl nchar(20))
returns @bang table(
					masv nchar(10),
					hoten nchar(20),
					tuoi int)
as
begin
	insert into @bang
		select masv, hoten, (year(getdate())-year(ngays)) as tuoi
		from sv join lop
		on sv.mal=lop.mal
		join khoa
		on lop.mak=khoa.mak
		where tenk=@tk and tenl=@tl
		return
end

select *from dbo.a('cntt','sql')

--c3
create proc b(@tk nchar(20), @x int)
as
begin
	if(not exists(select *from lop join khoa
	on lop.mak=khoa.mak where tenk=@tk and siso>@x))
		print('k co lop co si so > x')
	else
		begin
			select *from lop join khoa
			on lop.mak=khoa.mak
			where tenk=@tk
		end
end
drop proc b

exec b 'cntt', 46

--c4
create trigger c
on sv
for delete
as
begin
	declare @msv nchar(10)
	declare @ml nchar(10)
	select @msv=masv from deleted
	select @ml=mal from lop
	if not exists(select *from sv where masv=@msv)
		begin
			raiserror('k co sv nay',16,1)
			rollback transaction
		end			
	else
		begin
			delete from sv where masv= @msv
			update lop set siso=siso-1
			where mal=@ml
		end	
end

drop trigger c

select *from sv
select *from lop
delete sv where masv='sv1'
select *from sv
select *from lop
