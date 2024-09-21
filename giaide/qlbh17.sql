create database qlbh17

go
use qlbh17
go

create table congty(
	mact nchar(10) not null primary key,
	tenct nchar(20),
	dc nchar(20)
)

create table sanpham(
	masp char(10) not null primary key,
	tensp char(20),
	slco int,
	gia money
)

create table cungung(
	mact nchar(10) not null,
	masp char(10) not null,
	slcu int,
	constraint fk_cu_ct foreign key(mact)
	references congty(mact),
	constraint fk_cu_sp foreign key(masp)
	references sanpham(masp)
)

insert into congty values
('ct1', 'samsung', 'hn'),
('ct2', 'oppo', 'nd'),
('ct3', 'apple', 'hp')

insert into sanpham values
('sp1', 'samsung1', 463, 20000),
('sp2', 'oppo1', 729, 260000),
('sp3', 'apple1', 540, 520000)

insert into cungung values
('ct1', 'sp1', 30),
('ct2', 'sp1', 50),
('ct3', 'sp2', 35),
('ct2', 'sp3', 60),
('ct1', 'sp2', 40)


--c2
create function a(@x nchar(20))
returns @bang table
				(tensp nchar(20),
				slcu int,
				gia money,
				tongtien int)
as 
begin
	insert into @bang
	select tensp, slcu, gia, slcu*gia
	from sanpham join cungung
	on sanpham.masp=cungung.masp
	join congty
	on congty.mact= cungung.mact
	where tenct=@x
	return 
end

select *from dbo.a('samsung')

--c3
create proc b(@mct nchar(10), @tct nchar(20), @dcc nchar(20), @kq int out)
as
begin
	if(exists(select *from congty where tenct=@tct))
		set @kq=1
	else 
		begin
			set @kq=0
			insert into congty
			values(@mct, @tct, @dcc)
		end
end

declare @bien int
exec b 'ct4', 'redmi', 'hn', @bien out
select @bien

select *from congty

--c4
create trigger c
on cungung
for update
as
begin
	declare @slms int
	declare @slcu int
	declare @slc int
	declare @msp nchar(10)
	select @slcu= slcu from deleted
	select @slms= slcu from inserted
	select @slc= slco from sanpham
	select @msp=masp from inserted
	if(@slms-@slcu>@slc)
		begin
			raiserror('loi k tra ve',16,1)
			rollback transaction
		end
	else
		begin
			update sanpham set 
			slco=slco-(@slms-@slcu)
			where masp=@msp
		end
end

select *from cungung
select *from sanpham
update cungung set slcu=35 where masp='sp1'
select *from cungung
select *from sanpham
