--Thực hiện full Backup
Backup Database QLBanHang to disk = 'd:\bk\QLBH.bak'
--Thêm dữ liệu cho bảng NHANVIEN
Insert Into NHANVIEN Values ('NV04', N'Mai Hạnh Phúc', N'Nữ', N'Hà Nam','0928272722','phuc@gmail.com',N'Kế toán') 
--Thực hiện different Backup
Backup Database QLBanHang to disk = 'D:\bk\QLBH_Diff.bak' with differential 
--Tiếp tục thêm dữ liệu cho bảng NHANVIEN
Insert Into NHANVIEN Values ('NV05', N'Sau Bất Hạnh', N'Nữ', 'Bắc Giang','0998282828','hanh@gmail.com',N'Thủ Kho')
--Thực hiện log Backup 
Backup log QLBanHang to disk = 'D:\bk\QLBH.trn'