use master 
go
create database qlsv
on primary(
	name= 'qlsv_dat',
	filename= 'D:\SQL\qlsv.mdf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

log on(
	name= 'qlsv_log',
	filename= 'D:\SQL\qlsv.ldf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

go
use qlsv
go

create table sv(
	masv nchar(10) not null primary key,
	tensv nvarchar(20),
	que nvarchar(20)
)

create table mon(
	mamh nchar(10) not null primary key,
	tenmh nvarchar(20),
	sotc int,
	constraint unique_mon unique(tenmh),
	constraint chk_sotinchi check(sotc>=2 and sotc<=5)
)

create table kq(
	masv nchar(10) not null,
	mamh nchar(10) not null,
	diem nchar(100),
	constraint pk_Kq primary key(masv, mamh),
	constraint fk_Kq_sv foreign key(masv)
	references sv(masv),
	constraint fk_Kq_monh foreign key(mamh)
	references mon(mamh),
	constraint chk_diem check(diem>=0 and diem<=10)
)

insert into sv values
(2021601086, N'Hoàng Thị Thúy', N'Nam Định'),
(2021601087, N'Hoàng Thị Nhung', N'Nam Định'),
(2021601088, N'Hoàng Đức Thiện', N'Nam Định')

insert into mon values
('PH01', N'lập trình', 3),
('PH02', N'nguyên lý', 3),
('PH03', N'phân tích', 3)

insert into kq values
(2021601086, 'PH01', 8),
(2021601087, 'PH01', 9),
(2021601088, 'PH01', 7),
(2021601086, 'PH02', 5),
(2021601087, 'PH03', 6),
(2021601088, 'PH02', 7)

select* from sv
select *from mon
select *from kq