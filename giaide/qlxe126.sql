create database qlxe126

go 
use qlxe126
go

create table xe(
	maxe nchar(10) not null primary key,
	tenxe nchar(20),
	sl int
)

create table khachhang(
	makh nchar(10) not null primary key,
	tenkh nchar(20),
	dc nchar(20),
	sodt int,
	email nchar(20)
)

create table thuexe(
	sohd nchar(10),
	makh nchar(10) not null,
	maxe nchar(10) not null,
	songayt int,
	slt int,
	constraint fk_tx_x foreign key(maxe)
	references xe(maxe),
	constraint fk_tx_k foreign key(makh)
	references khachhang(makh)
)

insert into xe values
('x1', 'oto', 300),
('x2', 'xemay', 400),
('x3', 'xedap', 3500)

insert into khachhang values
('k1', 'thuy', 'nd', 858585, 'thuynhungthien'),
('k2', 'nhung', 'hn', 8548585, 'thuycnhn'),
('k3', 'thien', 'hy', 8528585, 'kienthon3')

insert into thuexe values
('h1', 'k1', 'x1', 10, 2),
('h2', 'k2', 'x2', 20, 3),
('h3', 'k1', 'x3', 12, 4),
('h4', 'k3', 'x3', 13, 8),
('h5', 'k2', 'x1', 14, 5)

--ham
create function a(@dcc nchar(20))
returns int
as
begin
	declare @tong int
	set @tong= (select sum(slt) from thuexe join khachhang
						on thuexe.makh=khachhang.makh
						where @dcc=dc
						group by thuexe.makh)
	return @tong
end

drop function a
select dbo.a('nd')

--thu tuc
create proc b(@shd nchar(10), @mk nchar(20), @mx nchar(10), @snt int, @sltt int, @kq int out)
as
begin
	if(not exists(select *from khachhang where @mk=makh))
		set @kq=1
	else
		if(not exists(select *from xe where @mx=maxe))
			set @kq=2
	else
		begin
			set @kq=0
			insert into thuexe values(@shd,@mk,@mx,@snt,@sltt)
		end
end

--k thuc thi
declare @bien int
exec b 'h6', 'k15', 'x13', 12, 4, @bien out
select @bien

--thuc thi
declare @bien1 int
exec b 'h6', 'k1', 'x1', 12, 4, @bien1 out
select @bien1
select *from thuexe

--trigger
create trigger c
on thuexe
for insert
as
begin
	declare @sltt int
	declare @sll int
	select @sltt= slt from inserted
	select @sll= sl from xe
	if(@sltt>=@sll)
		begin
			raiserror('loi k them dc',16,1)
			rollback tran
		end
	else
		begin
			update xe set sl=sl-@sltt
			from xe join inserted
			on xe.maxe=inserted.maxe
			where xe.maxe=inserted.maxe
		end
end

drop trigger c
--k thuc thi
select *from xe
select *from thuexe
insert into thuexe values('h7', 'k1', 'x3', 12, 40000)
select *from xe
select *from thuexe

--thuc thi
select *from xe
select *from thuexe
insert into thuexe values('h7', 'k1', 'x3', 12, 4)
select *from xe
select *from thuexe
