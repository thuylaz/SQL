create database qlbv2

go
use qlbv2
go

create table benhvien(
	mabv nchar(10) not null primary key,
	tenbv nchar(20),
	dc nchar(20)
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
('bv1', 'bachmai', 'hn'),
('bv2', 'nhidong', 'hy'),
('bv3', 'huyethoc', 'nd')

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
create view a
as
	select tenbv,tenkhoa,count(benhnhan.mabn) as 'so bn'
	from benhvien join khoakham
	on benhvien.mabv=khoakham.mabv
	join benhnhan on benhnhan.makhoa=khoakham.makhoa
	where gioi='nu'
	group by benhvien.tenbv,khoakham.tenkhoa

select *from a

--function
create function b(@tbv nchar(20), @tk nchar(20))
returns int
as
begin
	declare @tong int
	set @tong= (select sum(songaynv*100000)
						from benhnhan join khoakham
						on benhnhan.makhoa=khoakham.makhoa
						join benhvien on benhvien.mabv=khoakham.mabv
						where @tk=tenkhoa and @tbv=tenbv
						group by khoakham.makhoa)
	return @tong
end

drop function b
select dbo.b('bachmai','nhi')


--trigger
create trigger c
on benhnhan
for update
as
begin
	declare @sbn int
	select @sbn= sobn from khoakham
	if(@sbn>=100)
		begin
			raiserror('thong bao loi',16,1)
			rollback tran
		end
	else
		declare @sbntrc int
		declare @sbnsau int
		set @sbntrc= (select sobn from khoakham join deleted
							on khoakham.makhoa=deleted.makhoa)
		set @sbnsau= (select sobn from khoakham join inserted
							on khoakham.makhoa=inserted.makhoa)
		begin
			update khoakham set sobn=@sbntrc-1
			from khoakham join deleted
			on khoakham.makhoa=deleted.makhoa
			update khoakham set sobn=@sbnsau+1
			from khoakham join inserted
			on khoakham.makhoa=inserted.makhoa
		end
end

drop trigger c
select *from khoakham
select *from benhnhan
update benhnhan set makhoa='k2' where hoten='nhung'
select *from khoakham
select *from benhnhan