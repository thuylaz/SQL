create database qlsv23

go
use qlsv23
go

create table mon(
	mamon nchar(10) not null primary key,
	tenmon nchar(20),
	tinlt int,
	tinth int
)

create table sv(
	masv nchar(10) not null primary key,
	hoten nchar(20),
	ngays datetime
)

create table dangky(
	madk nchar(10) not null primary key,
	masv nchar(10) not null,
	mamon nchar(10) not null,
	ngaydk datetime,
	constraint fk_dk_m foreign key(mamon)
	references mon(mamon),
	constraint fk_dk_s foreign key(masv)
	references sv(masv)
)

insert into mon values
('m1', 'sql', 3,7),
('m2', 'gt', 4,6),
('m3', 'oop', 5,4)

insert into sv values
('sv1', 'thuy', '03-22-2006'),
('sv2', 'nhung', '10-25-2006'),
('sv3', 'thien', '07-07-2006')


insert into dangky values
('dk1', 'sv1','m1', '03-22-2006'),
('dk2', 'sv2', 'm2', '03-23-2006'),
('dk3', 'sv3','m3', '04-22-2006'),
('dk4', 'sv1','m2', '04-2-2006'),
('dk5', 'sv2','m1', '03-24-2006')

--function
create function a(@tenm nchar(20), @x int)
returns int
as
begin
	declare @tksv int
	set @tksv=(select count(sv.masv) from sv join dangky
					on sv.masv=dangky.masv
					join mon on mon.mamon=dangky.mamon
					where @tenm=tenmon and @x>day(ngaydk))
					return @tksv
end

select  dbo.a('sql', 27)

--proc
create proc b(@msv nchar(10), @tm nchar(20), @ngay datetime)
as
begin
	if(not exists(select *from mon where tenmon=@tm))
		print('loi k co ten mon')
	else
		begin
			declare @mdk nchar(10)=(select madk from dangky where masv=@msv)
			declare @mm nchar(10)= (select mamon from mon where tenmon=@tm)
			insert into dangky values(@mdk,@msv,@mm,@ngay)
		end
end

drop proc b
exec b 'sv1', 'oop', '03-24-2006'

--trigger
create trigger c
on dangky
for insert
as
begin
	declare @msv nchar(10)
	declare @mm nchar(10)
	select @msv= masv from inserted
	select @mm= mamon from inserted
	if(not exists(select *from sv where masv=@msv))
		begin
			raiserror('loi k co masv nay',16,1)
			rollback tran
		end
	else
		if(not exists(select *from mon where mamon=@mm))
			begin
				raiserror('loi k co mamon nay',16,1)
				rollback tran
			end
end

drop trigger c
insert into dangky values('dk8', 'sv36', 'm2', '03-23-2006')
select *from dangky
