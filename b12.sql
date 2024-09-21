use master
go

create database b12
on primary(
	name= 'b12_dat',
	filename= 'D:\SQL\b12.mdf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

log on(
	name= 'b12_log',
	filename= 'D:\SQL\b12.ldf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

go
use b12
go

create table congty(
	mact nchar(20) not null primary key,
	tenct nvarchar(30),
	trangthai nvarchar(20),
	thanhpho nvarchar(30)
)

create table sp(
	masp nchar(20) not null primary key,
	tensp nvarchar(30),
	mausac nchar(10) default N'Đỏ',
	gia money,
	slco int,
	constraint unique_SP unique(tensp)
)

create table cungung(
	mact nchar(20) not null,
	masp nchar(20) not null,
	slban int,
	constraint chk_slb check(slban>0),
	constraint pk_cu primary key(mact, masp),
	constraint fk_cu_ct foreign key(mact)
	references congty(mact),
	constraint fk_cu_SP foreign key(masp)
	references sp(masp)
)

insert into congty values
('U1', 'Unilever', 'good', N'Hà Nội'),
('U2', 'Unilever2', 'goodd', N'Hà Nội'),
('U3', 'Unilever3', 'gooddd', N'Hà Nội')

insert into sp(masp, tensp, gia, slco) values
(1, 'sp1', 100, 1),
(2, 'sp2', 100, 4),
(3, 'sp3', 100, 7)

insert into cungung values
('U1', 1, 1),
('U2', 2, 1),
('U2', 3, 3),
('U3', 3, 5),
('U3', 2, 2),
('U3', 1, 1)

select*from congty
select*from sp
select*from cungung
