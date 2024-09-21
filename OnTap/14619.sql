create database QLThuoc
go
use QLThuoc
go
create table Thuoc 
(
	MaThuoc char(10) primary key,
	TenThuoc nvarchar(30),
	SoLuong int,
	DonGia float,
	NhaSX nvarchar(30)
)
go
create table BenhNhan
(
	MaBN char(10) primary key,
	TenBN nvarchar(30),
	GioiTinh nvarchar(10)
)
go
create table DonThuoc
(
	MaDon char(10),
	MaThuoc char(10) foreign key (MaThuoc) references Thuoc(MaThuoc) on update cascade on delete cascade,
	primary key(MaDon,MaThuoc),
	SoLuongBan int,
	NgayBan date,
	MaBN char(10) foreign key (MaBN) references BenhNhan(MaBN) on update cascade on delete cascade
)
go
insert into Thuoc values('T01','Thuoc 1',100,2000,'NSX 1')
insert into Thuoc values('T02','Thuoc 2',200,2000,'NSX 2')
insert into Thuoc values('T03','Thuoc 3',100,2000,'NSX 3')
go
insert into BenhNhan values('BN01','Nguyen Van A','Nam')
insert into BenhNhan values('BN02','Nguyen Van B','Nam')
insert into BenhNhan values('BN03','Nguyen Van C','Nam')
go
insert into DonThuoc values('D01','T01',50,'2019/12/12','BN01')
insert into DonThuoc values('D02','T02',20,'2019/12/12','BN02')
insert into DonThuoc values('D03','T02',10,'2019/12/12','BN03')
insert into DonThuoc values('D04','T03',50,'2019/12/12','BN01')
insert into DonThuoc values('D05','T01',30,'2019/12/12','BN02')
go
select *from Thuoc
select*from BenhNhan
select*from DonThuoc
---cau 2
create function cau2(@NgayBan date)
returns @bang table (MaBN char(10),TenBN nvarchar(30),GioiTinh nvarchar(10),MaThuoc char(10),TenThuoc nvarchar(10),SoLuong int,DonGia float)
as
begin
	insert into @bang
	select BenhNhan.MaBN,TenBN,GioiTinh,Thuoc.MaThuoc,TenThuoc,SoLuong,DonGia
	from BenhNhan inner join DonThuoc on DonThuoc.MaBN=BenhNhan.MaBN
	inner join Thuoc on Thuoc.MaThuoc =DonThuoc.MaThuoc
	where NgayBan=@NgayBan
	return 
end
---goi ham
select*from cau2('2019/12/12')
---cau 3
alter proc cau3(@MaDon char(10),@TenThuoc nvarchar(30),@SoLuongBan int,@NgayBan date,@MaBN char(10))
as
begin
	declare @MaThuoc char(10)
	select @MaThuoc=MaThuoc from Thuoc where TenThuoc=@TenThuoc
	if(not exists(select*from Thuoc where TenThuoc=@TenThuoc))
		print 'Ten thuoc k ton tai'
	else
		begin
			insert into DonThuoc values(@MaDon,@MaThuoc,@SoLuongBan,@NgayBan,@MaBN)
		end
end
---goi thu tuc
---th k ton tai don thuoc
exec cau3 'D06','Thuoc 6',10,'2020/12/24','BN01'
--th dung
exec cau3 'D06','Thuoc 1',10,'2020/12/24','BN01'
select*from DonThuoc 
---cau 4
alter trigger cau4
on DonThuoc 
for insert
as
begin
	declare @MaThuoc char(10),@SoLuongBan int,@SoLuong int
	select @SoLuongBan =SoLuongBan from inserted
	select @MaThuoc=MaThuoc from Thuoc
	select @SoLuong=SoLuong from Thuoc where MaThuoc=@MaThuoc
	if(@SoLuongBan>@SoLUong)
		begin
			raiserror ('K hop le',16,1)
			rollback transaction
		end
	else
		update Thuoc set SoLuong=SoLuong-@SoLuongBan
		from Thuoc where MaThuoc=MaThuoc
end
---goi trigger
---TH k dung
select*from Thuoc
select*from DonThuoc
insert into DonThuoc values ('D07','T02',500,'2020/1/12','BN02')
select*from Thuoc 
select *from DonThuoc
---Th dung
select*from Thuoc
select*from DonThuoc
insert into DonThuoc values ('D07','T02',10,'2020/1/12','BN02')
select*from Thuoc 
select *from DonThuoc
