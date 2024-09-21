use master
go
create database de2
go
use de2
go

create table Hang(
	MaHang		char(10) not null primary key,
	TenHang		nvarchar(30) not null,
	DVTinh		char(10) not null,
	SLTon		int
)
go
create table HDBan(
	MaHD		char(10) not null primary key,
	NgayBan		date not null,
	HoTenKhach  nvarchar(30) not null
)
go
create table HangBan(
	MaHD		char(10) foreign key (MaHD) references HDBan(MaHD) on update cascade on delete cascade,
	MaHang		char(10) foreign key (MaHang) references Hang(MaHang) on update cascade on delete cascade,
	DonGia		float not null,
	SoLuong		int check(SoLuong >=0),
	primary key(MaHD, MaHang)
)
go

insert into Hang values ('001', 'Banh keo', 'Cai', 5000),
						('005', 'Hoa qua', 'Qua', 3000)
go

insert into HDBan values ('HD01', '2020/06/24', N'Duong Thi Hong Van'),
						 ('HD03', '2020/06/25', N'Duong Dao Diep')
go

insert into HangBan values  ('HD01', '005', 50000, 10),
							('HD03', '001', 30000, 5),
							('HD03', '005', 50000, 7),
							('HD01', '001', 30000, 3)
go

select * from Hang
select * from HDBan
select * from HangBan

--Cau 2: Tạo view đưa ra thống kê tiền hàng bán theo từng hóa đơn gồm: MaHD, NgayBan, TongTien(Tiền=SoLuong * DonGia)
create view vw_cau2
as
	select HDBan.MaHD, NgayBan, Sum(DonGia*SoLuong) as 'Tong Tien'
	from HDBan inner join HangBan
	on HDBan.MaHD=HangBan.MaHD
	group by HDBan.MaHD, NgayBan
--test
select * from vw_cau2

--Cau 3: Tạo thủ tục lưu trữ tìm kiếm hàng theo tháng và năm. Kết quả tìm được đưu ra 1ds gồm: MaHang,
--TenHang, NgayBan, SoLuong, NgayThu
create proc cau3 (@thang int, @nam int )
as
begin
	select Hang.MaHang, TenHang, NgayBan, SoLuong, DATENAME(weekday, NgayBan) as 'NgayThu'
	from HangBan inner join HDBan on HangBan.MaHD=HDBan.MaHD
					inner join Hang on HangBan.MaHang=Hang.MaHang
	where @thang = MONTH(NgayBan) and @nam = YEAR(NgayBan)
end
go
--test

exec cau3 12,2020
select * from Hang
select * from HDBan
select * from HangBan

--Cau 4: Tạo trigger tự động giảm số lượng tồn(SLTon) trong bảng Hang, mỗi khi thêm mới dữ liệu cho bảng HangBan
--Đưa ra tb lỗi nếu SoLuong > SLTon

create trigger trg_insertSoLuong
on HangBan
for insert
as
begin	
	declare @sl int
	set @sl = (select SoLuong from inserted)
	declare @MaHang char(10)
	set @MaHang = (select MaHang from inserted)
	if( @sl > (select SLTon from Hang where MaHang=@MaHang))
		begin
			raiserror(N'So luong ban khong duoc phap lon hon so luong ton', 16, 1)
			rollback transaction
		end
	else
		begin
			update Hang
			set SLTon=SLTon-1
			where MaHang=@MaHang
		end
end
go
--test
insert into HDBan values ('HD02', '2020/06/23', N'Dao Thi Huyen')
--sl<slton
insert into HangBan values ('HD01', '005', 50000, 10)
--sl>slton
insert into HangBan values ('HD01', '005', 50000, 7000)

select * from Hang
select * from HDBan
select * from HangBan