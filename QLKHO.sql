create database QLKHO

go
use QLKHO
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
('p2', 2, 7, 7, '09/22/2003'),
('p3', 3, 8, 5, '09/22/2003')

insert into xuat values
('x1', 1, 2, 4, '10/22/2003'),
('x2', 2, 3, 7, '10/22/2003')

--cau 2
create view cau2
as
select tenvt
from ton 
where slt= (select max(slt)from ton))

select *from c2

--cau 3
create view c3
as
select mavt, slx
from xuat 
where slx>100

select *from c3

--c4
create view c4
as
select slx, year(ngayx), month(ngayx)
from xuat

--c5
create view c5
as
select nhap.mavt, tenvt, sln, slx, dgn, ngayx
from xuat join nhap
on xuat.mavt= nhap.mavt
join ton
on ton.mavt= nhap.mavt


--c6
create view c6
as
select ton.mavt, tenvt, sln-slx+slt as N'còn'
from xuat join ton
on xuat.mavt= ton.mavt
join nhap
on nhap.mavt= ton.mavt

select *from c6

