create database qlbh20

go
use qlbh20
go

drop table vattu
create table vattu(
	mavt nchar(10) not null primary key,
	tenvt nchar(20),
	dvt nchar(10),
	slcon int
)

create table hoadon(
	mahd nchar(10) not null primary key,
	ngayl datetime,
	hotenk nchar(20)
)

create table cthoadon(
	mahd nchar(10) not null,
	mavt nchar(10) not null,
	dg int,
	slb int,
	constraint fk_ct_vt foreign key(mavt)
	references vattu(mavt),
	constraint fk_ct_hd foreign key(mahd)
	references hoadon(mahd)
)

insert into vattu values
('vt1', 'but', 'cai', '90'),
('vt2', 'thuoc', 'cai', '120'),
('vt3', 'ban', 'cai', '150')

insert into hoadon values
('h1', '09-22-2003', 'thuy'),
('h2', '07-05-2003', 'nhung'),
('h3', '09-08-2003', 'thien')

insert into cthoadon values
('h1', 'vt1', 20, 30),
('h2', 'vt2', 30, 20),
('h3', 'vt1', 10, 10),
('h1', 'vt2', 40, 30),
('h2', 'vt3', 20, 10)

--c1
create function a(@tvt nchar(20), @ngay datetime)
returns int
as
begin
	declare @tongtien int
	set @tongtien= (select dg*slb as tongtien 
					from cthoadon join vattu
					on cthoadon.mavt=vattu.mavt
					join hoadon on hoadon.mahd=cthoadon.mahd
					where @tvt= tenvt and @ngay=ngayl)
	return @tongtien
end

select dbo.a('but', '09-22-2003')

--c2
create proc b(@x int, @y int)
as
begin
	select sum(slb) from cthoadon join hoadon
	on cthoadon.mahd=hoadon.mahd
	where @x=MONTH(ngayl) and @y=year(ngayl) 

end

drop proc b
exec b 09, 2003

--c3
create trigger c
on cthoadon
for delete
as
begin
	if(select count(*) from cthoadon)=1
		begin
			raiserror('loi k the xoa',16,1)
			rollback tran
		end
	else
		begin
			declare @slbb int
			declare @mhd nchar(10)
			declare @mvt nchar(10)
			select @mhd=mahd from deleted
			select @mvt= mavt from deleted
			select @slbb= slb from deleted
			delete from cthoadon where mahd=@mhd
			update vattu set slcon=slcon+ @slbb
			where mavt=@mvt
		end
end

select *from vattu
select *from cthoadon
delete from cthoadon where mahd='h3'
select *from vattu
select *from cthoadon
