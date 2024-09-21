use master
go
create database de5
use de5
go

--cau1
create table congty
(mact char(10) not null primary key,
tenct nvarchar(100) not null,
trangthai nvarchar(100) not null,
thanhpho nvarchar(100) not null
)
drop table congty

create table sanpham
(masp char(10) not null primary key,
tensp nvarchar(100) not null,
mausac char(20) not null,
soluong int not null check(soluong>=0),
giaban float not null
)
drop table sanpham

create table cungung
(mact char(10) not null,
masp char(10) not null,
slcungung int not null check(slcungung>=0),
ngay datetime not null,
constraint pk primary key (mact, masp),
constraint fk foreign key (mact) references congty(mact) on update cascade on delete cascade,
constraint fk1 foreign key (masp) references sanpham(masp) on update cascade on delete cascade
)
drop table cungung

--insert data
insert into congty
(mact, tenct, trangthai, thanhpho)
values	('ct01', 'san xuat tivi', 'buon ban tot', 'thai binh'),
		('ct02', 'san xuat tu lanh', 'buon ban cham', 'ha noi'),
		('ct03', 'san xuat may giat', 'khong ban duoc hang', 'ha nam');

insert into sanpham
(masp, tensp, mausac, soluong, giaban)
values	('sp01', 'tivi', 'den', 123, 4500000),
		('sp02', 'tu lanh', 'do', 234, 2500000),
		('sp03', 'may giat', 'trang', 345, 3000000);

insert into cungung
(mact, masp, slcungung, ngay)
values	('ct01', 'sp03', '61', '01-02-2020'),
		('ct02', 'sp02', '32', '02-03-2019'),
		('ct03', 'sp01', '65', '03-04-2018'),
		('ct01', 'sp02', '27', '04-05-2017'),
		('ct02', 'sp03', '17', '05-06-2016');

select * from congty
select * from sanpham
select * from cungung

--cau2: tạo hàm đưa ra tensp, mausac, soluong, giaban của công ty với tenct và ngay là tham số nhập từ bàn phím
create function cau2 (@tenct nvarchar(100), @ngay datetime)
returns @sp table 
		(tensp nvarchar(100),
		mausac char(10),
		soluong int,
		giaban float)
as
	begin
		insert into @sp
		select tensp, mausac, soluong, giaban
		from cungung inner join congty on cungung.mact=congty.mact
					inner join sanpham on cungung.masp=sanpham.masp
		where tenct=@tenct and ngay=@ngay
		return
	end
go
drop function cau2
--test
select * from cau2('san xuat tivi', '01-02-2020')
select * from cau2('san xuat tu lanh', '02-03-2019')
select * from cau2('san xuat may giat', '03-04-2018')

--cau3: viết thủ tục thêm mới 1 cung ứng với tenct, tensp, slcungung, ngay nhập từ bàn phím
create proc cau3 (@tenct nvarchar(100), @tensp nvarchar(100), @slcungung int, @ngay datetime)
as
	begin
		declare @mact char(10)
		set @mact = (select mact from congty where tenct = @tenct)
		declare @masp char(10)
		set @masp = (select masp from sanpham where tensp = @tensp)
		insert into cungung
		values (@mact, @masp, @slcungung, @ngay)
	end
go
drop proc cau3
--test
exec cau3 'san xuat dieu hoa', 'dieu hoa', 30, '24-04-2020'
select * from congty
select * from sanpham
select * from cungung

--cau4: tạo trigger update trên bang cungung cập nhật lại slcungung, kiểm tra xem nếu slcungung mới - slcungung cũ <= soluong hay không? nếu thoả mãn thì cập nhật lại số lượng trên bảng sanpham, không thì đưa thông báo lỗi
create trigger cau4
on cungung
for update
as
	begin
		declare @slmoi int
		select @slmoi = slcungung from inserted 
		declare @slcu int
		select @slcu = slcungung from deleted
		if (@slmoi - @slcu <= (select soluong from sanpham where masp = (select masp from inserted)))
			begin
				update sanpham
				set soluong = soluong - (@slmoi - @slcu)
				where masp = (select masp from inserted)
			end
		else
			begin
				raiserror(N'SoluongCungung mới vượt quá số lượng cho phép',16,1)
				rollback transaction
			end
	end
go
-- test 
--loi cap nhat
update cungung
set slcungung = 300
where masp = 'sp01' and mact = 'ct03'
--cap nhat thanh cong
update cungung
set slcungung = 30
where masp = 'sp01' and mact = 'ct03'

select * from cungung
select * from sanpham
