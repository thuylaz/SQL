create database QLBanHang11486
go
use QLBanHang11486
go
create table CongTy(
	mact nchar(10) not null primary key,
	tenct nvarchar(30),
	diachi nvarchar(50)
)
create table SanPham(
	masp nchar(10) not null primary key,
	tensp nvarchar(30),
	slco int,
	giaban money
)
create table CungUng(
	mact nchar(10),
	masp nchar(10),
	constraint pk_cungung primary key (mact,masp),
	slcungung int,
	ngaycungung datetime,
	constraint fk_cu_ct foreign key (mact)
	references congty(mact),
	constraint fk_cu_sp foreign key (masp)
	references sanpham(masp)
)

insert into CongTy values	('CT01',N'Công ty A',N'Hà Nội'),
							('CT02',N'Công ty B',N'Hà Nam'),
							('CT03',N'Công ty C',N'Bắc Ninh')
insert into SanPham values	('SP01',N'Bánh Oreo',50,20000),
							('SP02',N'Kẹo chíp chíp',50,15000),
							('SP03',N'Kem cá',20,25000)
insert into CungUng values	('CT01','SP01',40,'2022/05/05'),
							('CT02','SP02',100,'2022/04/25'),
							('CT03','SP03',50,'2022/12/06'),
							('CT01','SP03',20,'2022/08/05'),
							('CT02','SP01',30,'2022/05/01')
select * from SanPham
select * from CongTy
select * from CungUng

--Câu 2
create function fn_cau2(@tenct nvarchar(30), @ngaycungung datetime)
returns @bang table		(
							tensp nvarchar(30),
							soluongco int,
							giaban money
						)
as
begin
	insert into @bang
	select tensp, slco, giaban from SanPham
	inner join CungUng on SanPham.masp=CungUng.masp
	inner join CongTy on CungUng.mact= CongTy.mact
	where tenct = @tenct and ngaycungung = @ngaycungung
	return
end
--test
select * from fn_cau2 (N'Công ty A','2022/05/05')

--Câu 3
create proc sp_cau3(@mact nchar(10), @tenct nvarchar(30), @diachi nvarchar(50), @bien int output)
as
begin
	if(exists(select tenct from CongTy where tenct=@tenct))
		begin
			print(N'Tên công ty đã tồn tại')
			set @bien =1
		end
	else
		begin
			set @bien = 0
			insert into CongTy values	(@mact, @tenct, @diachi)
		end
	return @bien
end

--test 
--Trường hợp sai
declare @bien int
exec sp_cau3 'CT04',N'Công ty A',N'Hà Nội', @bien output
select @bien
select * from CongTy

--Trường hợp đúng
declare @bien int
exec sp_cau3 'CT04',N'Công ty D',N'Hà Tĩnh', @bien output
select @bien
select * from CongTy

--Câu 4
create trigger tg_cau4
on CungUng
for update
as
begin
	declare @masp nchar(10)
	declare @sl int
	declare @cu int
	declare @moi int
	set @masp = (select masp from inserted )
	set @sl = (select slco from SanPham where masp = @masp)
	select @cu = slcungung from deleted
	select @moi = slcungung from inserted
	if(@moi- @cu <= @sl)
		begin
			update SanPham set slco= slco-(@moi - @cu)
			where masp = @masp
		end
	else
		begin
			raiserror (N'Không đủ hàng bán',16,1)
			rollback transaction
		end
end
--test
--Trường hợp đúng
UPDATE [dbo].[CungUng]
   SET [slcungung] = 10
 WHERE mact = 'CT01'and masp = 'SP01'
select * from SanPham
select * from CungUng

--Trường hợp sai
UPDATE [dbo].[CungUng]
   SET [slcungung] = 1000
 WHERE mact = 'CT01'and masp = 'SP01'

