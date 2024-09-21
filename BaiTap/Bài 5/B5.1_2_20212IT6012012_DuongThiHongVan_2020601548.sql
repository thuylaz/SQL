use master
go
if(exists(select * from sysdatabases where name = 'TRUONGHOC'))
	drop database TRUONGHOC
go
create database TRUONGHOC
go
use TRUONGHOC
go

/* create table */
create table HOCSINH
(
	MAHS char(5) not null,
	TEN nvarchar(30),
	NAM bit,
	NGAYSINH datetime,
	DIACHI	varchar(20),
	DIEMTB float
)

create table GIAOVIEN
(
	MAGV char(5)not null,
	TEN nvarchar(30),
	NAM bit,
	NGAYSINH datetime,
	DIACHI varchar(20),
	LUONG money
)
create table LOPHOC
(
	MALOP char(5) not null,
	TENLOP nvarchar(30),
	SOLUONG int
)

/* insert into */
insert into HOCSINH
values	('S001', N'Dương Thị Hồng Vân',0,'07/24/2002', N'Hà Nam', 8 ),
		('S002', N'Trần Thị Luyến',0, '02/19/2002', N'Hà Nam', 9),
		('S003', N'Phạm Thị Duyên',0, '03/13/2002', N'Hà Nam', 8)

insert into GIAOVIEN
values	('GV01', N'Đào Thị Huyền',0, '12/30/1979', 8000000),
		('GV02', N'Dương Văn Phương',1, '10/30/1968', 5000000)

insert into LOPHOC
values	('L001', N' Hệ thống thông tin 01', 10)

go

--Update
update HOCSINH
set DIEMTB=8
where DIEMTB>=5
select * from HOCSINH
insert into LOPHOC values ('L002', 'Hệ thống thông tin 02', 8)
select * from LOPHOC