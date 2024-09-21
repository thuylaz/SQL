use master
go 
if(exists(select * from sysdatabases where name='QLSinhVien'))
drop database QLSinhVien
go

create database QLSinhVien
go
use QLSinhVien
go

create table Khoa(
	MaKhoa		char(10) primary key,
	TenKhoa		nvarchar(30) not null
)
go
create table Lop(
	MaLop		char(10) primary key,
	TenLop		nvarchar(30) not null,
	SiSo		int,
	MaKhoa		char(10) foreign key (MaKhoa) references Khoa(MaKhoa) on update cascade on delete cascade
)
go
create table SinhVien(
	MaSV		char(10) primary key,
	HoTen		nvarchar(30) not null,
	NgaySinh	date,
	GioiTinh	bit,
	MaLop		char(10) foreign key (MaLop) references Lop(MaLop) on update cascade on delete cascade
)
go
insert into Khoa values	('K01', N'Công nghệ thông tin'),
						('K02', N'Điện tử')
go
insert into Lop values	('001', 'HTT01', 83, 'K01'),
						('002', 'DTTT08', 76, 'K02')
go
insert into SinhVien values ('2020601548', N'Duong Thi Hong Van', '2002/07/24' , 0, '001' ),
							('2020123456', N'Phan Thi Lan Anh', '2002/08/4', 0, '001' ),
							('2020789456', N'Mai Thị Anh Tuyet', '2002/01/05', 0, '001' ),
							('2020159753', N'Nguyen Thi Thu Trang', '2002/09/08', 0, '001' ),
							('2020471236', N'Tran Phuong Thao', '2002/07/24', 0, '002' ),
							('2020452193', N'Trinh Pham Nhu Quynh', '2002/07/24', 0, '002' ),
							('2020700023', N'Nguyen Van Hai', '2002/07/24', 1, '001' )
go

select * from Khoa
select * from Lop
select * from SinhVien
go 

--Cau 2: Tạo view đưa ra thống kê số lớp của từng khoa gồm TenKhoa, SoLop
create view vw_cau2
as
	select TenKhoa, count(MaKhoa) as 'solop'
	from Khoa
	group by TenKhoa
go
drop view vw_cau2
--test 
select * from vw_cau2

--Cau 3: Viết hàm với tham số truyền vào là MaKhoa, trả về 1 bảng gồm các thông tin...
create function fn_cau3(@MaKhoa char(10))
returns @sv table ( MaSV		char(10),
					HoTen		nvarchar(30),
					NgaySinh	date,
					GioiTinh	bit,
					TenLop		nvarchar(30),
					TenKhoa		nvarchar(30)
				  )
as
begin 
		insert into @sv
		select MaSV, HoTen, NgaySinh, GioiTinh, TenLop TenKhoa
		from Khoa inner join Lop on Khoa.MaKhoa=Lop.MaKhoa
					inner join SinhVien on Lop.MaLop=SinhVien.MaLop
		where Lop.MaKhoa=@MaKhoa
return 
end
go
drop function fn_cau3
--test
select * from fn_cau3('K01')
select * from fn_cau3('K02')

--Cau 4: Hãy tạo Trigger để tự động tăng sĩ số sinh viên trong bảng lớp, mỗi khi thêm mới dữ liệu mới
--cho bảng SinhVien. Nếu SiSo >80 thì không cho thêm và đưa ra cảnh báo
create trigger trg_insertSinhVien
on SinhVien
for insert
as 
begin
	declare @siso int
	select @siso = Lop.SiSo
	from Lop inner join inserted
	on Lop.MaLop = inserted.MaLop
	if( @siso > 80)
		begin 
			raiserror ('Khong the them', 16, 1)
			rollback transaction
		end
	else
		begin
			update Lop
			set SiSo=SiSo+1
			from inserted, Lop
			where Lop.MaLop=inserted.MaLop
		end
end
go
drop trigger trg_insertSinhVien
--test
insert into SinhVien values('2020705023', N'Nguyen Van Huy', '2002/05/24', 1, '002'),
							('2020756023', N'Dinh Van Phuc', '2002/07/06', 1, '001' )
select * from Khoa
select * from Lop
select * from SinhVien