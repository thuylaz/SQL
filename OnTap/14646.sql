create database QLBanHan
go
use QLBanHan
go
create table CONGTY 
(
	MaCT char(10) primary key,
	TenCT nvarchar(30),
	TrangThai nvarchar(20),
	ThanhPho nvarchar(20)
)
go
create table SANPHAM 
(
	MaSP char(10) primary key,
	TenSP nvarchar(30),
	MauSac nvarchar(10),
	SoLuong int,
	GiaBan float
)
go
create table CUNGUNG
(
	MaCT char(10) foreign key (MaCT) references CONGTY(MaCT) on update cascade on delete cascade,
	MaSP char(10) foreign key (MaSP) references SANPHAM(MaSP) on update cascade on delete cascade,
	primary key(MaCT,MaSP),
	SoLuongCungUng int
)
go
insert into CONGTY values('CT01','Cong ty 1','Trang thai 1','Thanh pho 1')
insert into CONGTY values('CT02','Cong ty 2','Trang thai 2','Thanh pho 2')
insert into CONGTY values('CT03','Cong ty 3','Trang thai 1','Thanh pho 3')
go
insert into SANPHAM values('SP01','San pham 1','Mau 1',200,2000)
insert into SANPHAM values('SP02','San pham 2','Mau 2',100,3000)
insert into SANPHAM values('SP03','San pham 3','Mau 3',200,4000)
go
insert into CUNGUNG values ('CT01','SP01',20)
insert into CUNGUNG values ('CT01','SP02',10)
insert into CUNGUNG values ('CT02','SP02',50)
insert into CUNGUNG values ('CT03','SP01',20)
insert into CUNGUNG values ('CT01','SP03',20)
go
select *from CONGTY
select*from SANPHAM
select*from CUNGUNG
----cau 2
create function cau2(@TenCT nvarchar(30))
returns @bang table(TenSP nvarchar(30),MauSac nvarchar(10),SoLuong int,Giaban float)
as
begin
	insert into @bang
	select TenSP,MauSac,SoLuong,GiaBan
	from SANPHAM inner join CUNGUNG on CUNGUNG.MaSP=SANPHAM.MaSP
	inner join CONGTY on CONGTY.MaCT=CUNGUNG.MaCT
	where TenCT=@TenCT
	return
end
---goi ham
select*from cau2('Cong ty 1')
---cau 3
alter proc cau3(@MaCT char(10),@TenSP char(10),@SoLuongCungUng int)
as
begin
	declare @MaSP char(10)
	select @MaSP=MaSP from SANPHAM where TenSP=@TenSP
	if(not exists(select*from SANPHAM where TenSP=@TenSP))
		print 'K ton tai ten san pham'
	else
	begin
		insert into CUNGUNG values(@MaCT,@MaSP,@SoLuongCungUng)
		end
end
----goi thu tuc
--TH k dung
exec cau3 'CT01','San pham 6',10
---Th dung
exec cau3 'CT03','San pham 2',10
----cau4
create trigger cau4
on CUNGUNG
for update 
as
begin
	declare @MaSP char(10),@soluongcungungtruoc int,@soluongcungungsau int,@SoLuong int
	select @MaSP=MaSP,@soluongcungungtruoc =SoLuongCungUng from deleted 
	select @soluongcungungsau=SoLuongCungUng from inserted
	select @SoLuong=SoLuong from SANPHAM where MaSP=@MaSP
	if(@SoLuong<(@soluongcungungsau-@soluongcungungtruoc))
		begin
			raiserror ('k hop le',16,1)
			rollback transaction
		end
	else
		update SANPHAM set SoLuong=SoLuong-(@soluongcungungsau-@soluongcungungtruoc)
		from SANPHAM
		where MaSP=@MaSP
end
-----goi trigger
----th sai
select*from SANPHAM
select*from CUNGUNG
update CUNGUNG set SoLuongCungUng=500 where MaSP='SP01' and MaCT='CT01'
--th dung
select*from SANPHAM
select*from CUNGUNG
update CUNGUNG set SoLuongCungUng=5 where MaSP='SP01' and MaCT='CT01'
select*from SANPHAM
select*from CUNGUNG
