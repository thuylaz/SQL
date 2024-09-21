create database QLTruongHoc
go
use QLTruongHoc
go
create table GiaoVien
(
	MaGV char(10) primary key,
	TenGV nvarchar(30) not null
)
go
create table Lop
(
	MaLop char(10) primary key,
	TenLop nvarchar(20) ,
	Phong int,
	SiSo int,
	MaGV char(10) foreign key(MaGV) references GiaoVien(MaGV) on update cascade on delete cascade
)
go
create table SinhVien
(
	MaSV char(10) primary key,
	TenSV nvarchar(30),
	GioiTinh nvarchar(5),
	QueQuan nvarchar(30),
	MaLop char(10) foreign key(MaLop) references Lop(MaLop) on update cascade on delete cascade
)
go
insert into GiaoVien values ('GV01','Nguyen Van A')
insert into GiaoVien values ('GV02','Nguyen Van B')
insert into GiaoVien values ('GV03','Nguyen Thi C')
go
insert into Lop values ('L01','Lop 1',101,40,'GV01')
insert into Lop values ('L02','Lop 2',111,40,'GV03')
insert into Lop values ('L03','Lop 3',141,50,'GV02')
go
insert into SinhVien values('SV01','Hoang Van A','Nam','Ha Noi','L01')
insert into SinhVien values('SV02','Hoang Van B','Nam','Ha Noi','L02')
insert into SinhVien values('SV03','Hoang Thi A','Nu','Ha Noi','L02')
insert into SinhVien values('SV04','Hoang Van C','Nam','Ha Noi','L03')
insert into SinhVien values('SV05','Hoang Thi D','Nu','Ha Noi','L01')
go
select*from GiaoVien
select*from Lop
select*from SinhVien
-----cau 2
create function cau2(@TenLop nvarchar(20),@TenGV nvarchar(30))
returns @bang table(MaSV char(10),TenSV nvarchar(30),GioiTinh nvarchar(5),QueQuan nvarchar(30) ,MaLop char(10))
as
begin
	insert into @bang
	select MaSV,TenSV,GioiTinh,QueQuan,SinhVien.MaLop
	from GiaoVien inner join Lop on Lop.MaGV=GiaoVien.MaGV 
	inner join SinhVien on SinhVien.MaLop=Lop.MaLop
	where TenLop=@TenLop and TenGV=@TenGV
	return 
end
-----goi ham
select *from cau2 ('Lop 2','Nguyen Thi C')
---cau 3
alter proc cau3(@MaSV char(10),@TenSV nvarchar(30),@GioiTinh nvarchar(5),@QueQuan nvarchar(30),@TenLop nvarchar(20))
as
begin
	if(not exists (select *from Lop where TenLop=@TenLop))
	print 'Ten lop k ton tai'
	else
	begin
		declare @MaLop  char(10)
		select @MaLop=MaLop from Lop where TenLop=@TenLop
		insert into SinhVien values(@MaSV,@TenSV,@GioiTinh,@QueQuan,@MaLop)
end
end
-----goi thu tuc
---TH1: ten lop k ton tai
exec cau3 'SV08','Hoang Thi E','Nu','ha Noi','Lop 5'
---TH2: ten lop ton tai
exec cau3 'SV09','Hoang Thi E','Nu','ha Noi','Lop 1'
select*from SinhVien
---cau4
alter trigger cau4
on SinhVien
for update
as
begin
	declare @sisotruoc int
	declare @sisosau int
	--declare @siso int
	declare @MaLop char(10)
	select @sisotruoc=SiSo,@MaLop=Lop.MaLop from deleted  inner join Lop on Lop.MaLop=deleted.MaLop
	select @sisosau=SiSo from inserted inner join Lop on Lop.MaLop=inserted.MaLop
	--select @SiSo=SiSo from Lop where MaLop=@MaLop
	if(update(MaLop))
	update Lop set SiSo=SiSo-(@sisosau-@sisotruoc)
	from Lop
	where MaLop=@MaLop
end
----goi trigger
select *from Lop
select*from SinhVien
update SinhVien set MaLop='L03' where MaSV='SV01'