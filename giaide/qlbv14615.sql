create database qlbv14615

go
use qlbv14615
go

create table benhnhan(
	mabn nchar(10) not null primary key,
	tenbn nchar(20),
	gioi nchar(20),
	sodt int,
	email nchar(20)
)

create table khoa(
	makhoa nchar(10) not null primary key,
	tenkhoa nchar(20),
	diachi nchar(20),
	tienngay money,
	tongbn int
)

create table hoadon(
	sohd nchar(10) not null primary key,
	mabn nchar(10) not null,
	makhoa nchar(10) not null,
	songay int,
	constraint fk_hd_bn foreign key(mabn)
	references benhnhan(mabn),
	constraint fk_hd_k foreign key(makhoa)
	references khoa(makhoa)
)

insert into benhnhan values
('bn1', 'thuy', 'nu', 373743, 'thuynhungthien'),
('bn2', 'nhung', 'nu', 3737343, 'thuycnhn'),
('bn3', 'thien', 'nam', 3723743, 'kienthon3')

insert into khoa values
('k1', 'hoisuc', 'hn', 100000, 200),
('k2', 'nhi', 'hy', 100000, 300),
('k3', 'capcuu', 'nd', 100000, 250)

insert into hoadon values
('hd1', 'bn1', 'k1', 10),
('hd2', 'bn2', 'k3', 20),
('hd3', 'bn3', 'k2', 13),
('hd4', 'bn1', 'k1', 15),
('hd5', 'bn2', 'k2', 17)

--ham
create function a(@mbn nchar(10))
returns int
as
begin
	declare @tong int
	set @tong= (select sum(tienngay*songay) from benhnhan join hoadon
				ON benhnhan.mabn= hoadon.mabn
				join khoa on khoa.makhoa=hoadon.makhoa
				where @mbn=benhnhan.mabn)
	return @tong
end
drop function a
select dbo.a('bn2')

--thu tuc
create proc b(@shd nchar(10), @mbn nchar(10), @tk nchar(20), @sn int)
as
begin
	if(not exists(select *from khoa where @tk=tenkhoa))
		print('loi k co khoa')
	else
		begin
			declare @mk nchar(10)
			select @mk=makhoa from khoa
			insert into hoadon values(@shd,@mbn,@mk,@sn)
		end
end
drop proc b
exec b 'hd6', 'bn1', 'hoisuc', 15
select *from hoadon

--trigger
create trigger c
on hoadon
for insert
as
begin
	update khoa set tongbn=tongbn+1
	from khoa join inserted
	on khoa.makhoa=inserted.makhoa
end

select *from khoa
select *from hoadon
insert into hoadon values('hd6', 'bn1', 'k1', 15)
select *from khoa
select *from hoadon