use master
go
create database de2
use de2
go

--cau1
create table hang
(mahang char(10) not null primary key,
tenhang nvarchar(100) not null,
dvtinh char(10) not null,
slton int
)
drop table hang

create table hdban
(mahd char(10) not null primary key,
ngayban datetime not null,
hotenkhach nvarchar(100) not null
)
drop table hdban

create table hangban
(mahang char(10) not null,
mahd char(10) not null,
dongia float not null,
soluong int not null check(soluong >= 0),
constraint pk primary key (mahang, mahd),
constraint fk foreign key (mahang) references hang(mahang) on update cascade on delete cascade,
constraint fk1 foreign key (mahd) references hdban(mahd) on update cascade on delete cascade
)
drop table hangban

--chen du lieu
insert into hang
(mahang, tenhang, dvtinh, slton)
values	('mh01', 'tivi', 'chiec', 65),
		('mh02', 'tu lanh', 'cai', 17);

insert into hdban
(mahd, ngayban, hotenkhach)
values	('hd01', '05-06-2020', 'Nguyen Trang'),
		('hd02', '12-17-2019', 'Le Huy');

insert into hangban
(mahang, mahd, dongia, soluong)
values	('mh01', 'hd01', 6100000, 61),
		('mh01', 'hd02', 3200000, 32),
		('mh02', 'hd01', 6500000, 65),
		('mh02', 'hd02', 2750000, 27);

select * from hang
select * from hdban
select * from hangban

--cau2: tạo view đưa ra thống kê tiền hàng bán theo từng hoá đơn gồm: mahd, ngayban, tongtien=(dongia*soluoong)
create view v_cau2
as
	select hdban.mahd, ngayban, sum(dongia*soluong) as 'tong tien'
	from hangban inner join hdban
	on hangban.mahd = hdban.mahd
	group by hdban.mahd, ngayban
drop view v_cau2
--test 
select * from v_cau2

--cau3: tạo thủ tục lưu trữ tìm kiếm hàng theo tháng và năm (với 2 tham số truyền vào là tháng và năm)
--danh sách đưa ra gồm mahang, tenhang, ngayban, soluong, ngaythu (trong do ngaythu là chủ nhật, thứ hai,...dựa vào cột ngayban)
create proc cau3 (@thang int, @nam int)
as
	begin
		select hang.mahang, tenhang, ngayban, soluong, datename(weekday,ngayban) as 'NgayThu' 
		from hangban inner join hang on hangban.mahang = hang.mahang
					inner join hdban on hangban.mahd = hdban.mahd
		where @thang = month(ngayban) and @nam = year(ngayban)
	end
go
drop proc cau3
--test
exec cau3 12,2019
select * from hang
select * from hdban
select * from hangban
	

--cau4: tạo trigger tự động giảm slton trong bảng hàng, mỗi khi thêm một dữ liệu mới cho bảng hangban, đưa ra thông báo lỗi nếu (soluong>slton)
create trigger cau4
on hangban
for insert
as	
	begin
		declare @sl int
		set @sl = (select soluong from inserted)
		declare @mahang char(10)
		set @mahang = (select mahang from inserted)
		if(@sl > (select slton from hang where mahang = @mahang))
			begin
				raiserror(N'Số lượng bán không được phép lớn hơn số lượng tồn',16,1)
				rollback transaction
			end
		else
			begin
				update hang
				set slton = slton -@sl
				where mahang = @mahang
			end
	end
go
drop trigger cau4
--test trước khi chèn bảng hàng bán phải chèn bảng hdban/hang vì có khoá ngoài mahd/mahang thay đổi
insert into hdban 
(mahd, ngayban, hotenkhach)
values ('hd03','07-24-2020','Nguyen Thuy')
--sl<slton
insert into hangban   
(mahang, mahd, dongia, soluong)
values ('mh01', 'hd03', 610000, 160)
--sl>slton
insert into hangban 
(mahang, mahd, dongia, soluong)
values ('mh01', 'hd03', 610000, 1000)

select * from hang
select * from hdban
select * from hangban

--cau5: đưa ra hoá đơn có số mặt hàng > 1 gồm: mahd, số mặt hàng
select mahd, count(mahang) as 'so mat hang'
from hangban
group by mahd
having count(mahang)>1

--cau6: tạo hàm in ra tổng tiền hàng bán theo năm với tham số là năm
create function cau6 (@nam int)
returns int
as
	begin
		declare @tongtien int
		select @tongtien = sum(dongia*soluong) l
		from hangban inner join hdban
		on hangban.mahd = hdban.mahd
		where @nam = year(ngayban)
		return @tongtien
	end
go
drop function cau6
--test
select dbo.cau6 (2020) as 'tongtien'
select dbo.cau6 (2019) as 'tongtien'

--cau7: tạo view đưa ra mahd có tổng tiền bán > 1000000 gồm: mahd, tongtien=soluong*dongia
create view cau7
as
	select mahd, sum(soluong*dongia) as 'tongtien'
	from hangban
	group by mahd
	having sum(soluong*dongia) > 1000000
drop view cau7
--test
select * from cau7

--cau8: tạo thủ tục xoá 1 mặt hàng nhập vào từ bàn phím
create proc cau8 (@mahang char(10))
as
	begin
		delete from hangban where mahang = @mahang
		delete from hang where mahang = @mahang
	end
go
drop proc cau8
--test 
exec cau8 'mh01'
--cau9: tạo trigger thêm 1 hoá đơn bán, nếu ngày bán != ngày hiện tại thì hiện thông báo
create trigger cau9
on hdban
for insert 
as
	begin
		if ((select ngayban from inserted) != getdate())
			begin	
				raiserror ('loi', 16, 1)
				rollback transaction
			end
		/*else
			begin	
				insert into hdban
				values (@mahd, @ngayban, @hotenkhach)
			end*/
	end
go
drop trigger cau9
--test
insert into hdban
values ('hd03', '10-17-2020', 'Le Trang')
select * from hdban