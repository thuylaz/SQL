create database qlthuoc14619

go 
use qlthuoc14619
go

create table thuoc(
	mathuoc nchar(10) not null primary key,
	tenthuoc nchar(20),
	sl int,
	gia money,
	nhasx nchar(20)
)

create table benhnhan(
	mabn nchar(10) not null primary key,
	tenbn nchar(20),
	gioi nchar(20)
)

create table donthuoc(
	madon nchar(10) not null primary key,
	mathuoc nchar(10) not null,
	slb int,
	ngayban datetime,
	mabn nchar(10) not null,
	constraint fk_dt_t foreign key(mathuoc)
	references thuoc(mathuoc),
	constraint fk_dt_bn foreign key(mabn)
	references benhnhan(mabn)
)

insert into thuoc values
('t1', 'om', 30, 2000, 'dongy'),
('t2', 'ho', 50, 20400, 'tayy'),
('t3', 'cam', 70, 22000, 'bacy')

insert into benhnhan values
('bn1', 'thuy', 'nu'),
('bn2', 'thien', 'nam'),
('bn3', 'nhung', 'nu')

insert into donthuoc values
('d1', 't1', 10, '09-22-2003', 'bn1'),
('d2', 't2', 2, '09-23-2003', 'bn3'),
('d3', 't3', 7, '09-27-2003', 'bn2'),
('d4', 't3', 6, '09-09-2003', 'bn1'),
('d5', 't1', 3, '09-08-2003', 'bn2')

--ham
create function a(@nsx nchar(20), @ngay datetime)
returns @bang table(
					mabn nchar(10),
					tenbn nchar(20),
					gioi nchar(20),
					mathuoc nchar(10),
					tenthuoc nchar(20),
					sl int,
					gia money)
as
begin
	insert into @bang
	select benhnhan.mabn, tenbn, gioi, donthuoc.mathuoc, tenthuoc, sl, gia from benhnhan join donthuoc
	on benhnhan.mabn= donthuoc.mabn
	join thuoc
	on thuoc.mathuoc=donthuoc.mathuoc
	where @ngay=ngayban and @nsx=nhasx
	return
end

drop function a
select *from dbo.a('bacy','09-09-2003')

--tt
create proc b(@md nchar(10), @tt nchar(20), @slb int, @ngayb datetime, @mbn nchar(10))
as
begin
	if(not exists(select *from thuoc where @tt=tenthuoc))
		print('loi thuoc k ton tai')
	else
		begin
			declare @mt nchar(10)
			select @mt=mathuoc from donthuoc
			insert into donthuoc values(@md, @mt, @slb, @ngayb, @mbn)
		end
end

--k thuc thi
exec b 'd6', 'ojm', 7, '09-27-2003', 'bn2'
select *from donthuoc

--thuc thi
exec b 'd6', 'om', 7, '09-27-2003', 'bn2'
select *from donthuoc

--trigger
create trigger c
on donthuoc
for insert
as
begin
	declare @slbb int
	select @slbb=slb from inserted
	declare @sll int
	set @sll=(select sl from thuoc join inserted
					on thuoc.mathuoc=inserted.mathuoc)
	if(@slbb>=@sll)
		begin
			raiserror('loi k dc nhap',16,1)
			rollback tran
		end
	else
		begin
			update thuoc set sl=sl-@slbb
			from thuoc join inserted
			on thuoc.mathuoc=inserted.mathuoc
		end
end

drop trigger c
--k thuc thi
insert into donthuoc values('d8', 't3', 70000, '09-27-2003', 'bn2')
select *from donthuoc

--k thuc thi
insert into donthuoc values('d8', 't3', 7, '09-27-2003', 'bn2')
select *from donthuoc