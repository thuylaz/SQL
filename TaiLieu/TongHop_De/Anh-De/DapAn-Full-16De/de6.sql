use master
go
if(exists(select * from sysdatabases where name='QLsv'))
	drop database QLsv
go
create database QLsv
on primary(name='QLsv_dat',filename='E:\QLSsv.mdf',size=5MB,maxsize=10MB,filegrowth=20%)
log on(name='QLsv_log',filename='E:\QLsv.ldf',size=1MB,maxsize=5MB,filegrowth=1MB)
go
use QLsv
go
create table Khoa
(
	makhoa int primary key,
	tenkhoa nvarchar(100) not null
)
GO 
create table Lop
(
	malop int not null primary key,
	tenlop nvarchar(100) not null,
	siso int,
	makhoa int,
	constraint fk_1 foreign key(makhoa) references Khoa(makhoa) on update cascade on delete cascade
)
GO 

create table Sinhvien
(	
	masv int not null primary key,
	hoten nvarchar(50),
	ngaysinh date,
	gioitinh bit,
	malop int,
	constraint fk_2 foreign key(malop) references Lop(malop) on update cascade on delete cascade
)
go
insert into Khoa values(1,'CNTT')
insert into Khoa values(2,'Kinh te')
go
insert into Lop values(1,'HTTT1',40,1)
insert into Lop values(2,'du lich',43,2)
go
insert into Sinhvien values(1,'Pham Ngoc Hoan','2/2/1998',1,1)
insert into Sinhvien values(2,'Vu Thi Thu','2/2/1996',0,1)
insert into Sinhvien values(3,'Tang Thi Linh','2/2/1996',0,1)
insert into Sinhvien values(4,'Nguyen Thi My Linh','2/2/1997',0,1)
insert into Sinhvien values(5,'Ho Sy Hau','2/2/1999',1,2)
insert into Sinhvien values(6,'Tran Thi Xuan','2/2/1998',0,2)
insert into Sinhvien values(7,'Nguyen Ngoc Anh','2/2/1997',0,2)
go

select * from Khoa
select * from Lop
select * from Sinhvien
go

-------cau2
create view cau2
as
select Sinhvien.masv,Sinhvien.hoten,MIN(year(getdate())-YEAR(Sinhvien.ngaysinh)) as 'Tuoi'
from Sinhvien
where year(getdate())-YEAR(Sinhvien.ngaysinh)=(select MIN(year(getdate())-YEAR(Sinhvien.ngaysinh)) from Sinhvien)
group by Sinhvien.masv,Sinhvien.hoten
GO
--test câu 2:
select * from cau2

--câu 3:
GO 
CREATE PROCEDURE cau_3(@tutuoi int ,@dentuoi int)
AS
BEGIN 

	SELECT dbo.Sinhvien.masv,dbo.Sinhvien.hoten,dbo.Sinhvien.ngaysinh,dbo.LOP.TenLop,Khoa.TenKhoa,YEAR(GETDATE())-YEAR(ngaysinh) AS N'Tuổi'
	FROM dbo.Sinhvien INNER JOIN dbo.LOP ON LOP.MaLop = Sinhvien.malop
	INNER JOIN dbo.KHOA ON KHOA.MaKhoa = LOP.MaKhoa
	WHERE YEAR(GETDATE())-YEAR(ngaysinh) BETWEEN @tutuoi AND @dentuoi
END 
GO 
-- test câu 3:
EXEC dbo.cau_3 @tutuoi = 20, -- int
    @dentuoi = 30 -- int

-- câu 4:
GO 
CREATE TRIGGER cau4
ON sinhvien 
FOR INSERT 
AS 
BEGIN
	DECLARE @malop INT = (SELECT malop FROM Inserted)
	DECLARE @siso INT =(SELECT siso FROM dbo.Lop WHERE malop=@malop)
	IF (@siso>80)
	BEGIN
		RAISERROR(N'sĩ số đã quá 80 người rồi',16,1)
		ROLLBACK TRANSACTION
	END 
	ELSE 
	BEGIN
		UPDATE dbo.Lop
		SET siso=@siso+1
		WHERE malop=@malop
	END 
END 
GO 
--test cau 4:
SELECT * FROM dbo.Sinhvien
SELECT * FROM dbo.Lop
GO 
INSERT INTO sinhvien VALUES(10,N'Nguyen trai','10-10-1845',1,1)
GO 
SELECT * FROM dbo.Sinhvien
SELECT * FROM dbo.Lop


