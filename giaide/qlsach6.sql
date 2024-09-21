create database qlsach6d

go
use qlsach6d
go

create table tacgia(
	matg nchar(10) not null primary key,
	tentg nchar(20)
)

create table nxb(
	manxb nchar(10) not null primary key,
	tennxb nchar(20)
)

create table sach(
	masach nchar(10) not null primary key,
	tensach nchar(20),
	sl int,
	gia money,	
	matg nchar(10) not null,
	manxb nchar(10) not null,
	constraint fk_s_tg foreign key(matg)
	references tacgia(matg),
	constraint fk_s_n foreign key(manxb)
	references nxb(manxb)
)

insert into tacgia values
('tg1', 'thuy'),
('tg2', 'nhung'),
('tg3', 'thien')

insert into nxb values
('nxb1', 'samsung'),
('nxb2', 'oppo'),
('nxb3', 'apple')

insert into sach values
('s6', 'cartoon33', 150, 22000, 'tg2', 'nxb1'),
('s1', 'cartoon1', 30, 2000, 'tg1', 'nxb1'),
('s2', 'drama2', 50, 25000, 'tg3', 'nxb2'),
('s3', 'cartoon2', 70, 3000, 'tg2', 'nxb2'),
('s4', 'drama1', 90, 4000, 'tg3', 'nxb3'),
('s5', 'cartoon3', 130, 22000, 'tg2', 'nxb1')

--ham
create function a(@ttg nchar(20), @tnxb nchar(20))
returns int
as
begin
	declare @tong int
	set @tong=(select sum(sl) from sach join tacgia
				on sach.matg= tacgia.matg
				join nxb on nxb.manxb=sach.manxb
				where @ttg=tentg and @tnxb=tennxb
				group by tentg,tennxb)
	return @tong
end
select dbo.a('nhung','samsung')

--thu tuc
create proc b(@tnxb nchar(20), @kq int out)
as
begin
	if(not exists(select *from nxb where @tnxb=tennxb))
		set @kq=0
	else
		begin
			set @kq=1
			declare @tongtien money
			set @tongtien=(select sum(sl*gia) from sach join nxb
			on sach.manxb=nxb.manxb
			where @tnxb=tennxb
			group by tennxb)
			print 'tong tien sach cua nxb '+ @tnxb + convert(char(10),@tongtien)
		end
end

declare @bien int
exec b 'samsung', @bien out
select @bien

--trigger
CREATE TRIGGER tg_cau4
ON sach
FOR INSERT
AS
BEGIN
	DECLARE @mtg nchar(10) = (SELECT matg FROM inserted)
	DECLARE @mnxb nchar(10) = (SELECT manxb FROM inserted)

	IF(NOT EXISTS(SELECT * FROM tacgia WHERE matg = @mtg))
		BEGIN 
			RAISERROR(N'Không có mã tác giả này', 16, 1)
			ROLLBACK TRAN
		END
	ELSE IF(NOT EXISTS(SELECT * FROM nxb WHERE manxb = @mnxb))
		BEGIN 
			RAISERROR(N'Không có mã nhà xuất bản này', 16, 1)
			ROLLBACK TRAN
		END
END
drop trigger tg_cau4
insert into sach values('s7', 'cartoon13', 130, 22000, 'tg2', 'nxb1')
select *from sach

--k thanh cong
INSERT INTO sach VALUES ('s44', N'Sách 1', 21, 250000, 'tttt', 'n7')

create trigger cau4
on sach
for insert
as
	begin
		if(not exists(select * from tacgia inner join inserted on tacgia.matg=inserted.matg where tacgia.matg=inserted.matg))
			begin
				raiserror(N'tg khong ton tai',16,1)
				rollback transaction
			end
		else
			begin
				if(not exists(select * from nxb inner join inserted on nxb.manxb=inserted.manxb
				where nxb.manxb=inserted.manxb))
					begin
						raiserror(N'nxb khong ton tai',16,1)
						rollback transaction
					end
				else
					begin
						print(N'them moi thanh cong')
					end
			end
	end


insert into sach values('s7', 'cartoon13', 130, 22000, 'tg2', 'nxb1')
INSERT INTO sach VALUES ('s44', N'Sách 1', 21, 250000, 'tttt', 'n7')


