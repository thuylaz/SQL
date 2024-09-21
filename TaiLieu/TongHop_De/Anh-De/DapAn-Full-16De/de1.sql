use master
go
if (exists(select * from sysdatabases where name='QLSinhVien'))
	drop database QLSinhVien
go
create database QLSinhVien
	on primary(name='QLSinhVien_dat',filename='E:\qlsinhvien.mdf',size=5MB,maxsize=10MB,filegrowth=20%)
	log on(name='QLSinhVien_log',filename='E:\qlsinhvien.ldf',size=1MB,maxsize=5MB,filegrowth=1MB)
go
use QLSinhVien 
go

create table Khoa
(
	makhoa int primary key,
	tenkhoa nvarchar(100) not null
)
go
create table Lop
(
	malop int not null primary key,
	tenlop nvarchar(100) not null,
	siso int,
	makhoa int,
	constraint fk_1 foreign key(makhoa) references Khoa(makhoa) on update cascade on delete cascade
)
go
create table SinhVien
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
insert into Khoa values(2,'Kinh Te')
insert into Khoa values(3,'DienTu')
go
insert into Lop values(1,'HTTT1',4,1)
insert into Lop values(2,'Du lich',79,2)
insert into Lop values(3,'CNTT1',83,1)
GO 
insert into SinhVien values(1,'Pham Ngoc Hoan','10/02/1997',1,1)
insert into SinhVien values(2,'Nguyen Thi My Linh','10/02/1997',0,1)
insert into SinhVien values(3,'Tang Thi Linh','10/02/1997',0,1)
insert into SinhVien values(4,'Vu Thi Thu','10/02/1997',0,1)
insert into SinhVien values(5,'Tran Thi Xuan','10/02/1997',0,2)
insert into SinhVien values(6,'Ho Sy Hau','10/02/1997',1,2)
insert into SinhVien values(7,'Nguyen thi ngoc anh','10/02/1997',0,2)
go
select * from Khoa
select * from Lop
select *from SinhVien
go
-- cau 2:
create view cau_2
AS
	SELECT dbo.Khoa.tenkhoa,MAX(mycount) AS 'solop'
	FROM dbo.Khoa,(select k.makhoa,k.tenkhoa,COUNT(l.malop) as mycount
	from Khoa k inner join Lop l on k.makhoa=l.makhoa
	group by k.makhoa,k.tenkhoa
	)AS t
	GROUP BY dbo.Khoa.tenkhoa
GO 

select * from cau_2

GO
select k.makhoa,k.tenkhoa,COUNT(l.malop) as mycount
	INTO newtable
	from Khoa k inner join Lop l on k.makhoa=l.makhoa
	group by k.makhoa,k.tenkhoa
SELECT * FROM newtable n WHERE n.mycount =
(SELECT Min(mycount) FROM newtable)

SELECT x.tenkhoa,x.makhoa,MAX(x.mycount) AS 'So lop'
FROM ( select k.makhoa,k.tenkhoa,COUNT(l.malop) as mycount
	from Khoa k inner join Lop l on k.makhoa=l.makhoa
	group by k.makhoa,k.tenkhoa
	) AS x
	GROUP BY  x.tenkhoa,x.makhoa

-- cau 3:


GO 
CREATE function cau_3(@makhoa int)
returns @cau_3 table
(masv int,hoten nvarchar(50),ngaysinh date,tenlop nvarchar(100),tenkhoa nvarchar(100),gioitinh nvarchar(5))
as
	BEGIN
    /*
	declare @gt_1 varchar(10)
	declare @gt_2 varchar(10)
	set @gt_1='Nu'
	set @gt_2='Nam'
	*/

	insert into @cau_3
	select masv,hoten,ngaysinh,tenlop,tenkhoa, CASE gioitinh
	WHEN 0 THEN N'Nữ'
	WHEN 1 THEN N'Nam'
	END 
	 from SinhVien inner join Lop 
	on SinhVien.malop=Lop.malop
	inner join Khoa on Lop.makhoa=Khoa.makhoa
	where Khoa.makhoa =@makhoa 
		return
	end
go
select * from cau_3(1)
GO 
-- trigger

CREATE TRIGGER cau4
ON dbo.SinhVien
FOR INSERT 
AS 
BEGIN
	
	DECLARE @malop INT = (SELECT malop FROM Inserted)
	DECLARE @siso INT =(SELECT siso FROM dbo.Lop WHERE malop=@malop)
	IF (@siso>80)
	BEGIN
		RAISERROR(N'Quá sĩ số cho phép là 80 người',16,1)
		ROLLBACK TRANSACTION
	END 
	ELSE 
	BEGIN 
		UPDATE dbo.Lop
		SET Lop.siso=@siso+1
		WHERE malop=@malop
	END 
END 
/*
GO 
CREATE TRIGGER cau_4
ON dbo.SinhVien
FOR INSERT
AS 
	BEGIN
		DECLARE @masv INT = (SELECT i.masv FROM Inserted i)
		DECLARE @malop INT =(SELECT i.malop FROM Inserted i)
		DECLARE @siso INT = (SELECT siso FROM dbo.Lop WHERE malop=@malop)
		IF (@siso>80) 
			BEGIN
				RAISERROR(N'Quá sĩ số cho phép',16,1)
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
*/
SELECT * FROM dbo.Lop
SELECT * FROM dbo.SinhVien
GO 
--test1
INSERT INTO SinhVien VALUES(10,N'Trần Hưng Đạo','10/10/1997',1,1) 
GO
SELECT * FROM dbo.Lop
SELECT * FROM dbo.SinhVien
GO  
--test2
INSERT INTO SinhVien VALUES(14,N'Trần Văn Đạo','10/10/1997',1,3) 
GO 
SELECT * FROM dbo.Lop
SELECT * FROM dbo.SinhVien
GO 
/*
DECLARE @date DATE
DECLARE @day NVARCHAR(20)
declare @wd INT
set @date = '2017-11-22'
PRINT(datepart(weekday,@date))
--set @wd = case when datepart(weekday,@date)<2 then 7-datepart(weekday,@date) else  datepart(weekday,@date)-2 END
SET @wd = DATEPART(WEEKDAY,@date)
SET @day = CASE @wd
 WHEN 2 THEN 'Monday'
WHEN  3 THEN 'Tuesday'
WHEN  4 THEN 'Wednesday'
WHEN 5 THEN 'Thursday'
WHEN  6 THEN 'Friday'
WHEN  7 THEN 'Saturday'
WHEN 8 THEN 'Sunday'
END 
PRINT(@day)

 END 
select DATEADD(day, -@wd,@date) As Monday,
DATEADD(day, 1-@wd,@date) As Tuesday,
DATEADD(day, 2-@wd,@date) As Wednesday,
DATEADD(day, 3-@wd,@date) As Thusday,
DATEADD(day, 4-@wd,@date) As Friday,
DATEADD(day, 5-@wd,@date) As Saturday,
DATEADD(day, 6-@wd,@date) As Sunday

*/
