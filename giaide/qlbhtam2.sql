create database qlbhtam2

go
use qlbhtam2
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
					mah nchar(10),
					tenh nchar(20),
					ngayb datetime,
					sl int,
					ngaythu nchar(20))
as
begin
	insert into @bang
	select hang.mahang, tenhang, ngayban, slb, 
	case datepart(dw,ngayban)
		when 2 then 'thu 2'
		when 3 then 'thu 3'
		when 4 then 'thu 4'
		when 5 then 'thu 5'
		when 6 then 'thu 6'
		when 7 then 'thu 7'
		when 1 then 'chu nhat'
	end as ngaythu
	from hangban join hang
	on hang.mahang=hangban.mahang
	join hoadon on hoadon.mahd= hangban.mahd
	where @thang=month(ngayban) and @nam=year(ngayban)
	return
end

select *from dbo.a(7,2003)

--trigger
create trigger b
on hangban
for insert
as
begin
	declare @sltt int
	select @sltt = slton from hang
	declare @slbb int
	select @slbb= slb from inserted
	if(@slbb>@sltt)
		begin
			raiserror('loi k them',16,1)
			rollback tran
		end
	else
		begin
			update hang set slton=slton-@slbb
			from hang join hangban
			on hang.mahang=hangban.mahang
			where hang.mahang=hangban.mahang
		end
end

--k thuc thi
insert into hangban values('h3', 'vt2', 10, 19990)

--k thuc thi
select *from hang
select *from hangban
insert into hangban values('h3', 'vt2', 10, 20)
select *from hang
select *from hangban