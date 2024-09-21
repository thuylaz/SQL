create database de3
go
use de3
go
create table VatTu(
	MaVT		char(10) not null primary key,
	TenVT		nvarchar(30) not null,
	DVTinh		nchar(10),
	SLCon		int
)
go
create table HDBan(
	MaHD		char(10) not null primary key,
	NgayXuat	date,
	HoTenKhach	nvarchar(30) not null
)
go
create table HangXuat(
	MaHD		char(10) foreign key (MaHD) references HDBan(MaHD) on update cascade on delete cascade,
	MaVT		char(10)foreign key (MaVT) references VatTu(MaVT) on update cascade on delete cascade,
	DonGia		float,
	SLBan		int,
	primary key(MaHD, MaVT)
)
go
insert into VatTu values ('VT01', 'Banh keo', 'Cai', 400),
						 ('VT05', 'Hoa qua', 'Qua', 500)
go
insert into HDBan values	('HD01', '2020/06/25', N'Duong Thi Hong Van'),
							('HD03', '2020/06/25', N'Duong Dao Diep')
go
insert into HangXuat values ('HD01', 'VT05', 30000, 200),
							('HD03', 'VT01', 15000, 300),
							('HD03', 'VT05', 20000, 100),
							('HD01', 'VT01', 30000, 600)
go

select * from VatTu
select * from HDBan
select * from HangXuat

--Câu 2: Đưa ra hóa đơn có tổng tiền vật tư nhiều nhất gồm MaHD, Tổng tiền
select top 1 MaHD, sum(DonGia*SLBan) as 'Tong Tien'
from HangXuat
group by MaHD
order by [Tong Tien] desc
--Câu 3: Viết hàm với tham số truyền vào là MaHD, hàm trả về một bảng gồm các thông tin:
--MaHD, NgayXuat, MaVT, DonGia, SLBan, NgayThu.Trong do: Cột NgayThu sẽ là: chủ nhật, t2...
create function fn_cau3(@MaHD char(10))
returns @kq table
			(MaHD char(10),
			NgayXuat date,
			MaVT char(10),
			DonGia float,
			SLBan int,
			NgayThu char(10))
as 
begin 
	insert into @kq
		select HDBan.MaHD, NgayXuat, VatTu.MaVT, HangXuat.DonGia, SLBan, DATENAME(weekday, NgayXuat)
		from VatTu inner join HangXuat on VatTu.MaVT=HangXuat.MaVT
					inner join HDBan on HangXuat.MaHD=HDBan.MaHD
					where HDBan.MaHD=@MaHD
return
end
go 

select * from VatTu
select * from HDBan
select * from HangXuat

--Câu 4: Tạo thủ tục lưu trữ in ra tổng tiền vật tư xuất theo tháng và năm là bao nhiêu(Tham số vào là Tháng và Năm)
create proc cau4(@thang int, @nam int)
as
 begin
	select sum(DonGia*SLBan) as 'TongTien'
	from HangXuat inner join HDBan on HangXuat.MaHD=HDBan.MaHD
	where MONTH(NgayXuat) = @thang and YEAR(NgayXuat) = @nam
	group by NgayXuat
end
go 
--test
exec cau4 6,2020
exec cau4 25,2020