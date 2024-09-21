use master
go

create database de9
go
use de9
go

create table BenhVien9()
go

create table KhoaKham9()
go

create table BenhNhan9()
go

insert into BenhVien9 values ()
go 
insert into KhoaKham9 values ()
go
insert into BenhNhan9 values() 
go

select * from
select * from
select * from

--Cau 2: Đưa ra những bệnh nhân cao tuổi nhất gồm: MaBN, HoTen, Tuoi

--Cau 3: Hàm tham số truyền vào là MaBN, trả về một bảng tt: MaBN, HoTen, NgaySinh, GioiTinh(Nam or Nữ), TenKhoa, TenBV

--Cau 4: Trigger tự động tăng số bệnh nhân trong bảng KhoaKham, mỗi khi thêm mới dữ liệu cho bang BenhNhan. Nếu số BN trong khoa
--khám >100 thì không thêm và đưa ra cảnh báo

