use master
go
create database de8
use de8
go

--cau1:
create table dv
(madv char(10) not null primary key,
tendv nvarchar(100) not null,
gia float not null
)
drop table dv

create table benhnhan
(mabn char(10) not null primary key,
hoten nvarchar(100) not null,
ngaysinh datetime not null,
gioitinh bit not null
)
drop table benhnhan

create table phieukham
(sophieu int not null identity(1, 1),
madv char(10) not null,
mabn char(10) not null,
ngay datetime not null,
soluong int not null,
constraint pk primary key (sophieu, madv),
constraint fk1 foreign key (madv) references dv(madv) on update cascade on delete cascade,
constraint fk2 foreign key (mabn) references benhnhan(mabn) on update cascade on delete cascade
)
drop table phieukham

--chen du lieu
insert into dv
values	('dv01', 'du lich', 600000),
		('dv02', 'do an', 400000);

insert into benhnhan
values	('bn01', 'Nguyen Van A', '01-02-1995', 0),
		('bn02', 'Nguyen Thi B', '02-03-1996', 1),
		('bn03', 'Nguyen Van C', '03-04-1997', 0),
		('bn04', 'Nguyen Thi D', '04-05-1998', 1),
		('bn05', 'Nguyen Van E', '05-06-1999', 0),
		('bn06', 'Nguyen Thi F', '06-07-1998', 1),
		('bn07', 'Nguyen Van G', '07-08-1997', 0);

insert into phieukham
values	('dv01', 'bn04', '08-09-2020', 26),
		('dv02', 'bn07', '09-10-2020', 45);

select * from dv
select * from benhnhan
select * from phieukham

--cau2: tạo view đưa ra thống kê số bệnnh nhân nữ khám theo từng ngày gồm: ngay, gioitinh, so nguoi
create view cau2
as
	select ngay, gioitinh, count(gioitinh) as 'so benh nhan nu'
	from phieukham inner join benhnhan
	on phieukham.mabn = benhnhan.mabn
	where gioitinh = 1
	group by ngay, gioitinh
go
drop view cau2
--test
select * from cau2 

--cau3: tạo thủ tục lưu trữ in ra tổng số tiền thu được theo từng ngày là bao nhiêu (tham số là ngay, tien=soluong*gia)
create proc cau3 (@ngay datetime)
as
	begin
		select day(ngay) as 'ngay', sum(soluong*gia) as 'tien'
		from phieukham inner join dv
		on phieukham.madv = dv.madv
		where ngay = @ngay
		group by ngay 
	end
go
drop proc cau3 
--test
exec cau3 '08-09-2020'
exec cau3 '09-10-2020'

--cau4: tạo trigger thêm 1 phiếu khám nếu ngày là ngày hiện tại, ngược lại đưa ra thông báo lỗi
create trigger cau4
on phieukham
for insert 
as
	begin
		if ((select ngay from inserted) != getdate())
			begin
				raiserror ('thong bao loi', 16,1)
				rollback transaction
			end
	end
go
drop trigger cau4
--test 
insert into phieukham
values	('dv02', 'bn06', '10-11-2020', 32)
select * from phieukham

---cau5: đưa ra những bệnh nhân có tuổi cao nhất gốm: mabn, hoten, tuoi
select top 1 mabn, hoten, year(getdate()) - year(ngaysinh) as 'tuoi'
from benhnhan
order by tuoi desc

--cau6: viết hàm với tham số truyền vào là mabn, hàm trả về 1 bảng gồm: mabn, hoten, ngaysinh, giotinh (nam, nu)
create function cau6 (@mabn char(10))
returns @bn table 
		(mabn char(10),
		hoten nvarchar(100),
		ngaysinh datetime,
		gioitinh char(5))
as
	begin
		insert into @bn	
			select benhnhan.mabn, hoten, ngaysinh, case gioitinh when 0 then 'nam' when 1 then 'nu' end as 'gioi tinh'
			from benhnhan
			where benhnhan.mabn = @mabn
		return 
	end
go
drop function cau6
--test
select * from cau6 ('bn01')
select * from cau6 ('bn02')
select * from cau6 ('bn03')
select * from cau6 ('bn04')
select * from cau6 ('bn05')
select * from cau6 ('bn06')
select * from cau6 ('bn07')

--cau7: tạo trigger thêm 1 bệnh nhân. kiểm tra ngaysinh <= ngày hiện tại, ngược lại đưa ra cảnh báo
create trigger cau7
on benhnhan
for insert 
as
	begin
		if ((select ngay from inserted) <= getdate())
			begin
				raiserror ('loi chen', 16, 1)
				rollback transaction
			end
	end
go
--test
insert into benhnhan
values	('bn08', 'Nguyen Thi H', '10-02-1998', 1)
select * from benhnhan