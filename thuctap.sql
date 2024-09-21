use master 
go

create database thuctap
on primary(
	name= 'thuctap_dat',
	filename= 'D:\SQL\thuctap.mdf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

log on(
	name= 'thuctap_log',
	filename= 'D:\SQL\thuctap.ldf',
	size= 1MB,
	maxsize= 5MB,
	filegrowth= 20%
)

go 
use thuctap
go

create table khoa(
	makhoa char(10) not null primary key,
	tenkhoa char(30),
	dienthoai char(10)
)

create table gv(
	magv int not null primary key,
	hotengv char(30),
	luong decimal(5,2),
	makhoa char(10) not null,
	constraint fk_Gv_k foreign key(makhoa)
	references khoa(makhoa)
)

create table sv(
	masv int not null primary key,
	hotensv char(30),
	makhoa char(10) not null,
	namsinh int,
	quequan char(30),
	constraint fk_Sv_k foreign key(makhoa)
	references khoa(makhoa)
)

create table detai(
	madt char(10) not null primary key,
	tendt char(30),
	kinhphi int,
	nottt char(30)
)

create table hd(
	masv int not null,
	madt char(10) not null,
	magv int not null,
	kq decimal(5,2),
	constraint fk_Hd_Sv foreign key(masv)
	references sv(masv),
	constraint fk_Hd_dt foreign key(madt)
	references detai(madt),
	constraint fk_Hd_Gv foreign key(magv)
	references gv(magv)
)

insert into khoa
values
('K01','Khoa CNTT',08686868),
('K02','Khoa CNmay',0999999),
('K03','Khoa Dien',012345678),
('K04','Khoa Ngoai Ngu',06666666),
('K05','Khoa Ke Kiem',08243566)
insert into gv
values
(11,N'Thúy','3','K02'),
(12,N'Uyên','4','K05'),
(13,N'Phúc','2','K01'),
(14,N'Vân','5','K04'),
(15,N'Việt','3','K03')
insert into sv
values
('001','Anh','K02',2003,N'Nam Định'),
('002','Nam','K05',2003,N'Hải Dương'),
('003','Ivan','K04',2003,N'Nghệ An'),
('004','Banana','K01',2002,N'Thanh Hóa'),
('005','Durian','K03',2003,N'Thái Bình')
insert into detai
values
('DT1',N'Thiết kế web',2000,'Samsung'),
('DT2',N'Thiết kế công trình',4000,'Apple'),
('DT3',N'Thiết kế ứng dụng',5000,'Oppo'),
('DT4',N'Thiết kế cửa',6000,'Vinfone'),
('DT5',N'Thiết kế ghế',7000,'Xiaomi')
insert into hd
values
(002,'DT2',13,2),
(002,'DT5',11,3),
(003,'DT1',12,4),
(004,'DT4',14,2),
(005,'DT3',15,5)

--cau 1
select gv.magv, gv.hotengv, khoa.tenkhoa
from gv join khoa
on gv.makhoa = khoa.makhoa

--cau 2
select gv.magv, gv.hotengv, khoa.tenkhoa 
from gv join khoa
on gv.makhoa=khoa.makhoa
where khoa.tenkhoa= 'Khoa CNTT'

--cau 3
select count(sv.masv)
from sv 
where makhoa= 'K01'

--cau 4
select masv, hotensv, (2023-namsinh)
from sv

--cau 5
select count(gv.magv)
from gv
where makhoa= 'K03'

--cau 6
select *from sv
where not exists(
select hd.masv from hd
where sv.masv= hd.masv
)

--cau 7
select khoa.makhoa, khoa.tenkhoa, count(khoa.makhoa) as so_gv_moi_khoa
from gv join khoa
on gv.makhoa= khoa.makhoa
group by khoa.makhoa, khoa.tenkhoa

--cau 8
select dienthoai 
from khoa join sv
on khoa.makhoa= sv.makhoa
where hotensv= 'Durian'

