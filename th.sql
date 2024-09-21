
create database qlks

go
use qlks
go

create table khach(
makhach varchar(3) not null primary key,
tenkhach nvarchar(30),
diachi nvarchar(50),
dienthoai varchar(20),
scmnd varchar(12)
)
create table phong(
sophong varchar(3) not null primary key,
loai nvarchar(10),
dongia int
)
create table thuephong(
makhach varchar(3),
sophong varchar(3),
ngaythue datetime not null primary key,
ngayhentra datetime,
ngaytra datetime,
constraint fk_tp_k foreign key(makhach)
references khach(makhach),
constraint fk_tp_p foreign key(sophong)
references phong(sophong)
)
----------------------
insert into khach
values
('K01',N'katty perry', N'Nam Dinh','888888888','00000000'),
('K02',N'taylor totrang', N'Ha Noi','88832428','0023400'),
('K03',N'anhohaxeyo', N'Bac Giang','883426','00003457')
-----------
insert into phong
values
('P01','thuong',3000),
('P02','thuong',3000),
('P03','tot',6000)
------------
insert into thuephong
values
('K01','P02','2/22/2004','3/14/2005','3/12/2004'),
('K03','P01','3/26/2005','4/17/2023','7/13/2012'),
('K02','P03','10/2/2007','5/19/2007','12/11/2008')

--3
create function tienthue(@ngayhentra datetime)
returns @tt table(makhach varchar(3), sophong varchar(3), ngaythue datetime)
as begin 
insert into @tt
select makhach, thuephong.sophong, ngaythue, dongia*DATEDIFF(day, ngaythue, ngaytra) as tienthue
from thuephong join phong
on phong.sophong= thuephong.sophong
where @ngayhentra= ngayhentra
return 
end

select *from tienthue('5/19/2007')

create function bangthanhtoan()