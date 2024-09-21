create database QLSV
go
use QLSV
go
create table Khoa 
(
	MaKhoa char(10) primary key,
	TenKhoa nvarchar(30),
	DiaChi nvarchar(50),
	SoDT varchar(12),
	Email nvarchar(30)
)
go
create table Lop
(
	MaLop char(10) primary key,
	TenLop nvarchar(30),
	SiSo int,
	MaKhoa char(10) foreign key (MaKhoa) references Khoa(MaKhoa) on update cascade on delete cascade
)
go
create table SinhVien
(
	MaSV char(10) primary key,
	HoTen nvarchar(30),
	NgaySinh date,
	GioiTinh nvarchar(10),
	MaLop char(10) foreign key (MaLop) references Lop(MaLop) on update cascade on delete cascade
)
go
insert into Khoa values ('K01','Khoa 1','Dia chi 1','12345678','abc1@gmail.com')
insert into Khoa values ('K02','Khoa 2','Dia chi 2','14345678','abc2@gmail.com')
insert into Khoa values ('K03','Khoa 3','Dia chi 3','12545678','abc3@gmail.com')
go
insert into Lop values ('L01','Lop 1',40,'K01')
insert into Lop values ('L02','Lop 2',50,'K02')
insert into Lop values ('L03','Lop 3',80,'K03')
go
insert into SinhVien values ('SV01','Nguyen Van A','2001/02/01','Nam','L01')
insert into SinhVien values ('SV02','Nguyen Van B','2001/02/01','Nam','L03')
insert into SinhVien values ('SV03','Nguyen Van C','2001/02/01','Nam','L02')
insert into SinhVien values ('SV04','Nguyen Thi A','2001/02/01','Nu','L01')
insert into SinhVien values ('SV05','Nguyen Thi B','2001/02/01','Nu','L02')
go
select*from Khoa
select*from Lop
select *from SinhVien
----cau 2
alter function cau2(@TenKhoa nvarchar(30))
returns @bang table(MaSV char(10),HoTen nvarchar(30),Tuoi int)
as
begin
	insert into @bang
	select MaSV,HoTen,year(getdate())-year(NgaySinh)
	from SinhVien inner join Lop on Lop.MaLop=SinhVien.MaLop
	inner join Khoa on Khoa.MaKhoa=Lop.MaKhoa
	 where TenKhoa=@TenKhoa
	return
end
---goi ham
select*from cau2('Khoa 1')
-----cau 3
create proc cau3(@TuTuoi int,@DenTuoi int,@TenLop nvarchar(30))
as
begin
	select MaSV,HoTen,NgaySinh,TenLop,TenKhoa,year(getdate())-year(NgaySinh) as'Tuoi'
	from SinhVien inner join Lop on Lop.MaLop=SinhVien.MaLop
	inner join Khoa on Khoa.MaKhoa=Lop.MaKhoa
	where year(getdate())-year(NgaySinh) between @TuTuoi and @DenTuoi 
	and TenLop=@TenLop
end
--goi thu tuc
exec cau3 10,30,'Lop 1'
-----cau 4
alter trigger cau4
on SinhVien 
for insert
as
begin
	declare @MaLop char(10),@MaSV char(10),@SiSo int
	select @MaLop=MaLop,@MaSV=MaSV from inserted
	select @SiSo=SiSo from Lop where MaLop=@MaLop
	if(@SiSo>80)
		begin
			raiserror ('Canh bao',16,1)
			rollback transaction
		end
	else
	begin
		update Lop set SiSo=SiSo+1
		from Lop where MaLop=@MaLop
	end
end
----goi trigger
----th canh bao
select *from Lop
select*from SinhVien
alter table SinhVien nocheck constraint PK__SinhVien__2725081AE7317A6F
insert into SinhVien values ('SV07','Nguyen Van M','2000/12/12','Nam','L03')
----th dung
select *from Lop
select*from SinhVien
insert into SinhVien values ('SV08','Nguyen Van M','2000/12/12','Nam','L02')
select *from Lop
select*from SinhVien