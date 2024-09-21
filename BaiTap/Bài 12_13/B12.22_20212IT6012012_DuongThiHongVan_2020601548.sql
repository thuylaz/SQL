--Hãy thực hiện Restore  dữ liệu
--1.Khôi phục dữ liệu từ full Backup
Restore Database QuanLyBanHang From disk='D:bk\QLBH.bak' with Norecovery
--2.Khôi phục dũ liệu từ different Backup
Restore Database QuanLyBanHang From disk='D:D:bk\QLBH.Diff.bak' with Norecovery
--3.Khôi phục dữ liệu từ log Backup
Restore log QLBanHang From disk='D:\bk\QLBH.trn'

