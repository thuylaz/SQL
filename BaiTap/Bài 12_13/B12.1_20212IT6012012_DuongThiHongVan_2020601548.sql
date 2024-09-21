
--Thực hiện Backup dữ liệu cới 3 loại sao lưu
--1.Thực hiện full Backup
Backup Database QLBanHang to disk='D:\bk\QLBH.bak'
--2.Thên dữ liệu cho bang NHANVIEN
Insert into NHANVIEN values('NV04',N'Mai Hanh Phuc', N'Nu',N'Ha Nam', '028938127','Thuy@gmail.com',N'Ke toan')
--3.Thực hiện different Backup
Backup Database QLBanHang to disk='D:\bk\QLBH.Diff.bak' with differential
--4.Tiêp tục thêm  dữ liệu cho bảng NHANVIEN
Insert into NHANVIEN values('NV05',N'Sau Bat Hanh', N'Nu',N'Bac Giang', '038938127','hanh@gmail.com',N'Thu Kho')
--5.Thực hiện log Backup
backup log QLBanhHang to disk='D:\bk\QLBH.trn'