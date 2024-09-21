create database khoa82

go
use khoa82
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
create proc nhap_khoa(@mak nvarchar(20), @tenk nvarchar(20), @dt int, @trave int output)
as
begin
	if(exists(select *from khoa where tenkhoa=@tenk))
		set @trave=3
	else 
		begin
			insert into khoa
			values(@mak, @tenk, @dt)
		end
	return @trave
end
declare @bien1 int
exec nhap_khoa 'it', 'httt', 0559725125, @bien1 output
exec nhap_khoa 'kt', 'qtkd', 0943304218, @bien1 output
select @bien1
select *from khoa

--c2
create proc nhap_lop(@mal nvarchar(20), @tenl nvarchar(20), @k nvarchar(20), @he nvarchar(20), @nam int, @mak nvarchar(20), @trave int out)
as
begin
	if(exists(select *from lop where tenlop=@tenl))
		set @trave=0
	else
	if(not exists(select *from khoa where makhoa=@mak))
		set @trave=1
	else 
		begin
			insert into lop
			values(@mal, @tenl, @k, @he, @nam, @mak)
			set @trave=2
		end
		return @trave
end

declare @bien2 int
exec nhap_lop 'lop1', 'httt1', 'it1', 'dh', '2021', 'it', @bien2 out
exec nhap_lop 'lop2', 'httt2', 'it2', 'dh', '2021', 'it', @bien2 out
exec nhap_lop 'lop3', 'qtkd1', 'kt1', 'dh', '2021', 'kt', @bien2 out
select @bien2

select *from lop
