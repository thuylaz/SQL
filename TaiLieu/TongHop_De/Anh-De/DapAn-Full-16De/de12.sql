use master
go
if(exists (select *from sysdatabases where  name ='Quanlisach'))
drop database Quanlisach
go
create database Quanlisach
on primary (name='Quanlisach_dat', filename='E:\Quanlisach.mdf',size=5MB, maxsize=10MB, filegrowth=20%)
log on (name='Quanlisach_log', filename='E:\Quanlisach.ldf',size=1MB, maxsize=5MB, filegrowth=1MB)
go
use Quanlisach
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
	hotendg NVARCHAR(100) not null
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
go
insert into pm values(1,'12/2/2017','nguyen ngoc anh')
insert into pm values(2,'1/6/2017','nguyen thi my linh')
go
insert into sachmuon values(1,2,30)
insert into sachmuon values(2,2,10)
insert into sachmuon values(1,1,5)
--insert into sachmuon values(2,1,3)
go
select*from sach
select*from pm
select*from sachmuon
go

--cau2: dua ra sach muon qua han--
select count(sach.masach) as sosach from pm inner join sachmuon on pm.mapm=sachmuon.mapm inner join sach on sach.masach=sachmuon.masach
where datediff(day,ngaymuon,GETDATE())>songaymuon
GO 
-- câu 3:

GO 
CREATE FUNCTION cau3(@masach INT)
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @tensach NVARCHAR(100)
	SELECT @tensach= dbo.sach.tensach
	FROM sachmuon INNER JOIN sach ON sach.masach = sachmuon.masach
	WHERE sach.masach=@masach
	GROUP BY dbo.sach.masach,tensach
	HAVING COUNT(dbo.sachmuon.masach)>1
	RETURN @tensach
END 
GO
-- test câu 3:
GO 
SELECT dbo.cau3(1) AS N'Tên sách'
GO 
-- câu 4:
GO 
CREATE TRIGGER cau4
ON dbo.pm
FOR INSERT
AS
BEGIN
	DECLARE @ngay  DATE = (SELECT Inserted.ngaymuon FROM Inserted)
	DECLARE @kt DATE = FORMAT(GETDATE(),'yyyy-MM-dd')
	IF (@ngay!=@kt) 
	BEGIN 
		RAISERROR(N'Ngày mượn không bằng ngày hiện tại',16,1)
		ROLLBACK TRANSACTION
	END 
	ELSE 
		PRINT(N'Được phép thêm phiếu mượn')
END 
GO 
-- test câu 4: 
GO 
SELECT * FROM dbo.pm
GO 
INSERT INTO pm VALUES(10,'12-08-2017',N'Hồ Sỹ Hậu')
INSERT INTO pm VALUES(11,'11-08-2017',N'Hoàng xuân')
GO
SELECT * FROM dbo.pm
    