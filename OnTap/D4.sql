create database de4test
go 
use de4test
go

create table BenhVien(
	MaBV		char(10)not null primary key,
	TenBV		nvarchar(30) not null
)
go
create table KhoaKham(
	MaKhoa		char(10) not null primary key,
	TenKhoa		nvarchar(30) not null,
	SoBenhNhan	int,
	MaBV		char(10) foreign key (MaBV) references BenhVien(MaBV) on update cascade on delete cascade
)
go
create table BenhNhan(
	MaBN		char(10) not null primary key,
	HoTen		nvarchar(30) not null,
	NgaySinh	date,
	GioiTinh	bit,
	SoNgayNV	int,
	MaKhoa		char(10) foreign key (MaKhoa) references KhoaKham(MaKhoa) on update cascade on delete cascade
)
go

insert into BenhVien values ('BV01', 'Bach Mai'),
							('BV03', 'Hoai Duc')
go
insert into KhoaKham values ('K02', 'Than kinh', 5, 'BV03'),
							('K05', 'Tim', 3, 'BV01')
go
insert into BenhNhan values ('001', N'Nguyen Van A', '2001/02/01', 1, 30, 'K02'),
							('002', N'Nguyen Van B', '1942/05/05', 1, 60, 'K02'),
							('003', N'Nguyen Van C', '2000/02/01', 1, 10, 'K05'),
							('004', N'Nguyen Van D', '2001/03/01', 1, 50, 'K02'),
							('005', N'Nguyen Van E', '1980/04/15', 1, 30, 'K05'),
							('006', N'Tran Thi F', '2002/02/01', 0, 100, 'K02'),
							('007', N'Nguyen Van G', '1998/02/26', 1, 20, 'K05')
go	
select * from BenhVien
select * from KhoaKham
select * from BenhNhan

--Câu 2: Tạo view đưa ra thống kê số bệnh nhân nữ của từng khoa khám gồm các thông tin: MaKhoa, TenKhoa, SoNguoi
create view vw_cau2
as
	select KhoaKham.MaKhoa, TenKhoa, COUNT(BenhNhan.MaBN) as'BN nữ'
	from   KhoaKham inner join BenhNhan on KhoaKham.MaKhoa=BenhNhan.MaKhoa
	where GioiTinh=0
	group by KhoaKham.MaKhoa, TenKhoa
go
select * from vw_cau2
--Câu 3:Hãy tạo thủ tục lưu trữ in ra tổng số tiền thu được của từng  khoa khám bệnh là bn?
--Với tham số vào là: MaKhoa, Tien=SoNgayNV*80000
create proc cau3 (@MaKhoa char(10), @Tien int output)
as
begin 
	select @Tien= SUM(BenhNhan.SoNgayNV *80000)
	from BenhNhan inner join KhoaKham on BenhNhan.MaKhoa=KhoaKham.MaKhoa
	where BenhNhan.MaKhoa=@MaKhoa
	group by BenhNhan.MaKhoa
	return @Tien
end 
go
--test 
declare @Tien int =0
exec cau3 1, @Tien
select @Tien
go

--Câu 4:Tạo trigger để tự động tăng số bệnh nhân trong bảng KhoaKham, mỗi khi thêm mới dữ liệu cho bảng
--BenhNhan.Nếu số bệnh nhân trong 1 khoa khám >100 thì không cho thêm và đưa ra cảnh báo
create trigger trg_insertCau4
on BenhNhan
for insert
as
begin
	declare @MaKhoa char(10) = (select MaKhoa from inserted)
	declare @SoBN int = (select SoBenhNhan from KhoaKham where MaKhoa=@MaKhoa)
	if(@SoBN >100)
		begin 
			raiserror (N'So benh nhan > 100', 16,1)
			rollback transaction
		end
	else
		begin
			update KhoaKham
			set SoBenhNhan=@SoBN+1
			where MaKhoa= @MaKhoa
		end
end
go
--test
insert into BenhNhan values ('008', N'Tran Thi H', '2002/02/01', 0, 100, 'K02')
select * from KhoaKham
select * from BenhNhan