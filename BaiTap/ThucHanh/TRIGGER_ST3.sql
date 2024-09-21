USE QLBANGHANG2022_2
/*1. Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng nhập, hãy kiểm tra các ràng buộc toàn vẹn: 
MaSP có trong bảng sản phẩm chưa? Kiểm tra các ràng buộc dữ liệu: SoLuongN và DonGiaN>0? 
Sau khi nhập thì SoLuong ở bảng SanPham sẽ được cập nhật theo*/
CREATE TRIGGER TG_CHENDLNHAP
ON NHAP
FOR INSERT
AS
DECLARE @maSP char(10), @soLuongNhap int, @donGiaNhap money
SELECT @maSP=MaSP, @soLuongNhap=SoLuongN, @donGiaNhap=DonGiaN
FROM inserted
--kiểm tra xem có Masp trong bảng sản phẩm chưa?
IF NOT EXISTS(SELECT * FROM SanPham WHERE MaSP=@maSP)
BEGIN
	PRINT N'KHÔNG CÓ SẢN PHẨM TRONG BẢNG SẢN PHẨM'
	ROLLBACK TRANSACTION 
END
ELSE
	IF (@soLuongNhap<=0 OR @donGiaNhap<=0)
	BEGIN
		PRINT N'SỐ LƯỢNG NHẬP VÀ ĐƠN GIÁ NHẬP PHẢI LỚN HƠN 0'
		ROLLBACK TRANSACTION
	END
	ELSE
	UPDATE SanPham
	SET SoLuong=SoLuong+@soLuongNhap
	WHERE MaSP=@maSP
--THỰC THI TRIGGER
--TH1: KHÔNG CÓ SẢN PHẨM TRONG BẢNG SẢN PHẨM
ALTER TABLE NHAP NOCHECK CONSTRAINT ALL
INSERT INTO Nhap VALUES ('HDN01','SP10',20,2000)
--TH2: SỐ LƯỢNG NHẬP <=0
INSERT INTO Nhap VALUES('HDN01','SP01',0,2000)
--TH3: ĐƠN GIÁ NHÂP<=0
INSERT INTO Nhap VALUES('HDN01','SP01',20,0)
--TH4: CHÈN THÀNH CÔNG.
SELECT * FROM SanPham
SELECT * FROM Nhap
INSERT INTO Nhap VALUES('HDN01','SP01',20,20000)
SELECT * FROM Nhap
SELECT * FROM SanPham

/*2. Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng xuất, hãy kiểm tra các ràng buộc toàn vẹn: 
MaSP có trong bảng sản phẩm chưa? 
kiểm tra các ràng buộc dữ liệu: SoLuongX <= SoLuong trong bảng SanPham? 
Sau khi xuất thì SoLuong ở bảng SanPham sẽ được cập nhật theo*/
CREATE TRIGGER TG_CHENDLXUAT
ON XUAT
FOR INSERT
AS
DECLARE @maSP char(10), @soLuongXuat int, @soLuongCo int
SELECT @maSP= MaSP, @soLuongXuat=SoLuongX
FROM inserted
SELECT @soLuongCo=SoLuong FROM SanPham
IF NOT EXISTS (SELECT * FROM SanPham WHERE MaSP=@maSP)
BEGIN
	RAISERROR('N KHÔNG CÓ SẢN PHẨM TRONG BẢNG SẢN PHẨM',16,1)
	ROLLBACK TRANSACTION
END
ELSE
	IF(@soLuongXuat>@soLuongCo)
	BEGIN
		RAISERROR(N'SỐ LƯỢNG XUẤT PHẢI NHỎ HƠN HOẶC BẰNG SỐ LƯỢNG CÓ',16,1)
		ROLLBACK TRANSACTION
	END
	ELSE
	UPDATE SanPham 
	SET SoLuong=SoLuong-@soLuongXuat
	WHERE MaSP=@maSP
--THỰC THI TRIGGER
--TH1: KHÔNG CÓ SẢN PHẨM TRONG BẢNG SẢN PHẨM
ALTER TABLE Xuat NOCHECK CONSTRAINT ALL
INSERT INTO Xuat VALUES('HDX01','SP10',20)
--TH2: SỐ LƯỢNG XUẤT LỚN HƠN SỐ LƯỢNG CÓ
INSERT INTO Xuat VALUES('HDX01','SP01',20000)
--TH3: CHÈN THÀNH CÔNG, CẬP NHẬT LẠI SỐ LƯỢNG CÓ TRONG BẢNG SẢN PHẨM
SELECT * FROM Xuat
SELECT * FROM SanPham
INSERT INTO Xuat VALUES('HDX01','SP02',10)
SELECT * FROM Xuat
SELECT * FROM SanPham
/*3. Tạo Trigger kiểm soát việc xóa dòng dữ liệu bảng xuất, 
khi một dòng bảng xuất xóa thì số lượng hàng trong bảng SanPham
sẽ được cập nhật tăng lên*/
CREATE TRIGGER TG_XOAXUAT
ON XUAT
FOR DELETE
AS
DECLARE @soLuongXuat int, @maSP char(10)
SELECT @soLuongXuat=SoLuongX, @maSP=MaSP
FROM deleted
UPDATE SanPham
SET SoLuong=SoLuong+@soLuongXuat
WHERE MaSP=@maSP
/*UPDATE SanPham
SET SoLuong=SoLuong+ deleted.SoLuongX
FROM SanPham INNER JOIN deleted 
ON SanPham.MaSP= deleted.MaSP*/
--
SELECT * FROM SanPham
SELECT * FROM Xuat
DELETE FROM Xuat WHERE SoHDX='HDX01' AND MaSP='SP02'
SELECT * FROM SanPham
SELECT * FROM Xuat
/*Tạo Trigger cho việc cập nhật lại số lượng xuất trong bảng xuất, 
nếu số bản ghi thay đổi lớn hơn 1 thì thông báo ko được thay đổi.
hãy kiểm tra xem số lượng xuất thay đổi có nhỏ hơn 
SoLuong trong bảng SanPham hay ko?
nếu thỏa mãn thì cho phép Update bảng xuất và Update lại SoLuong trong bảng SanPham*/
CREATE TRIGGER TG_CAPNHATXUAT
ON XUAT
FOR UPDATE
AS
DECLARE @soLuongXuatMoi int, @soLuongXuatCu	int, @maSP char(10), @soLuongCo int
IF(@@ROWCOUNT>1)
BEGIN
	PRINT N'KHÔNG ĐƯỢC CẬP NHẬT HƠN 1 DÒNG'
	ROLLBACK TRANSACTION
END
SELECT @soLuongXuatMoi=SoLuongX, @maSP=MaSP
FROM inserted
SELECT @soLuongXuatCu=SoLuongX
FROM deleted
SELECT @soLuongCo=SoLuong
FROM SanPham WHERE MaSP=@maSP
IF(@soLuongCo<(@soLuongXuatMoi-@soLuongXuatCu))
BEGIN
	PRINT N'KHÔNG CẬP NHẬT ĐƯỢC'
	ROLLBACK TRANSACTION
END
ELSE
	UPDATE SanPham
	SET SoLuong=SoLuong-(@soLuongXuatMoi-@soLuongXuatCu)
	WHERE MaSP=@maSP
--THỰC THI TRIGGER
--TRƯỜNG HỢP CẬP NHẬT NHIỀU DÒNG
UPDATE Xuat
SET SoLuongX=SoLuongX+1
--TRƯỜNG HỢP CẬP NHẬT SỐ LƯỢNG MỚI NHIỀU HƠN SỐ LƯỢNG CÓ TRONG CSDL
UPDATE Xuat
SET SoLuongX=50
WHERE SoHDX='HDX01' AND MaSP='SP01'
--TRƯỜNG HỢP CẬP NHẬT THÀNH CÔNG
SELECT * FROM SanPham
SELECT * FROM Xuat
UPDATE Xuat
SET SoLuongX=31
WHERE SOHDX='HDX01' AND MaSP='SP01'
SELECT * FROM SanPham
SELECT * FROM Xuat