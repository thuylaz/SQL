create database QLSach2

GO
USE QLSach2
GO

CREATE TABLE TacGia (
	MaTG CHAR(5) PRIMARY KEY, 
	TenTG NVARCHAR(30), 
	SoLuongCo INT
)

CREATE TABLE NhaXB (
	MaNXB CHAR(5) PRIMARY KEY, 
	TenNXB NVARCHAR(30), 
	SoLuongCo INT
)

CREATE TABLE Sach (
	MaSach CHAR(5) PRIMARY KEY, 
	TenSach NVARCHAR(30), 
	MaNXB CHAR(5), 
	MaTG CHAR(5), 
	NamXB INT, 
	SoLuong INT, 
	DonGia MONEY, 
	CONSTRAINT fk_nxb FOREIGN KEY (MaNXB) REFERENCES NhaXB(MaNXB),
	CONSTRAINT fk_tg FOREIGN KEY (MaTG) REFERENCES TacGia(MaTG)
)

INSERT INTO TacGia VALUES
('TG01', N'Nguyễn Đình Huân', 20),
('TG02', N'Nguyễn Đình Huân 2', 30),
('TG03', N'Nguyễn Đình Huân 3 ', 40)

INSERT INTO NhaXB VALUES
('NXB01', N'Nhi Đồng', 10),
('NXB02', N'Thiếu niên', 15),
('NXB03', N'Tin tức', 20)

INSERT INTO Sach VALUES
('S01', N'Sách 01', 'NXB01', 'TG01', 2020, 11, 20000),
('S02', N'Sách 02', 'NXB02', 'TG01', 2019, 10, 21000),
('S03', N'Sách 03', 'NXB02', 'TG02', 2018, 9, 22000),
('S04', N'Sách 04', 'NXB02', 'TG02', 2021, 8, 23000),
('S05', N'Sách 05', 'NXB03', 'TG03', 2020, 7, 24000)

SELECT * FROM TacGia
SELECT * FROM NhaXB
SELECT * FROM Sach


--thu tuc
create proc a(@mas char(5), @tens nvarchar(30), @tnxb nvarchar(30), @mtg char(5), @nxb int, @sl int, @dg money)
as
begin
	if(not exists(select *from NhaXB where TenNXB=@tnxb))
		print('khong co nxb nay')
	else
		begin
		declare @mnxb char(5)=(select MaNXB from NhaXB where TenNXB=@tnxb)
		insert into Sach
		values(@mas, @tens, @mnxb, @mtg, @nxb, @sl, @dg)
		end
end

drop proc a
EXEC a 'S06', N'Sách 06', N'Nhi Đồng 1', 'TG01', 2021, 9, 100000
SELECT * FROM Sach

EXEC a 'S06', N'Sách 06', N'Nhi Đồng', 'TG01', 2021, 9, 100000
SELECT * FROM Sach
--trigger
create trigger b
on Sach
for insert
as
begin
	if(not exists(select *from inserted join NhaXB
					on NhaXB.MaNXB=inserted.MaNXB))
		begin
			raiserror('ma nxb chua co',16,1)
			rollback transaction
		end
	else
		begin
			update NhaXB
			set SoLuongCo=SoLuongCo+(select SoLuong from inserted)
			where MaNXB=(select MaNXB from inserted)
		end
end

ALTER TABLE Sach NOCHECK CONSTRAINT ALL
INSERT INTO Sach VALUES ('S07', N'Sách 07', 'NXB08', 'TG03', 2020, 7, 24000)
SELECT * FROM NhaXB
SELECT * FROM Sach

create trigger a
on Sach
for insert
as
begin
	if(not exists(select *from inserted join NhaXB
					on inserted.MaNXB=NhaXB.MaNXB))
		begin
			raiserror('nha xb k co',16,1)
			rollback transaction
		end
	else
		begin
			update NhaXB set SoLuongCo=SoLuongCo+(select SoLuongCo from inserted)
			where MaNXB=(select MaNXB from inserted)
		end
end


