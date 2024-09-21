use master
go
if(exists (select *from sysdatabases where  name ='QLh'))
drop database QLh
go
create database QLh
on primary (name='QLh_dat', filename='E:\QLh.mdf',size=5MB, maxsize=10MB, filegrowth=20%)
log on (name='QLh_log', filename='E:\QLh.ldf',size=1MB, maxsize=5MB, filegrowth=1MB)
go
use QLh
go
create table hang
(
	mahang int primary key,
	tenhang char(50)not null,
	dvtinh char(20) not null,
	slton int not null,
)
go
create table hdban
(
	mahd int primary key,
	ngayban date,
	hotenkh char(100) not null,
)
go
create table hangban
(
	mahd int,
	mahang int,
	dongia float,
	soluong int,
	constraint pk primary key (mahd, mahang),
	constraint fk1 foreign key (mahd) references hdban(mahd) on update cascade on delete cascade,
	constraint fk2 foreign key (mahang) references hang(mahang) on update cascade on delete cascade,
)
go
insert into hang values (1,'ghe','chiec',200)
insert into hang values (2,'ban','chiec',100)
go
insert into hdban values(1,'1/1/2000','nguyen ngoc anh')
insert into hdban values(2,'1/2/2001','vu thi thu')
insert into hdban values(3,'1/2/2017','nguyen thi my linh')
go
insert into hangban values(1,2,3000,20)
insert into hangban values(2,2,4000,50)
insert into hangban values(1,1,300,10)
insert into hangban values(2,1,5000,20)
 go
 select *from hang
 select*from hdban
 select*from hangban
go
--cau2--
create view cau2
as
select hangban.mahd,ngayban, SUM(dongia*soluong)as tongtien
from hangban inner join hdban on hangban.mahd=hdban.mahd
group by  hangban.mahd,ngayban
GO
--test câu 2:
select*from cau2
GO 
-- câu 3:
CREATE FUNCTION cau3(@nam int)
RETURNS INT
AS 
BEGIN
	DECLARE @tongtien INT =0
	SELECT @tongtien = SUM(dongia*soluong) 
	FROM dbo.hangban INNER JOIN dbo.HDBan ON HDBan.mahd = hangban.mahd
	WHERE YEAR(ngayban)=@nam
	GROUP BY YEAR(ngayban)
	RETURN @tongtien
END 
GO 
-- test câu 3:
SELECT dbo.cau3(2000) AS 'Tổng tiền'
GO 
--câu 4:
CREATE TRIGGER cau4
ON dbo.HangBan
FOR INSERT
AS
	BEGIN 

		DECLARE @mahang INT = (SELECT i.mahang FROM Inserted i)
		DECLARE @soluongt INT =(SELECT slton FROM dbo.Hang WHERE dbo.Hang.mahang=@mahang)
		DECLARE @soluong INT = (SELECT i.soluong FROM Inserted i)

		IF (@soluong>@soluongt)
		BEGIN
			RAISERROR(N'Số lượng phải nhỏ hơn số lượng tồn',16,1)
			ROLLBACK TRANSACTION
		END
		ELSE 
		BEGIN
			UPDATE dbo.Hang
			SET slton=@soluongt-@soluong
			WHERE mahang=@mahang
			PRINT N'Thành công update'
		END 
	END
 GO 

 SELECT * FROM  dbo.Hang
 SELECT * FROM dbo.HangBan
 GO 
insert into HangBan values(3,1,3000,8)
GO 
SELECT * FROM dbo.Hang
SELECT * FROM dbo.HangBan
