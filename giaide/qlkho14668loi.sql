create database qlkho14668

go 
use qlkho14668
go

create table ton(
	mavt nchar(10) not null primary key,
	tenvt nchar(20),
	mau nchar(20),
	sl int,
	gia money, 
	slt int
)

create table nhap(
	sohdn nchar(10) not null primary key,
	mavt nchar(10) not null,
	sln int,
	gian money,
	ngayn datetime,
	constraint fk_n_t foreign key(mavt)
	references ton(mavt)
)

create table xuat(
	sohdx nchar(10) not null primary key,
	mavt nchar(10) not null,
	slx int,
	ngayx datetime,
	constraint fk_n_x foreign key(mavt)
	references ton(mavt)
)

insert into ton values
('vt1', 'but', 'do', 300, 2000, 50),
('vt2', 'giay', 'trang', 500, 4000, 150),
('vt3', 'thuoc', 'den', 700, 3000, 55),
('vt4', 'ban', 'do', 350, 7000, 50),
('vt5', 'ghe', 'vang', 1300, 8000, 50)

insert into nhap values
('n1', 'vt1', 10000, 1500, '09-22-2003'),
('n2', 'vt3', 12000, 2500, '09-23-2003'),
('n3', 'vt5', 15000, 3500, '09-27-2003')

insert into xuat values
('x1', 'vt2', 200, '12-22-2003'),
('x2', 'vt4', 300, '10-22-2003'),
('x3', 'vt5', 400, '11-22-2003')

--ham
create function a(@nx datetime, @mvt nchar(10))
returns @bang table(
					mavt nchar(10),
					tenvt nchar(20),
					tongtien int)
as
begin
	insert into @bang
	select ton.mavt, tenvt, slx*gia from xuat join ton
					on xuat.mavt=ton.mavt
					where @nx=ngayx and @mvt=ton.mavt
	return
end

select *from dbo.a('12-22-2003','vt2')

--thu tuc
create proc b(@shdx nchar(10), @mvt nchar(10), @slx int, @nx datetime)
as
begin
	if(not exists(select *from ton where @mvt=mavt))
		print('loi k co vat tu')
	else
		begin
			insert into xuat values(@shdx,@mvt,@slx,@nx)
		end
end

--k thuc thi
exec b 'x4', 'vt42', 200, '12-22-2003'

--thuc thi
exec b 'x4', 'vt2', 200, '12-22-2003'

--trigger
create trigger c
on nhap
for insert 
as
begin
	declare @mvt nchar(10)
	select @mvt=mavt from ton
	if(not exists(select *from ton where @mvt=mavt))
		begin
			raiserror('loi k co vat tu',16,1)
			rollback tran
		end
	else
		begin
			declare @slnn int
			select @slnn= sln from inserted
			update ton set sl=sl+@slnn
			where mavt=(select mavt from inserted)
		end
end

drop trigger c

--k thuc thi
insert into nhap values('n5', 'vt81', 12000, 2500, '09-23-2003')
select *from nhap
select *from ton
