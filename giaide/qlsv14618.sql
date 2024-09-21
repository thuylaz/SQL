create database qlsv14618

go
use qlsv14618
go

create table khoa(
	mak nchar(10) not null primary key,
	tenk nchar(20),
	dc nchar(20),
	sdt int,
	email nchar(20)
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
	gioi nchar(20),
	mal nchar(10) not null,
	constraint fk_l_s foreign key(mal)
	references lop(mal)
)

insert into khoa values
('k1', 'cntt', 'hn', 949494, 'thuynhungthien'),
('k2', 'kt', 'hy', 75757, 'thuycnhn16'),
('k3', 'nn', 'hn', 646464, 'kienthon3')

insert into lop values
('l1', 'sql', 45, 'k1'),
('l2', 'qtkd', 70, 'k2'),
('l3', 'nna', 75, 'k3')

insert into sv values
('sv1', 'thuy', '03-22-2006','nu', 'l1'),
('sv2', 'nhung', '10-25-2006','nu', 'l2'),
('sv3', 'thien', '07-07-2006','nam', 'l3'),
('sv4', 'lan', '12-06-2006','nu', 'l2'),
('sv5', 'trang', '03-14-2006','nu', 'l1')

--ham
create function a(@tk nchar(20))
returns @bang table(
					masv nchar(10),
					hoten nchar(20),
					tuoi int)
as
begin
	insert into @bang
	select masv, hoten, year(getdate())-year(ngays) from sv join lop
	on sv.mal=lop.mal
	join khoa on khoa.mak=lop.mak
	where @tk=tenk
	return 
end

select *from dbo.a('cntt')

--proc
create proc b(@tutuoi int, @dentuoi int, @tl nchar(20))
as
begin
	select masv, hoten, ngays, tenl, tenk, year(getdate())-year(ngays) from sv join lop
	on sv.mal=lop.mal
	join khoa
	on khoa.mak=lop.mak
	where year(getdate())-year(ngays) between @tutuoi and @dentuoi 
	and @tl=tenl
end

exec b 10, 20, 'sql'

--trigger
create trigger c
on sv
for insert
as
begin
	declare @sss int
	set @sss=(select siso from lop join inserted
					on lop.mal= inserted.mal)
	if(@sss>80)
		begin
			raiserror('loi k them sv',16,1)
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
select *from lop
select *from sv
insert into sv values('sv7', 'thien', '07-07-2006','nam', 'l3')
select *from lop
select *from sv