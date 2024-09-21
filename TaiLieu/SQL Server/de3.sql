use master
go
create database de3
use de3
go

--cau1:
create table vattu
(mavt char(10) not null primary key, 
tenvt nvarchar(30) not null, 
dvtinh nchar(10), 
slcon int
)
drop table vattu

create table hdban
(mahd char(10) not null primary key, 
ngayxuat datetime not null, 
hotenkhach nvarchar(50)
)
drop table hdban

create table hangxuat
(mahd char(10) not null, 
mavt char(10) not null, 
dongia money not null, 
slban int not null,
constraint pk primary key(mahd,mavt), 
constraint fk1 foreign key(mavt) references vattu(mavt) on update cascade on delete cascade, 
constraint fk2 foreign key(mahd) references hdban(mahd) on update cascade on delete cascade 
)
drop table hangxuat

insert into vattu 
values	('vt01', 'sua', 'thung', 400),
		('vt02', 'thuoc la','bao', 1000);

insert into hdban 
values	('hd01','05-06-2020', 'Nguyen Trang'),
		('hd02','12-17-2020', 'Le Huy');

insert into hangxuat 
values	('hd01','vt01', 100000, 100), 
		('hd01','vt02', 9000, 200),
		('hd02','vt01', 100000, 70),
		('hd02','vt02', 9000, 300);

select * from vattu
select * from hdban
select * from hangxuat

--cau2. Đưa ra hóa đơn có tổng tiền vật tư nhiều nhất gồm: mahd, tổng tiền
select top 1 mahd, sum(dongia*slban) as 'TongTien'
from hangxuat 
group by mahd
order by TongTien desc 

--cau3. Viết hàm với tham số truyền vào là mahd, hàm trả về 1 bảng gồm mahd, ngayxuat, mavt, dongia, slban, ngaythu
--Ngaythu là tên các ngày trong tuần dựa vào giá trị cột ngayxuat
create function cau3 (@mahd char(10))
returns @kq table
		(mahd char(10), 
		ngayxuat datetime,	
		mavt char(10), 
		dongia money, 
		slban int, 
		ngaythu char(10))
as
	begin
		insert into @kq	
			select hdban.mahd, ngayxuat, vattu.mavt, dongia, slban , datename(weekday,ngayxuat)
			from vattu inner join hangxuat on vattu.mavt = hangxuat.mavt 
				inner join hdban on hangxuat.mahd = hdban.mahd
			where hdban.mahd = @mahd
		return
	end
go
drop function cau3
select * from cau3('hd01')
select * from cau3('hd02')

--cau4: Tạo thủ tục lưu trữ in ra tổng tiền vật tư xuất theo tháng và năm. Tham số truyền vào là tháng và năm 
create proc cau4 (@thang int, @nam int)
as
	begin
		select sum(dongia*slban) as ' tong tien'
		from hangxuat inner join hdban on hangxuat.mahd = hdban.mahd
		where month(ngayxuat) = @thang and year(ngayxuat) = @nam 
		group by ngayxuat 
	end
go
drop proc cau4
exec cau4 5,2020
exec cau4 12,2020

--cau5: tạo view đưa ra các hoá đơn xuất vật tư trong năm nay gồm: mahd, ngayxuat, mavt, tenvt, thanhtien
create view cau5
as
	select hdban.mahd, ngayxuat = year(getdate()), vattu.mavt, tenvt, sum(slban*dongia) as 'thanh tien'
	from hangxuat inner join vattu on hangxuat.mavt = vattu.mavt
					inner join hdban on hangxuat.mahd = hdban.mahd
	group by hdban.mahd, ngayxuat, vattu.mavt, tenvt
drop view cau5
--test
select * from cau5

--cau6:tạo trigger tự động giảm slcon trong bảng hàng, mỗi khi thêm một dữ liệu mới cho bảng hangxuat, đưa ra thông báo lỗi nếu (slban>slcon)
create trigger cau6
on hangxuat
for insert
as	
	begin
		declare @sl int
		set @sl = (select slban from inserted)
		declare @mavt char(10)
		set @mavt = (select mavt from inserted)
		if(@sl > (select slcon from vattu where mavt = @mavt))
			begin
				raiserror(N'Số lượng bán không được phép lớn hơn số lượng tồn',16,1)
				rollback transaction
			end
		else
			begin
				update vattu
				set slcon = slcon -@sl
				where mavt = @mavt
			end
	end
go
drop trigger cau6
--test trước khi chèn bảng hàng bán phải chèn bảng hang vì có khoá ngoài mahang thay đổi
insert into hdban
values ('hd03','5-17-2020', 'Le Trang')
--giảm thành công
insert into hangxuat
values ('hd03', 'vt02', 100000, 160)
--giảm không thành công
insert into hangxuat
values ('hd03', 'vt03', 100000, 900)
select * from vattu
select * from hangxuat

--cach 2
create trigger trg_cau6
on hangxuat
for insert
as
	begin
		declare @slcon int
		declare @slban int
		select @slban = slban from inserted
		select @slcon = vattu.slcon 
		from inserted inner join vattu
		on inserted.mavt = vattu.mavt
		if (@slban > @slcon)
			begin
				raiserror ('Loi cap nhat', 16, 1)
				rollback transaction
			end
		else
			begin
				update vattu
				set slcon = slcon - @slban
				from inserted inner join vattu
				on inserted.mavt = vattu.mavt
			end
	end
go
drop trigger trg_cau6
