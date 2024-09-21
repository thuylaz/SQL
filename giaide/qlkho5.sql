create database qlkho5

go
use qlkho5
go

create table vattu(
	mavt nchar(10) not null primary key,
	tenvt nchar(20),
	slcon int
)

create table phieuxuat(
	sopx nchar(10) not null primary key,
	ngayx datetime,
	hotenk nchar(20)
)

create table hangxuat(
	sopx nchar(10) not null,
	mavt nchar(10) not null,
	gia money,
	slb int
	constraint fk_hx_vt foreign key(mavt)
	references vattu(mavt),
	constraint fk_hx_px foreign key(sopx)
	references phieuxuat(sopx)
)

insert into vattu values
('vt1', 'but', 300),
('vt2', 'ban', 300),
('vt3', 'ghe', 300)

insert into phieuxuat values
('px1', '09-22-2023', 'thuy'),
('px2', '06-22-2003', 'nhung'),
('px3', '08-22-2023', 'thien')

insert into hangxuat values
('px1', 'vt3', 20, 10),
('px2', 'vt2', 10, 5),
('px3', 'vt1', 20, 15),
('px2', 'vt3', 40, 20),
('px3', 'vt3', 20, 30)

--ham
create view a
as
	select phieuxuat.sopx, ngayx, gia*slb as 'tongtien' from phieuxuat join hangxuat
	on phieuxuat.sopx=hangxuat.sopx
	where year(ngayx)= year(getdate())

drop view a
select *from a

--thu tuc
create proc b(@thang int, @nam int)
as
begin
	select sum(slb) as 'tong sl vt xuat'
	from hangxuat join phieuxuat
	on hangxuat.sopx=phieuxuat.sopx
	where @thang=MONTH(ngayx) and @nam=YEAR(ngayx)
end

exec b 8,2023

--trigger
create trigger c
on hangxuat
for insert,delete
as
begin
	declare @slc int
	declare @slms int
	declare @slcu int
	select @slc=slcon from vattu
	set @slcu= (select slb from deleted)
	set @slms= (select slb from inserted)
	declare @action nchar(1)
	set @action= (case when exists(select *from inserted) then 'I'
					when exists(select *from deleted) then 'D'
					end)
	--xoa
	if(@action='D')
		begin
			update vattu set slcon=@slc+ @slcu
			from vattu join deleted
			on vattu.mavt=deleted.mavt
		end
	else
		begin
			if(@slms>@slc)
				begin
					raiserror('loi k dc cap nhat',16,1)
					rollback tran
				end
			else
				begin
					update vattu set slcon=@slc- @slms
					from vattu join inserted
					on vattu.mavt=inserted.mavt
				end
		end
end
drop trigger c

--k thuc thi
select *from vattu
select *from hangxuat
insert into hangxuat values('px1', 'vt1', 20, 499990)
select *from vattu
select *from hangxuat

--thuc thi
select *from vattu
select *from hangxuat
delete from hangxuat where sopx='px1' and mavt='vt3'
select *from vattu
select *from hangxuat

select *from vattu
select *from hangxuat
insert into hangxuat values('px1', 'vt1', 20, 40)
select *from vattu
select *from hangxuat