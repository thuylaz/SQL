create database khoa81

go
use khoa81
go

create table khoa(
	makhoa nvarchar(20) not null primary key,
	tenkhoa nvarchar(20),
	dienthoai int
)

create table lop(
	malop nvarchar(20) not null primary key,
	tenlop nvarchar(20),
	khoa nvarchar(20),
	hedt nvarchar(20),
	namnh int,
	makhoa nvarchar(20) not null,
	constraint fk_l_k foreign key(makhoa)
	references khoa(makhoa)
)

--thu tuc
--c1
create proc nhap_khoa(@mak nvarchar(20), @tenk nvarchar(20), @dt int)
as
begin
	if(exists(select *from khoa where tenkhoa=@tenk))
		print(N'ten khoa da ton tai trong bang')
	else 
		
			insert into khoa
			values(@mak, @tenk, @dt)
		
end

exec nhap_khoa 'it', 'httt', 0559725125
exec nhap_khoa 'kt', 'qtkd', 0943304218
select *from khoa

--c2
create proc nhap_lop(@mal nvarchar(20), @tenl nvarchar(20), @k nvarchar(20), @he nvarchar(20), @nam int, @mak nvarchar(20))
as
begin
	if(exists(select *from lop where tenlop= @tenl))
		print(N'ten lop da ton tai trong bang')
	else 
		if(not exists(select *from khoa where makhoa=@mak))
			print(N'ma khoa chua ton tai')
	else 
			insert into lop 
			values(@mal, @tenl, @k, @he, @nam, @mak)		
end

exec nhap_lop 'lop1', 'httt1', 'it1', 'dh', '2021', 'it'
exec nhap_lop 'lop2', 'httt2', 'it2', 'dh', '2021', 'it'
exec nhap_lop 'lop3', 'qtkd1', 'kt1', 'dh', '2021', 'kt'

select *from lop
