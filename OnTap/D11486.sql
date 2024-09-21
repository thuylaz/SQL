create database D11486
go
use D11486
go

create table CongTys(
	MaCT		char(10) not null primary key, 
	TenCT		nvarchar(30) not null,
	DiaChi		nvarchar(30)
)
go
create table SanPhams(
	MaSP		char(10) not null primary key,
	TenSP		nvarchar(30) not null,
	SLCo		int,
	GiaBan		money
)
go
create table CungUngs(
	MaCT		char(10) foreign key (MaCT) references CongTys(MaCT) on update cascade on delete cascade,
	MaSP		char(10) foreign key (MaSP) references SanPhams(MaSP) on update cascade on delete cascade,
	SLCungUng	int,
	NgayCungUng  date,
	primary key(MaCT, MaSP)
)
go

insert into CongTys values   ('CT01', 'Cong Ty 1', 'Ha Noi'),
							('CT02', 'Cong Ty 2', 'Ho Chi Minh'),
							('CT03', 'Cong Ty 3', 'Ha Noi')
go

insert into SanPhams values  ('001', 'San pham 1', 100, 50000),
							('002', 'San pham 2', 500, 60000),
							('003', 'San pham 3', 200, 30000)
go
insert into CungUngs values  ('CT01', '001', 50, '2022/06/27'),
							('CT01', '002', 90, '2022/06/27'),
							('CT01', '003', 60, '2022/06/27'),
							('CT02', '001', 50, '2022/06/27'),
							('CT03', '001', 10, '2022/06/27')
go
select * from CongTys
select * from SanPhams
select * from CungUngs

--Cau 2: Tạo hàm đưa ra các TenSP, MauSac, SoLuong, GiaBan của công ty với tên công ty và ngaycungung nhâp từ bàn phím
create function fn_cau2(@TenCT nvarchar, @NgayCungUng date)
returns @kq table 
			( TenSP nvarchar(30),
			  SLCo int,
			  GiaBan money
			)
as 
begin 
		insert into @kq 
		select TenSP, SLCo, GiaBan
		from SanPhams inner join CungUngs on SanPhams.MaSP=CungUngs.MaSP
					inner join CongTys on CungUngs.MaCT=CongTys.MaCT
		where TenCT=@TenCT and NgayCungUng=@NgayCungUng
		return
end
--test 
select * from fn_cau2('Cong ty 2', '2022/06/27')

--Cau 3: Thủ tục thêm mới 1 công ty với mã công ty, tên công ty, địa chỉ nhập từ bàn phím, nếu tên công ty tồn tại trước đó
--hãy hiển thị tb trả về 1, ngược lại cho phét thêm mới và trả về 0
create 
--Cau 4: Trigger Updaete trên bảng CungUngs cập nhập lại số lượng cung ứng, kiểm tra xem nếu số lượng cưng ứng mới - sl cung ứng cũ
--<= Số lượng có hay không? Nếu thỏa mãn hãy cập nhật lại số lượng có trêm bảng SanPham, ngược lại đưa ra tb

