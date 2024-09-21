create database qlsvi

go
use qlsvi
go

create table sv(
	masv nchar(10) not null primary key,
	tensv nvarchar(20),
	que nvarchar(20)
)

create table mon(
	mamh nchar(10) not null primary key,
	tenmh nvarchar(20),
	sotc int
)

create table kq(
	masv nchar(10) not null,
	mamh nchar(10) not null,
	diem nchar(100),
	constraint fk_Kq_sv foreign key(masv)
	references sv(masv),
	constraint fk_Kq_monh foreign key(mamh)
	references mon(mamh),
)

insert into sv values
(2021601086, N'Hoàng Thị Thúy', N'Nam Định'),
(2021601087, N'Hoàng Thị Nhung', N'Nam Định'),
(2021601088, N'Hoàng Đức Thiện', N'hà nội')

insert into mon values
('PH01', N'lập trình', 3),
('PH02', N'nguyên lý', 4),
('PH03', N'phân tích', 5)

insert into kq values
(2021601086, 'PH01', 8),
(2021601087, 'PH01', 9),
(2021601088, 'PH01', 7),
(2021601086, 'PH02', 5),
(2021601086, 'PH03', 6),
(2021601088, 'PH02', 7)

select *from sv
select *from mon
select *from kq

--ten sv diem cac mon >5
select distinct sv.masv
from sv join kq
on sv.masv= kq.masv
where (sv.masv)
not in(select masv from kq where diem<=7 group by masv)
group by sv.masv



where 

where exists()

diem>=5 and  = (select count(distinct mamh) from kq)

select masv 
from kq
where diem>5
having count(distinct masv)= (select count(masv) from kq)


group by sv.masv, tensv 
having count(distinct mamh) 

1.Cho biết tên những môn học mà tất cả giáo viên đều tham gia giảng dạy?


SELECT G.MAMH,TENMH
FROM GIANGDAY G, MONHOC M
WHERE G.MAMH=M.MAMH
GROUP BY G.MAMH,TENMH
HAVING COUNT(DISTINCT MAGV)=(SELECT COUNT(MAGV)
FROM GIAOVIEN)