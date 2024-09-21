--a.Đưa ra các thông tin về các hóa đơn mà hãng Samsung đã nhập trong năm 2020, 
--gồm: SoHDN, MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong.
create view a
as
select PNhap.SoHDN, Nhap.MaSP, TenSP, SoLuongN, DonGiaN,
NgayNhap, TenNV, TenPhong 
from Nhap inner join PNhap on Nhap.SoHDN=PNhap.SoHDN 
inner join NhanVien on NhanVien.MaNV=PNhap.MaNV
inner  join SanPham on SanPham.MaSP=Nhap.MaSP
where year(NgayNhap)=2020

select * from a

--b. Đưa ra các thông tin sản phẩm có giá bán từ 100.000 đến 500.000 của hãng 
Samsung.
create view b
as
select TenSP, MaSP,GiaBan, MauSac, DonViTinh, Mota from SanPham
inner join HangSX on SanPham.MaHangSX=HangSX.MaHangSX
where TenHang='Samsung' and  GiaBan BetWeen 1000000 and 5000000

--c.Tính tổng tiền đã nhập trong năm 2020 của hãng Samsung.
create view c
as
Select Sum(SoLuongN*DonGiaN) As n'Tổng tiền nhập'
From Nhap Inner join SanPham on Nhap.MaSP = SanPham.MaSP
 Inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
 Inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
Where Year(NgayNhap)=2020 And TenHang = 'Samsung'

--d.Thống kê tổng tiền đã xuất trong ngày 14/06/2020.
create view d
as
Select Sum(SoLuongX*GiaBan) As N'Tổng tiền xuất'
From Xuat Inner join SanPham on Xuat.MaSP = SanPham.MaSP
 Inner join PXuat on Xuat.SoHDX=PXuat.SoHDX
Where NgayXuat = '14/06/2020'

--e.Đưa ra SoHDN, NgayNhap có tiền nhập phải trả cao nhất trong năm 2020.
create view e
as 
select PNhap.SoHDN, NgayNhap from PNhap
inner join Nhap on PNhap.SoHDN=Nhap.SoHDN
where year(NgayNhap)=2020 and (SoLuongN*DonGiaN) =
(Select Max(SoLuongN*DonGiaN) from Nhap 
inner join PNhap on PNhap.SoHDN=Nhap.SoHDN
where year(NgayNhap)=2020)

--f.Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩ
create view f
as 
select HangSX.MaHangSX, TenHang, count(*) as N'So luong sp hang'
from SanPham inner join HangSX on SanPham.MaHangSX=HangSX.MaHangSX
group by HangSX.MaHangSX, TenHang

--g.Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2020.
create view g
as
select sum(SoLuongN*DonGiaN) as N'Tong tien nhap', Nhap.MaSP, TenSP
from Nhap inner join SanPham on Nhap.MaSP=SanPham.MaSP
inner  join PNhap on PNhap.SoHDN=Nhap.SoHDN
where year(NgayNhap)=2020
group by Nhap.MaSP, TenSP


--h.Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2020 là lớn hơn 10.000 sản phẩm của hãng Samsung.
Create view h
as
Select SanPham.MaSP,TenSP,sum(SoLuongX) As N'Tổng xuất'
From Xuat Inner join SanPham on Xuat.MaSP = SanPham.MaSP
 Inner join HangSX on HangSX.MaHangSX = SanPham.MaHangSX
 Inner join PXuat on Xuat.SoHDX=PXuat.SoHDX
Where Year(NgayXuat)=2018 And TenHang = 'Samsung'
Group by SanPham.MaSP,TenSP
Having sum(SoLuongX) >=10000

--i.Thống kê số lượng nhân viên Nam của mỗi phòng ban.
create view i
as 
select Tenphong,count(MaNV) as N'So NV Nam'
from NhanVien 
where GioiTinh='0'
group by TenPhong,TenNV, MaNV

--j.Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018
create view j
as
select TenHang, HangSX.MaHangSX, sum(SoLuongN) 
from HangSX inner join SanPham on HangSX.MaHangSX=SanPham.MaHangSX
inner join Nhap on SanPham.MaSP=Nhap.MaSP
inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
where year(NgayNhap)=2018
group by TenHang,HangSX.MaHangSX

--k. Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao nhiêu.