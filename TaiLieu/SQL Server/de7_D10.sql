use master
go
create database de7
use de7
go

--cau1
create table ton
(mavt char(10) not null primary key,
tenvt nvarchar(100) not null,
soluongt int not null check(soluongt > 0)
)
drop table ton
 
create table nhap
(sohdn char(10) not null primary key,
mavt char(10) not null,
soluongn int not null check(soluongn > 0),
dongian float not null,
ngayn datetime not null,
constraint fk foreign key (mavt) references ton(mavt) on update cascade on delete cascade
)
drop table nhap

create table xuat
(sohdx char(10) not null primary key,
mavt char(10) not null,
soluongx int not null check(soluongx > 0),
dongiax float not null,
ngayx datetime not null,
constraint fk1 foreign key (mavt) references ton(mavt) on update cascade on delete cascade
)
drop table xuat

--insert 
insert into ton 
values	('vt01', 'tivi', 123),
		('vt02', 'tu lanh', 234),
		('vt03', 'dieu hoa', 345),
		('vt04', 'quat', 456),
		('vt05', 'may giat', 567);

insert into nhap
values	('hdn01', 'vt01', 100, 2000000, '05-06-2020'),
		('hdn02', 'vt03', 150, 1500000, '12-17-2019'),
		('hdn03', 'vt05', 200, 1000000, '11-27-2018');

insert into xuat
values	('hdx01', 'vt02', 250, 2500000, '01-06-2020'),
		('hdx02', 'vt04', 300, 3500000, '02-03-2019');

select * from ton
select * from nhap
select * from xuat

--cau2: tạo view thống kê tiền bán theo mavt gồm mavt, tenvt, tienban=soluongx*dongiax
create view cau2
as
	select ton.mavt, tenvt, sum(soluongx*dongiax) as 'tienban'
	from ton inner join xuat
	on ton.mavt = xuat.mavt
	group by ton.mavt, tenvt
go
drop view cau2
--test
select * from cau2

--cau3: tạo hàm thống kê tiền bán theo mavt gồm mavt, tenvt, tienban=soluongx*dongiax với tham số là mavt
create function cau3 (@mavt char(10))
returns @tk table
		(mavt char(10),
		tenvt nvarchar(100),
		tienban float)
as
	begin
		insert into @tk
			select ton.mavt, tenvt, sum(soluongx*dongiax) as 'tienban'
			from ton inner join xuat
			on ton.mavt = xuat.mavt
			where ton.mavt = @mavt
			group by ton.mavt, tenvt
		return 
	end
go
drop function cau3
--test
select * from cau3 ('vt01')
select * from cau3 ('vt02')
select * from cau3 ('vt03')
select * from cau3 ('vt04')
select * from cau3 ('vt05')

--cau4: tạo thủ tục lưu trữ đưa ra thống kê mavt, tenvt, soluongt và tiendong = soluongt*dongian vs tham số là mavt, đơn giá nhập để tính tiền đọng lấy theo đơn giá nhập mã của vật tư đó
create proc cau4 (@mavt char(10))
as
	begin
		select ton.mavt, tenvt, soluongt, sum(soluongt*dongian) as 'tien dong'
		from ton inner join nhap
		on ton.mavt = nhap.mavt
		where @mavt = ton.mavt
		group by ton.mavt, tenvt, soluongt
	end
go
drop proc cau4
--test
exec cau4 'vt01'
exec cau4 'vt02'
exec cau4 'vt03'
exec cau4 'vt04'
exec cau4 'vt05'
	




