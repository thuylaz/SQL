create database qlsvtam6

go
use qlsvtam6
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


--select 
select masv, hoten, year(getdate())-year(ngays) 
from sv
where year(getdate())-year(ngays) = (select min(year(getdate())-year(ngays)) from sv)

--thu tuc
create proc b(@tutuoi int, @dentuoi int)
as
begin
	select masv, hoten, ngays, tenl, tenk, year(getdate())-year(ngays) as 'tuoi' 
	from sv join lop
	on sv.mal=lop.mal
	join khoa on khoa.mak=lop.mak
	where year(getdate())-year(ngays) between @tutuoi and @dentuoi
end

exec b 10,20

