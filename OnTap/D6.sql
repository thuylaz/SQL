create database de6
go 
use de6
go

create table Khoa(
	MaKhoa		char(10) not null primary key,
	TenKhoa		nvarchar(30) not null
)
go

create table Lop(
	MaLop		char(10) not null primary key,
	TenLop		nvarchar(30) not null,	
	SiSo		int,
	MaKhoa		char(10) foreign key (MaKhoa) references Khoa(MaKhoa) on update cascade on delete cascade
)
go

create table SinhVien(
	MaSV		char(10) not null primary key,
	HoTen		nvarchar(30) not null,
	NgaySinh	date,
	GioiTinh	bit,
	MaLop		char(10) foreign key (MaLop) references Lop(MaLop) on update cascade on delete cascade
)
go

insert into Khoa values ('K01', 'CNTT'),
						('K05', 'Dien Tu')
go
insert into Lop values  ('001', 'HTTT01', 83, 'K01'),
						('002', 'DTTT08', 70, 'K05')
go
insert into	SinhVien values ('2020601548', N'Duong Thi Hong Van', '2002/07/24', 0, '001'),
							('2020601549', N'Trinh Pham Nhu Quynh', '2002/05/24', 0, '002'),
							('2020601558', N'Tran Phuong Thao', '2002/01/01', 0, '002'),
							('2020601562', N'Phan Thi Lan Anh', '2002/08/04', 0, '001'),
							('2020601573', N'Mai Thi Anh Tuyet', '2002/07/15', 0, '001'),
							('2020601541', N'Nguyen Van A', '2002/04/19', 1, '002'),
							('2020601698', N'Nguyen Van B', '2002/03/24', 1, '002')
go

select * from Khoa
select * from Lop
select * from SinhVien

--Cau 2:Đưa ra những sinh viên ít tuổi nhất (của một khoa nào đó) gồm: MaSV, HoTen, Tuoi
create view vw_cau2
as
	select SinhVien.MaSV, HoTen, MIN(YEAR(getdate())-YEAR(SinhVien.NgaySinh)) as 'Tuoi'
	from SinhVien
	where YEAR(getdate())-YEAR(SinhVien.NgaySinh)=(select MIN(YEAR(getdate())-YEAR(SinhVien.NgaySinh)) from SinhVien)
	group by SinhVien.MaSV, HoTen
	go

--test 
select * from vw_cau2

--Cau 3: Thủ tục lưu trữ tìm kiếm sinh viên theo khoảng tuổi (Tham số vào: TuTuoi, DenTuoi). Kq đưa ra 1ds : MaSV, HoTen, NgaySinh,
--TenLop, TenKhoa, Tuoi
create proc cau3(@TuTuoi int, @DenTuoi int )
as 
begin
	select SinhVien.MaSV, HoTen, NgaySinh, Lop.TenLop, Khoa.TenKhoa, YEAR(getdate())-year(SinhVien.NgaySinh) as 'Tuoi'
	from Khoa inner join Lop on Khoa.MaKhoa=Lop.MaLop
				inner join SinhVien on Lop.MaLop=SinhVien.MaLop
	where year(GETDATE())-YEAR(SinhVien.NgaySinh) between @TuTuoi and @DenTuoi
end
go
--test
exec cau3 @TuTuoi =20,
			@DenTuoi=30
--Cau 4: Trigger tự động tăng sĩ số sinh viên trong bảng lớp mối khi thêm dữ liệu vào bảng SinhVien. Nếu siso >80 không thêm và cảnh báo
create trigger trg_insertSiSo
on SinhVien
for insert
as
begin
	declare @malop char(10) =(select MaLop from inserted)
	declare @siso  int =(select SiSo from Lop where MaLop=@malop)
	if(@siso>80)
		begin 
			raiserror (N'Si so lop > 80', 16, 1)
			rollback transaction
		end
	else
		begin
			update Lop
			set SiSo=@siso+1
			where MaLop=@malop
		end
end
go 
--test 
insert into SinhVien values ('2020600698', N'Nguyen Van C', '2004/03/20', 1, '002')
select * from Khoa
select * from Lop
select * from SinhVien
