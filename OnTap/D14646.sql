
create database De14646
go
use De14646
go

create table CongTy(
	MaCT		char(10) not null primary key,
	TenCT		char(30) not null,
	TrangThai	nvarchar(50),
	ThanhPho	nvarchar(30)
)
go
create table SanPham(
	MaSP		char(10) not null primary key,
	TenSP		nvarchar(30) not null,
	MauSac		char(10),
	SoLuong		int,
	GiaBan		money
)
go
create table CungUng(
	MaCT		char(10) foreign key (MaCT)	references CongTy(MaCT) on update cascade on delete cascade,
	MaSP		char(10) foreign key (MaSP)	references SanPham(MaSP) on update cascade on delete cascade,
	SoLuongCU	int,
	primary key(MaCT, MaSP)
)
go

insert into CongTy values	('001', 'Viettel', 'Trang thai 1', 'Ha Noi'),
							('002', 'FPT', 'Trang thai 2', 'Ho Chi Minh'),
							('003', 'VNP', 'Trang thai 1', 'Ha Noi')
go

insert into SanPham values  ('SP01', 'San pham 1', 'Mau a', 200, 500000),
							('SP02', 'San pham 2', 'Mau b', 500, 300000),
							('SP03', 'San pham 3', 'Mau c', 1000, 100000)
go

insert into CungUng values  ('001', 'SP01', 50 ),
							('001', 'SP02', 40 ),
							('002', 'SP01', 10 ),
							('002', 'SP02', 100 ),
							('003', 'SP03', 90 )
go

select * from CongTy
select * from SanPham
select * from CungUng

--Cau 2: Tạo Hàm đưa ra TenSP, MauSac, SoLuong, GiaBan của công ty với tên công ty nhập từ bp
create function fn_cau2(@TenCT nvarchar(30))
returns @kq table (TenSP nvarchar(30), MauSac char(10), SoLuong int, GiaBan money)
as
begin
	insert into @kq
	select TenSP, MauSac, SoLuong, GiaBan
	from SanPham inner join CungUng on SanPham.MaSP = CungUng.MaSP
				inner join CongTy on CungUng.MaCT=CongTy.MaCT
	where TenCT=@TenCT
return
end
go
--test
select * from fn_cau2('Viettel')

--Cau 3: Thủ tục thêm mới 1 Cung ứng với MaCT, TenSP, SoLuongCU, nhập từ bàn phím, nếu tên SP
--không tồn tại đưa ra thông  báo
alter proc cau3(@MaCT char(10), @TenSP nvarchar(30), @SoLuongCU int)
as
begin 
	declare @MaSP char(10)
	select @MaSP=MaSP from SanPham where TenSP=@TenSP
	if(not exists(select * from SanPham where @TenSP=TenSP))
		print 'Khong ton tai ten sp'
	else
	begin
		insert into CungUng values (@MaCT, @TenSP,@SoLuongCU)
	end
end
--test
exec cau3 '001', 'San pham 4', 10
--TH đúng
exec cau3 '003', 'San pham 1', 10

--Cau 4: Trigger update trên bản CungUng cập nhập lại SoLuongCU, ktra xem nếu SLCU mới-SLCU cũ<=SoLuong
--hay không? Nếu tm hãy cập nhật lại SoLuong trên bảng SanPham, ngược lại đưa ra tb
create trigger trg_updateCU
on CungUng
for update
as
begin
	declare @MaSP char(10), @SoLuongCUT int, @SoLuongCUS int, @SoLuong int
	select @MaSP=MaSP, @SoLuongCUT=SoLuongCU from deleted
	select @SoLuongCUS= SoLuongCU from inserted
	select SoLuong=@SoLuong from SanPham where MaSP=@MaSP
	if(@SoLuong<(@SoLuongCUS-@SoLuongCUT))
		begin 
			raiserror ('Khong thoa man', 16, 1)
			rollback transaction
		end
	else 
			update SanPham set SoLuong=SoLuong-(@SoLuongCUS-@SoLuongCUT)
			from SanPham
			where MaSP=@MaSP
end
--test
--Sai
select * from SanPham
select * from CungUng
update CungUng set SoLuongCU=250 where MaSP='SP01' and MaCT='001'
--Đúng
select * from SanPham
select * from CungUng
update CungUng set SoLuongCU=5 where MaSP='SP01' and MaCT='001'
select * from SanPham
select * from CungUng
