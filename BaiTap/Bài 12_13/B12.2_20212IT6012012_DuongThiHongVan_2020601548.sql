/*
các loại sao lưu dữ liệu
Loại 1: Full Backup
Cu phap:
Backup Database Ten_CSDL to disk ='Duong dan\Ten_file.bak'
VD:
Backup Database QuanLyBanHang to disk = 'd:\bk\QLBH.bak'

Loai 2:DIfferent Backup
Cu phap:
Backip Database Ten_CSDL to disk = 'Duong dan \Ten_File.bak' with differential
VD:
Backip Database QuanLyBanHang to disk='D:\sql\QLBH_Diff.bak' whith differential

Loai 3: Log Backup
Ci phap:
Backup log Ten_CSDL to disk='Duong_dan\Ten_file.trm'
VD:
BAckup log QuanLyQUanHang to disk='D:\sql\QLBH.trn'


Phuc hoi(Restore)
Phuc hoi du lieu tu ban full va different Backup
	Cu phap:
	Restore Database Ten_CSDL from disk='Duong dan \ten_File.bak'[With Norecovery]

Phuc hoi du lieu tu ban log Backup
	Cu phap:
	Restore log Ten_CSDL from disk='Duog dan\Ten_File.trn'[With Norecovery]


Sao lưu dữ liệu của CSDL QLBanHang
--Thực hiện full Backup
Backup Database QLBanHang to disk='d:\bk\QLBH.bak'
--Thêm dữ xlieeuj cho bảng NHANVIEN
insert into NHANVIEN values('NV04',N'Mai Hanh Phuc', N'Nu',N'Ha Nam', '028938127','Thuy@gmail.com',N'Ke toan')
--thuc hien different Backup
Backup Database QLBAnHang to disk='D:\bk\QLBH_Diff.bak' with differential
--Tiếp tục thêm dũ lieu cho bảng NHANVIEN
insert into NHANVIEN values('NV05',N'Sau Bat Hanh', N'Nu',N'Bac Giang', '028933127','Thu@gmail.com',N'Thu Kho')
--Thực hiện log Backup
Backup log QLBanHang to disk='D:\bk\QLBH.trn'


PHỤC HỒI DỮ LIỆU CHO CSDL QLBanHang 
--Khôi phục dữ liệu từ full Backup
restore log QuanLyBanHang From disk='D"\bk\QLBH.bak' With Norecovery
--Khôi phục dữ liệu từ different Backup
Restore Database QuanLyBanHang from disk='D:\bk\QLBH_Diff.bak' With Norecovery
--Khôi phục dữ liệu từ log Backup
Restore log QLBangHang from disk='D:bk\QLBH.trn'
*/