create database qlbh4

go
use qlbh4
go

create table hang(
	mahang nchar(10) not null primary key,
	tenhang nchar(20),
	dvt nchar(20),
	slton int
)

create table hoadon(
	mahd nchar(10) not null primary key,
	ngayban datetime,
	hotenk nchar(20)
)

create table hangban(
	mahd nchar(10) not null,
	mahang nchar(10) not null,
	dg int,
	slb int,
	constraint fk_ct_vt foreign key(mahang)
	references hang(mahang),
	constraint fk_ct_hd foreign key(mahd)
	references hoadon(mahd)
)

insert into hang values
('vt1', 'but', 'cai', '90'),
('vt2', 'thuoc','cai', '120'),
('vt3', 'ban','cai', '150')

insert into hoadon values
('h1', '09-22-2003', 'thuy'),
('h2', '07-05-2003', 'nhung'),
('h3', '09-08-2003', 'thien')

insert into hangban values
('h1', 'vt1', 20, 30),
('h2', 'vt2', 30, 20),
('h3', 'vt1', 10, 10),
('h1', 'vt2', 40, 30),
('h2', 'vt3', 20, 10)

--ham
create function a(@thang int, @nam int)
returns @bang table(
					mahd nchar(10),
					ngayban datetime,
					tongtien int
					)
as
begin
	insert into @bang
	select hoadon.mahd, ngayban, dg*slb as 'tongtien' from hang join hangban
	on hang.mahang=hangban.mahang
	join hoadon on hoadon.mahd=hangban.mahd
	where @thang=month(ngayban) and @nam=year(ngayban) and dg*slb>500
	return
end

drop function a
select *from dbo.a(7,2003)

--proc
create proc b(@mhd nchar(10), @th nchar(20), @dgg money, @sll int, @kq int out)
as
begin
	if(not exists(select *from hang join hangban
					on hang.mahang=hangban.mahang
					join hoadon on hoadon.mahd=hangban.mahd
					where @th=tenhang and @mhd=hoadon.mahd))
		set @kq=0
	else
		begin
			set @kq=1
			declare @mh nchar(10)
			select @mh= mahang from hangban
			insert into hangban values(@mhd,@mh,@dgg,@sll)
		end
end

--k thuc thi
declare @bien int
exec b 'h34', 'but4', 10, 10, @bien out
select @bien
select *from hangban

--thuc thi
declare @bien1 int
exec b 'h3', 'but', 10, 10, @bien1 out
select @bien1
select *from hangban

--trigger
create trigger c
on hangban
for update
as
begin
	declare @slms int
	declare @slcu int
	declare @slt int
	set @slcu=(select slb from deleted)
	set @slms=(select slb from inserted)
	select @slt=slton from hang
	if(@slms-@slcu>@slt)
		begin
			raiserror('loi k the cap nhat',16,1)
			rollback tran
		end
	else
		begin
			update hang set slton=slton-(@slms-@slcu)	
			from inserted,deleted
			where hang.mahang=deleted.mahang
			and deleted.mahd=inserted.mahd
		end
end
drop trigger c
--k thuc thi
select *from hang
select *from hangban
update hangban set slb=49999 where mahd='h1'and mahang='vt1'
select *from hang
select *from hangban

--k thuc thi
select *from hang
select *from hangban
update hangban set slb=40 where mahd='h1' and mahang='vt1'
select *from hang
select *from hangban