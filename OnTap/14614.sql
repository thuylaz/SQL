create database QLNhapXuat
go
use QLNhapXuat
go
create table SanPham 
(
	MaSP char(10) primary key,
	TenSP nvarchar(30) ,
	MauSac char(10),
	SoLuong int,
	GiaBan float
)
go
create table Nhap
(
	SoHDN char(10) primary key,
	MaSP char(10) foreign key (MaSP) references SanPham(MaSP) on update cascade on delete cascade,
	SoLuongN int,
	NgayN date
)
go
create table Xuat
(
	SoHDX char(10) primary key,
	MaSP char(10) foreign key (MaSP) references SanPham(MaSP) on update cascade on delete cascade,
	SoLuongX int,
	NgayX date
)
go
insert into SanPham values ('SP01','San pham 1','Mau 1',200,10000)
insert into SanPham values ('SP02','San pham 2','Mau 2',300,20000)
insert into SanPham values ('SP03','San pham 3','Mau 3',400,1000)
go
insert into Nhap values ('N01','SP01',20,'2019/6/12')
insert into Nhap values ('N02','SP02',30,'2019/6/12')
insert into Nhap values ('N03','SP03',40,'2019/6/12')
go
insert into Xuat values ('X01','SP01',10,'2020/2/23')
insert into Xuat values ('X02','SP03',20,'2020/2/23')
go
select*from SanPham 
select*from Nhap
select*from Xuat
---cau 2
create function cau2(@TenSP nvarchar(30))
returns float
as
begin
	declare @tongtien float
	select @tongtien=sum(soLuongN*GiaBan) from Nhap inner join SanPham on SanPham.MaSp=Nhap.MaSP where TenSP=@TenSP
	return @tongtien
end
---goi ham
select *from Nhap
select*from SanPham
select dbo.cau2 ('San pham 1') as 'Tong tien'
---cau 3
alter proc cau3(@MaSP char(10), @TenSP nvarchar(30),@MauSac nvarchar(10),@SoLuong int,@GiaBan float,@kq int output)
as
begin
	if(exists(select*from SanPham where MaSp=@MaSP))
		set @kq=1
	else
		begin
			set @kq=0
			insert into SanPham values(@MaSP,@TenSP,@MauSac,@SoLuong,@GiaBan)
		end
	return
end
----goi thu tuc
---th co ma san pham roi
select*from SanPham
declare @ketqua int 
exec cau3 'SP01','San pham 1','Mau 1',10,1000,@ketqua output
select @ketqua
----Th dung
select*from SanPham
declare @ketqua int 
exec cau3 'SP04','San pham 4','Mau 1',10,1000,@ketqua output
select @ketqua
select*from SanPham
---cau 4
create trigger cau4
on Xuat
for insert
as
begin
	declare @SoLuongX int,@MaSP char(10),@SoLuong int
	select @SoLuongX=SoLuongX,@MaSP=MaSP from inserted
	select @SoLuong=SoLuong from SanPham where MaSp=@MaSP
	if(@SoLuongX>@SoLuong)
		begin
			raiserror ('K hop le',16,1)
			rollback transaction
		end
	else
		update SanPham set SoLuong=SoLuong-@SoLuongX
		from SanPham where MaSP=@MaSP
end
----goi trigger
--th sai
select*from SanPham 
select*from Xuat
insert into Xuat values ('X03','SP01',300,'2020/12/12')
select*from SanPham 
select*from Xuat
---Th dung
select*from SanPham 
select*from Xuat
insert into Xuat values ('X03','SP01',20,'2020/12/12')
select*from SanPham 
select*from Xuat

