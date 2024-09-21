create database qlnx14614

go
use qlnx14614
go

create table sp(
	masp nchar(10) not null primary key,
	tensp nchar(20),
	sl int,
	gia int,
	mau nchar(20)
)

create table nhap(
	sohdn nchar(10) not null primary key,
	masp nchar(10) not null,
	sln int,
	ngayn datetime,
	constraint fk_n_s foreign key(masp)
	references sp(masp)
)

create table xuat(
	sohdx nchar(10) not null primary key,
	masp nchar(10) not null,
	ngayx datetime,
	slx int,
	constraint fk_x_s foreign key(masp)
	references sp(masp)
)

insert into sp values
('s1', 'but', 50, 2000, 'do'),
('s2', 'thuoc', 43, 5000, 'xanh'),
('s3', 'ban', 72, 7000, 'den'),
('s4', 'ghe', 86, 23000, 'vang'),
('s5', 'bang', 83, 22000, 'nau')

insert into nhap values
('n1', 's1', 34, '02-07-2022'),
('n2', 's3', 45, '02-07-2022'),
('n3', 's5', 52, '02-07-2022')

insert into xuat values
('x1', 's1', '03-07-2022', 20),
('x2', 's3', '04-07-2022', 22),
('x3', 's5', '05-07-2022', 23)


--ham
create function a(@tsp nchar(20))
returns int
as
begin
	declare @tt int
	set @tt=(select sln*gia from sp join nhap
	on sp.masp=nhap.masp
	where @tsp=tensp )
	return @tt
end

select dbo.a('but')

--thu tuc
create proc b(@msp nchar(10), @tsp nchar(20), @sll int, @giab money, @mauu nchar(20), @kq int out)
as
begin
	if(exists(select *from sp where @tsp=tensp))
		set @kq=1
	else
		begin
			set @kq=0
			insert into sp values(@msp,@tsp,@sll,@giab,@mauu)
		end
end

drop proc b
--k thuc thi
declare @bien int
exec b 's3', 'ban', 72, 7000, 'den', @bien out
select @bien
select *from sp

--thuc thi
declare @bien int
exec b 's6', 'ghghh', 72, 7000, 'den', @bien out
select @bien
select *from sp

--trigger
create trigger c
on xuat
for insert
as
begin
	declare @slxx int
	select @slxx= slx from inserted
	declare @sll int
	set @sll=(select sl from sp join inserted
					on sp.masp=inserted.masp)
	if(@slxx>@sll)
		begin
			raiserror('loi k dc insert',16,1)
			rollback tran
		end
	else
		begin
			update sp set sl=sl-@slxx
			from sp join inserted
			on sp.masp=inserted.masp
		end
end

drop trigger c
--k thuc thi
select *from sp
select *from xuat
insert into xuat values('x4', 's3', '04-07-2022', 2999992)
select *from sp
select *from xuat

--thuc thi
select *from sp
select *from xuat
insert into xuat values('x4', 's3', '04-07-2022', 20)
select *from sp
select *from xuat