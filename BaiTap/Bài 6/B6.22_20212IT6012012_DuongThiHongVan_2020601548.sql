create database QLKHO

--Câu 1 (1đ). Tạo CSDL QLKHO gồm 3 bảng
create  table Ton
(
MaVT nchar(10) not null primary key,
TenVT nvarchar(20) not null,
SoLuongT int
)
create table Nhap
(
SoHDN nchar(10) not null,
MaVT nchar(10) not null,
SoLuongN int,
DonGiaN money,
NgayN datetime
constraint Pk_N primary key(SoHDN,MaVT),
constraint Fk_Ton_N foreign key (MaVT) references Ton(MaVT)
)
create table Xuat
(
SoHDX nchar(10) not null,
MaVT nchar(10) not null,
SoLuongX int,
DonGiaX money ,
NgayX datetime,
constraint Pk_X_T primary key(SoHDX,MaVT),
constraint Fk_X_T foreign key (MaVT) references Ton(MaVT)
)
--Câu 2 (1đ). Đưa ra tên vật tư số lượng tồn nhiều nhất
select TenVT from Ton
where SoLuongT in
(select max(SoluongT) from Ton)

--Câu 3 (1đ). Đưa ra các vật tư có tổng số lượng xuất lớn hơn 100
select Xuat.MaVT, TenVT from Xuat
inner join Ton on Xuat.MaVT=Ton.MaVT
group by Xuat.MaVT, TenVT
having sum(SoLuongX)>100

--Câu 4 (1đ). Tạo view đưa ra tháng xuất, năm xuất, tổng số lượng xuất thống kê theo 
--tháng và năm xuất
create view c4
as
select month(NgayX) as 'NgayXuat',year(NgayX) as 'Nam Xuat', sum(SoLuongX) as 'Tong So Luong'
from Xuat 
group by month(NgayX), year(NgayX)
 

--Câu 5 (2đ). Tạo view đưa ra mã vật tư. tên vật tư. số lượng nhập. số lượng xuất. đơn 
--giá N. đơn giá X. ngày nhập. Ngày xuất.
create view c5
as 
select Xuat.MaVT as 'mã xuất',Nhap.MaVT as'mã nhập', TenVT
SoLuongN, SoLuongX, DonGiaX, DonGiaN, NgayN, NgayX
from Xuat 
inner join Ton on Xuat.MaVT=Ton.MaVT
inner join Nhap on Nhap.MaVT=Ton.MaVT

--Câu 6 (2đ). Tạo view đưa ra mã vật tư. tên vật tư và tổng số lượng còn lại trong kho. 
--biết còn lại = SoluongN-SoLuongX+SoLuongT theo từng loại Vật tư trong năm 2015
create view c6
as
select	Ton.MaVT, TenVT, sum(SoLuongN-SoLuongX+SoLuongT) as 'Số lượng còn' 
from Ton 
inner join Nhap on Nhap.MaVT=Ton.MaVT
inner join Xuat on Xuat.MaVT=Ton.MaVT
where year(NgayN)=2015 and year(NgayX)=2015
group by Ton.MaVT, TenVT