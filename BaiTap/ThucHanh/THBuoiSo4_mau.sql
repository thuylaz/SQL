USE QLBANHANGST7
GO
/*
SanPham(MaSP, MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa)
HangSX(MaHangSX, TenHang, DiaChi, SoDT, Email)
NhanVien(MaNV, TenNV, GioiTinh, DiaChi, SoDT, Email, TenPhong)
Nhap(SoHDN, MaSP, SoLuongN, DonGiaN)
PNhap(SoHDN,NgayNhap,MaNV)
Xuat(SoHDX, MaSP, SoLuongX)
PXuat(SoHDX,NgayXuat,MaNV*/
/*Đưa ra thông tin phiếu xuất gồm: SoHDX, MaSP, TenSP, TenHang, SoLuongX, 
GiaBan, tienxuat=SoLuongX*GiaBan, MauSac, DonViTinh, NgayXuat, TenNV, 
TenPhong trong tháng 06 năm 2020, sắp xếp theo chiều tăng dần của SoHDX.*/SELECT Xuat.SoHDX,SanPham.MaSP, TenSP, TenHang, SoLuongX, GiaBan, SoLuongX*GiaBan AS TienXuat,		MauSac, DonViTinh, NgayXuat, TenNV, TenPhongFROM SanPham INNER JOIN HangSX ON SanPham.MaHangSX=HangSX.MaHangSX	INNER JOIN Xuat ON Xuat.MaSP=SanPham.MaSP	INNER JOIN PXuat ON Xuat.SoHDX=PXuat.SoHDX	INNER JOIN NhanVien ON NhanVien.MaNV=PXuat.MaNVWHERE MONTH(NgayXuat)=6 AND YEAR(NgayXuat)=2020ORDER BY Xuat.SoHDX--a. Đưa ra các thông tin về các hóa đơn mà hãng Samsung đã nhập trong năm 2020, gồm: 
--SoHDN, MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong.
SELECT PNhap.SoHDN, SanPham.MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong
FROM PNhap INNER JOIN Nhap ON PNhap.SoHDN=Nhap.SoHDN
INNER JOIN SanPham ON Nhap.MaSP=SanPham.MaSP
INNER JOIN NhanVien ON NhanVien.MaNV=PNhap.MaNV
INNER JOIN HangSX ON HangSX.MaHangSX=SanPham.MaHangSX
WHERE TenHang=N'HẢI HÀ' AND YEAR(NGAYNHAP)=2020
--b. Đưa ra Top 10 hóa đơn xuất có số lượng xuất nhiều nhất trong năm 2020, sắp xếp theo 
--chiều giảm dần của SoLuongX. 
SELECT TOP 10 PXuat.SoHDX,NgayXuat,MaNV
FROM PXuat INNER JOIN Xuat ON PXuat.SoHDX=Xuat.SoHDX
WHERE YEAR(NgayXuat)=2020
ORDER BY PXuat.SoHDX DESC
--c. Đưa ra thông tin 10 sản phẩm có giá bán cao nhất trong cữa hàng, theo chiều giảm dần giá bán.
SELECT TOP 10 *
FROM SanPham
ORDER BY GiaBan DESC
--d. Đưa ra các thông tin sản phẩm có giá bán từ 100.000 đến 500.000 của hãng Samsung. 
SELECT *
FROM SanPham INNER JOIN HangSX ON SanPham.MaHangSX=HangSX.MaHangSX
WHERE GiaBan BETWEEN 10000 AND 50000
AND TenHang=N'HẢI HÀ'
--e. Tính tổng tiền đã nhập trong năm 2020 của hãng Samsung. 
SELECT SUM(SoLuongN*DonGiaN) AS TSLNHAP
FROM SanPham INNER JOIN Nhap 
ON SanPham.MaSP=Nhap.MaSP
INNER JOIN PNhap
ON PNhap.SoHDN=Nhap.SoHDN
INNER JOIN HangSX 
ON HangSX.MaHangSX=SanPham.MaHangSX
WHERE YEAR(NgayNhap)=2020 AND TenHang=N'HẢI HÀ'
--f. Thống kê tổng tiền đã xuất trong ngày 14/06/2020.
SELECT SUM(SoLuongX*GiaBan) AS TongTienXuat
FROM SanPham INNER JOIN Xuat ON SanPham.MaSP=Xuat.MaSP
INNER JOIN PXuat ON Xuat.SoHDX=PXuat.SoHDX
WHERE NgayXuat='2022-3-18'
--g. Đưa ra SoHDN, NgayNhap có tiền nhập phải trả cao nhất trong năm 2020*/
SELECT SOHDN, NgayNhap	
FROM PNhap
WHERE YEAR(NgayNhap)=2020 AND SoHDN IN( SELECT SoHDN 
				FROM Nhap WHERE SoLuongN* DonGiaN=(SELECT MAX(SOLUONGN*DONGIAN)
													FROM Nhap INNER JOIN PNhap 
													ON Nhap.SoHDN=PNhap.SoHDN
													WHERE YEAR(NgayNhap)=2020))

--a. Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm
SELECT MaHangSX, COUNT(MaSP) AS SOLUONGSP
FROM SanPham
GROUP BY MaHangSX
--b. Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2020.
SELECT MaSP, SUM(SoLuongN*DonGiaN)AS 'TONG TIEN NHAP'
FROM Nhap INNER JOIN PNhap 
ON Nhap.SoHDN=PNhap.SoHDN
WHERE YEAR(NgayNhap)=2020
GROUP BY MaSP
--c. Hãy thống kê các sản phẩm của hãng Samsung có tổng số lượng xuất năm 2020 là lớn hơn 10.000.
SELECT SanPham.MaSP, TenSP, SUM(SoLuongX)AS 'TỔNG SỐ LƯỢNG XUẤT'
FROM SanPham INNER JOIN Xuat 
ON SanPham.MaSP=Xuat.MaSP
INNER JOIN PXuat
ON PXuat.SoHDX=Xuat.SoHDX
INNER JOIN HangSX
ON HangSX.MaHangSX=SanPham.MaHangSX
WHERE YEAR(NgayXuat)=2022 AND TenHang=N'Hải Hà'
GROUP BY SanPham.MaSP, TenSP
HAVING SUM(SoLuongX)>5
--d. Thống kê số lượng nhân viên Nam của mỗi phòng ban.
SELECT TenPhong, COUNT(*) AS 'SỐ LƯỢNG NV'
FROM NhanVien
WHERE GioiTinh=1
GROUP BY TenPhong
--e. Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018.
SELECT HangSX.MaHangSX, TenHang, SUM(SoLuongN) AS N'TỔNG SỐ LƯỢNG NHẬP'
FROM HangSX INNER JOIN SanPham 
ON HangSX.MaHangSX=SanPham.MaHangSX
INNER JOIN Nhap
ON Nhap.MaSP=SanPham.MaSP
INNER JOIN PNhap
ON Nhap.SoHDN=PNhap.SoHDN
WHERE YEAR(NgayNhap)=2020
GROUP BY HangSX.MaHangSX, TenHang
--f. Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao nhiêu
SELECT NhanVien.MaNV, TenNV, SUM(SoLuongX*GiaBan) AS N'Tổng tiền xuất'
FROM NhanVien INNER JOIN PXuat 
ON NhanVien.MaNV=PXuat.MaNV
INNER JOIN Xuat
ON PXuat.SoHDX=Xuat.SoHDX
INNER JOIN SanPham
ON SanPham.MaSP=Xuat.MaSP
WHERE YEAR(NgayXuat)=2022
GROUP BY NhanVien.MaNV, TenNV


--phiếu bài tập về nhà 4.11
--a (2.5đ). Đưa ra 10 mặt hàng có SoLuongN nhiều nhất trong năm 2019
SELECT TOP 10 *
FROM SanPham
WHERE MaSP IN(SELECT MaSP FROM Nhap INNER JOIN PNhap
				ON Nhap.SoHDN=PNhap.SoHDN
				WHERE YEAR(NgayNhap)=2020 
				GROUP BY MaSP
				HAVING SUM(SoLuongN)=(SELECT MAX(TSLNHAP)
										FROM (SELECT SUM(SoLuongN) AS TSLNHAP
											  FROM Nhap INNER JOIN PNhap
											  ON Nhap.SoHDN=PNhap.SoHDN
											  WHERE YEAR(NgayNhap)=2020
											  GROUP BY MaSP) AS BANGTAM))
--b (2.5đ). Đưa ra MaSP,TenSP của các sản phẩm do công ty ‘Samsung’ sản xuất do nhân viên có mã ‘NV01’ nhập.
SELECT SanPham.MaHangSX, TenSP
FROM SanPham INNER JOIN HangSX ON SanPham.MaHangSX=HangSX.MaHangSX
INNER JOIN Nhap ON SanPham.MaSP=Nhap.MaSP
INNER JOIN PNhap ON Nhap.SoHDN=PNhap.SoHDN
WHERE TenHang=N'SAMSUNG' AND MaNV='NV01'
--c (2.5đ). Đưa ra SoHDN,MaSP,SoLuongN,ngayN của mặt hàng có MaSP là ‘SP02’, 
--được nhân viên ‘NV02’ nhập.
SELECT PNhap.SoHDN, SanPham.MaSP, SoLuongN, NgayNhap
FROM PNhap INNER JOIN Nhap ON PNhap.SoHDN=Nhap.SoHDN
INNER JOIN SanPham ON SanPham.MaSP=Nhap.MaSP
WHERE SanPham.MaSP='SP02' AND MaNV='NV02'
--d (2.5đ). Đưa ra manv,TenNV đã xuất mặt hàng có mã ‘SP02’ ngày ‘03-02-2020’SELECT NhanVien.MaNV, TenNVFROM NhanVien INNER JOIN PNhap ON NhanVien.MaNV=PNhap.MaNVINNER JOIN Nhap ON PNhap.SoHDN=Nhap.SoHDNWHERE MaSP='SP02' AND NgayNhap='2022-03-19'--lưu ý: ở giờ thực hành, cô đổi điều kiện ở mệnh đề WHERE để câu lệnh truy vấn ra được kết quả phù hợp với--dữ liệu đã nhập. Còn đi thi hoặc kiểm tra KHÔNG ĐƯỢC ĐỔI ĐIỀU KIỆN CỦA ĐỀ BÀI cho phù hợp dữ liệu của mình--mà phải nhập dữ liệu của mình sao cho phù hợp điều kiện đề bài ra--d (2đ). Hãy Đưa ra danh sách các nhân viên vừa nhập vừa xuất.
SELECT *
FROM NhanVien
WHERE MaNV IN (SELECT MaNV FROM PNhap)
INTERSECT
SELECT *
FROM NhanVien
WHERE MaNV IN (SELECT MaNV FROM PXuat)
--e (2đ). Hãy Đưa ra danh sách các nhân viên không tham gia việc nhập và xuất
