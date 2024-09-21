create database qlbh24

go
use qlbh24
go

create table hang(
	mahang nchar(10) not null primary key,
	tenhang nchar(20),
	slcon int
)

create table hoadon(
	mahd nchar(10) not null primary key,
	ngayl datetime,
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
('vt1', 'but', '90'),
('vt2', 'thuoc', '120'),
('vt3', 'ban', '150')

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

--function
create function a(@x int, @y int)
returns @bang table(
					mahang nchar(10),
					tenhang nchar(20),
					tongslb int)
as
begin
	insert into @bang
	select hang.mahang, tenhang, sum(slb) from hang join hangban
	on hang.mahang=hangban.mahang
	join hoadon on hoadon.mahd=hangban.mahd
	where day(ngayl) between @x and  @y
	group by hang.mahang, tenhang
	return 
end
drop function a

select *from dbo.a(8,22)
select *from hangban


--thutuc
create proc b(@mhd nchar(10), @tenh nchar(20), @dgb int, @sl int)
as
begin
	if(not exists(select *from hang where tenhang=@tenh))
		print('loi chua da co hang')
	else 
		begin
			declare @mah nchar(10)= (select mahang from hang where tenhang=@tenh)
			insert into hangban values(@mhd, @mah, @dgb, @sl)
		end
end

exec b 'h1', 'but', 20, 30
select *from hangban

--trigger
create trigger c
on hangban
for insert
as
begin
	declare @slban int
	declare @slco int
	select @slban= slb from inserted
	select @slco= slcon from hang
	if(@slban>@slco)
		begin
			raiserror('loi xra',16,1)
			rollback transaction
		end
	else
		begin
			update hang set slcon=slcon-@slban
			from hang join inserted
			on hang.mahang=inserted.mahang
		end
end

drop trigger c
select *from hang
select *from hangban
insert into hangban values('h1', 'vt3', 40, 10)
select *from hang
select *from hangban
