create database QLKHO61

go
use QLKHO61
go

create table ton(
	mavt char(30) not null primary key,
	tenvt char(30),
	slt int
)

create table nhap(
	sodhn char(20) not null primary key,
	mavt char(30) not null,
	sln int,
	dgn int,
	ngayn datetime,
	constraint fk_N_Vt foreign key(mavt)
	references ton(mavt)
)

create table xuat(
	sohdx char(20) not null primary key,
	mavt char(30) not null,
	slx int,
	dgx int,
	ngayx datetime,
	constraint fk_X_Vt foreign key(mavt)
	references ton(mavt)
)

insert into ton values
(1, 'ban', 1),
(2, 'ghe', 2),
(3, 'tu', 5),
(4, 'but', 2),
(5, 'cap', 3)

insert into nhap values
('p1', 1, 6, 4, '09/22/2003'),
('p2', 2, 7, 9, '09/22/2003'),
('p3', 3, 8, 5, '09/22/2003')

insert into xuat values
('x1', 1, 2, 4, '10/22/2003'),
('x2', 2, 3, 7, '10/22/2003')

--cau d
delete nhap
from nhap join xuat
on nhap.mavt= xuat.mavt
where dgx<dgn

select *from nhap

--cau e
update xuat
set ngayx= ngayn
from nhap join xuat
on nhap.mavt= xuat.mavt
where ngayx<ngayn

select *from xuat

