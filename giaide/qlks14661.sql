create database qlks14661

go 
use qlks14661
go

create table khach(
	makhach nchar(10) not null primary key,
	tenkhach nchar(20),
	sodt int,
	email nchar(20),
	dc nchar(20)
)

create table phong(
	maphong nchar(10) not null primary key,
	tenphong nchar(20),
	loaiphong int,
	gia money,
	songuoi int
)

create table hoadon(
	sohd nchar(10) not null primary key,
	makhach nchar(10) not null,
	maphong nchar(10) not null,
	songay int,
	constraint fk_hd_k foreign key(makhach)
	references khach(makhach),
	constraint fk_hd_p foreign key(maphong)
	references phong(maphong)
)

insert into khach values
('k1', 'thuy', 75737, 'thuynhungthien', 'hn'),
('k2', 'nhung', 757327, 'thuycnhn16', 'hy'),
('k3', 'thien', 757237, 'kienthon3', 'nd')

insert into phong values
('p1', 'sale', 1, 2000, 3),
('p2', 'cntt', 2, 3000, 5),
('p3', 'pro', 3, 4000, 2)

insert into hoadon values
('hd1', 'k1', 'p1', 5),
('hd2', 'k2', 'p3', 7),
('hd3', 'k3', 'p2', 3),
('hd4', 'k3', 'p3', 2),
('hd5', 'k1', 'p1', 4)


--ham
create function a(@lp int, @son int)
returns @bang table(
					makhach nchar(10),
					tenkhach nchar(20),
					maphong nchar(10),
					tenphong nchar(20))
as
begin
	insert into @bang 
	select khach.makhach, tenkhach, phong.maphong, tenphong from khach join hoadon
		on khach.makhach=hoadon.makhach
		join phong on phong.maphong=hoadon.maphong
	where @lp=loaiphong and @son= songay
	return
end

select *from dbo.a(1,5)

--thu tuc
create proc b(@shd nchar(10), @mk nchar(10), @tp nchar(20), @sn int)
as
begin
	if(not exists(select *from phong where @tp=tenphong))
		print('loi k ton tai phong')
	else
		declare @mp nchar(10)
		select @mp= maphong from phong
		insert into hoadon values(@shd,@mk,@mp,@sn)
end

--k thuc thi
exec b 'hd6', 'k3', 'salee', 3

--thuc thi
exec b 'hd7', 'k3', 'sale', 3
select *from hoadon

--trigger
create trigger c
on hoadon
for insert
as
begin
	declare @mp nchar(10)
	select @mp=maphong from phong
	declare @mk nchar(10)
	select @mk=makhach from khach
	if(not exists(select *from phong where @mp=maphong))
		begin
			raiserror('loi k co phong',16,1)
			rollback tran
		end
	else
		if(not exists(select *from khach where @mk=makhach))
		begin
			raiserror('loi k co khach',16,1)
			rollback tran
		end
	else
		begin	
			update phong set songuoi=songuoi+1
			from phong join inserted
			on phong.maphong=inserted.maphong
			where phong.maphong=inserted.maphong
		end
end

drop trigger c
select *from phong
select *from hoadon
insert into hoadon values('hd9', 'k3', 'p3', 2)
select *from phong
select *from hoadon