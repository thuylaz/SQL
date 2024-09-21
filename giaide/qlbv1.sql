create database qlbv1

go
use qlbv1
go

create table benhvien(
	mabv nchar(10) not null primary key,
	tenbv nchar(20)
)

create table khoakham(
	makhoa nchar(10) not null primary key,
	tenkhoa nchar(20),
	sobn int,
	mabv nchar(10) not null,
	constraint fk_kk_bv foreign key(mabv)
	references benhvien(mabv)
)

create table benhnhan(
	mabn nchar(10) not null primary key,
	hoten nchar(20),
	gioi nchar(20),
	songaynv int,
	makhoa nchar(10) not null,
	constraint fk_bn_k foreign key(makhoa)
	references khoakham(makhoa)
)

insert into benhvien values
('bv1', 'bachmai'),
('bv2', 'nhidong'),
('bv3', 'huyethoc')

insert into khoakham values
('k1', 'nhi', 30, 'bv1'),
('k2', 'ungthu', 50, 'bv2'),
('k3', 'huyet', 90, 'bv3')

insert into benhnhan values
('bn1', 'thuy', 'nu', 5, 'k1'),
('bn2', 'nhung', 'nu', 7, 'k2'),
('bn3', 'thien', 'nam', 15, 'k3'),
('bn4', 'tuyet', 'nu', 20, 'k2'),
('bn5', 'lan', 'nu', 25, 'k1')

--ham
create function a(@gt nchar(20))
returns @bang table(
					tenbv nchar(20),
					tongbn int)
as
begin
	insert into @bang
	select tenbv, count(benhnhan.mabn) from benhnhan join khoakham
	on benhnhan.makhoa=khoakham.makhoa
	join benhvien on benhvien.mabv=khoakham.mabv
	where @gt=gioi
	group by khoakham.makhoa, tenbv
	return
end
drop function a
select *from dbo.a('nu')

--thu tuc
create proc b(@tk nchar(20), @tbv nchar(20))
as
begin
	if(not exists(select *from benhvien join khoakham
					on benhvien.mabv=khoakham.mabv
					where tenkhoa=@tk and tenbv=@tbv))
		begin	
			print('k co khoa+ bv nay')
			
		end
	else
		begin
			select sum(sobn) from benhvien join khoakham
				on benhvien.mabv=khoakham.mabv
				where tenkhoa=@tk and tenbv=@tbv
		end
end
drop proc b
--k thuc thi
exec b 'nhir', 'bachrmai'

--thuc thi
exec b 'nhi', 'bachmai'

--trigger
create trigger c
on benhnhan
for insert
as
begin
	declare @sbnn int
	select @sbnn= sobn from khoakham
	declare @tk nchar(20)
	select @tk=tenkhoa from khoakham

	if(@sbnn>100)
		begin
			declare @noti nchar(100)
			set @noti='k the them vao ' + @tk 
			raiserror(@noti,16,1)
			rollback tran
		end
	else
		begin
			update khoakham set sobn=sobn+1
			from khoakham join inserted
			on khoakham.makhoa=inserted.makhoa
			where khoakham.makhoa=inserted.makhoa
		end
end
drop trigger c
select *from khoakham
select *from benhnhan
insert into benhnhan values('bn8', 'tuyet', 'nu', 20, 'k4')
select *from khoakham
select *from benhnhan