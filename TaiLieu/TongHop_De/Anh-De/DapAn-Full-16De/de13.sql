use master
go
if(exists (select *from sysdatabases where  name ='Qlsach'))
drop database Qlsach
go
create database Qlsach
on primary (name='Qlsach_dat', filename='E:\Qlsach.mdf',size=5MB, maxsize=10MB, filegrowth=20%)
log on (name='Qlsach_log', filename='E:\Qlsach.ldf',size=1MB, maxsize=5MB, filegrowth=1MB)
go
use Qlsach
go
create table sach
(
	 masach int primary key,
	 tensach char(100) not null,
	 sotrang int not null,
	 soluongton int not null
)
go
create table pm
(
	mapm int primary key,
	ngaymuon date,
	hotendg char(100) not null
)
go
create table sachmuon
(
	mapm int,
	masach int,
	songaymuon int not null,
	constraint pk primary key (mapm,masach),
	constraint pk1 foreign key (mapm) references pm(mapm) on update cascade on delete cascade,
	constraint pk2 foreign key (masach) references sach(masach) on update cascade on delete cascade
)
go
insert into sach values(1,'doraemon',200,20)
insert into sach values(2,'conan',250,30)
insert into sach values(3,'Who moved my chesse',250,30)
go
insert into pm values(1,'1/2/2017','nguyen ngoc anh')
insert into pm values(2,'1/08/2017','nguyen thi my linh')
go
insert into sachmuon values(1,2,30)
insert into sachmuon values(2,2,10)
insert into sachmuon values(1,1,5)
insert into sachmuon values(2,1,3)
go
select*from sach
select*from pm
select*from sachmuon
GO
-- câu 2:
SELECT  dbo.Sach.masach,dbo.Sach.tensach
FROM dbo.sachmuon INNER JOIN dbo.PM ON PM.mapm = sachmuon.mapm
INNER JOIN dbo.Sach ON Sach.masach = sachmuon.masach
WHERE DATEDIFF(DAY,ngaymuon,GETDATE())>songaymuon
GROUP BY dbo.Sach.masach,dbo.Sach.tensach

GO 
-- câu 3:
CREATE FUNCTION cau3(@masach INT)
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @tensach NVARCHAR(100)
	IF (NOT EXISTS(SELECT * FROM dbo.sachmuon WHERE masach=@masach))
	BEGIN
		SELECT @tensach = tensach FROM dbo.Sach WHERE masach=@masach
	END 
	ELSE SET @tensach=N'tất cả đều được mượn'
	RETURN @tensach
END 
GO
-- test câu 3:
GO 
SELECT dbo.cau3(3) AS N'Tên sách'
GO 
-- câu 4:
GO 
CREATE TRIGGER cau4
ON dbo.sachmuon
FOR INSERT 
AS
BEGIN 
	DECLARE @masach INT = (SELECT masach FROM Inserted)
	DECLARE @mapm INT = (SELECT mapm FROM Inserted)
	DECLARE @soluongt INT  = (SELECT soluongton FROM dbo.Sach WHERE masach=@masach)
	IF(EXISTS(SELECT * FROM dbo.PM WHERE mapm=@mapm))
	BEGIN
		IF (EXISTS(SELECT * FROM dbo.Sach WHERE masach=@masach))
			UPDATE dbo.Sach
			SET soluongton=@soluongt-1
			WHERE masach=@masach
		ELSE IF(NOT EXISTS(SELECT * FROM dbo.Sach WHERE masach=@masach))
			BEGIN
				RAISERROR(N'Mã sách không tồn tại',16,1)
				ROLLBACK TRANSACTION
			END 
	END 
	ELSE IF(NOT EXISTS(SELECT * FROM dbo.PM WHERE mapm=@mapm))
	BEGIN 
		PRINT N'mã không tồn tại'
		RAISERROR(N'mã phiếu mượn không tồn tại',16,1)
		ROLLBACK TRANSACTION
	END 
end
GO 
--test c4:
GO
SELECT * FROM dbo.sachmuon
SELECT * FROM dbo.Sach
GO 
INSERT INTO sachmuon VALUES(1,3,30)
INSERT INTO sachmuon VALUES(11,3,30)
GO 
SELECT * FROM dbo.sachmuon
SELECT * FROM dbo.Sach