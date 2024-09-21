create database qlsv3

go
use qlsv3
go

create table khoa(
	mak nchar(10) not null primary key,
	tenk nchar(20),
)

create table lop(
	mal nchar(10) not null primary key,
	tenl nchar(20),
	siso int,
	mak nchar(10) not null,
	constraint fk_l_k foreign key(mak)
	references khoa(mak)
)

create table sv(
	masv nchar(10) not null primary key,
	hoten nchar(20),
	ngays datetime,
	gioi bit,
	mal nchar(10) not null,
	constraint fk_l_s foreign key(mal)
	references lop(mal)
)

insert into khoa values
('k1', 'cntt'),
('k2', 'kt'),
('k3', 'nn')

insert into lop values
('l1', 'sql', 45, 'k1'),
('l2', 'qtkd', 70, 'k2'),
('l3', 'nna', 75, 'k3')

insert into sv values
('sv1', 'thuy', '03-22-2006',1, 'l1'),
('sv2', 'nhung', '10-25-2006',1, 'l2'),
('sv3', 'thien', '07-07-2006',0, 'l3'),
('sv4', 'lan', '12-06-2006',1, 'l2'),
('sv5', 'trang', '03-14-2006',1, 'l1')

--ham
create function a(@tk nchar(20))
returns @bang table(
					masv nchar(10),
					hoten nchar(20),
					ngays datetime,
					tuoi int)
as
begin
	insert into @bang
	select masv, hoten, ngays, year(getdate())-year(ngays) 
	from sv join lop
	on sv.mal=lop.mal
	join khoa on khoa.mak=lop.mak
	where @tk=tenk
	return
end

select *from dbo.a('cntt')

--thu tuc
create proc b(@tutuoi int, @dentuoi int)
as
begin
	select masv, hoten, tenk, year(getdate())-year(ngays)
	from sv join lop
	on sv.mal=lop.mal
	join khoa on khoa.mak=lop.mak
	where year(getdate())-year(ngays) between @tutuoi and @dentuoi
end

exec b 10, 20

--trigger
create trigger c
on sv
for insert, delete
as
begin
	declare @action char(1)
	set @action= (case when exists(select *from inserted) then 'I'
						when exists(select *from deleted) then 'D'
						end)
	--xoa
	if(@action='D')
		begin
			update lop
			set siso=siso-1
			where mal=(select mal from deleted)
		end
	else
		begin
			declare @ss int
			set @ss= (select siso from lop join inserted on lop.mal=inserted.mal)
			if(@ss>80)
				begin
					declare @lop nchar(20)
					set @lop= (select tenl from lop join inserted on lop.mal=inserted.mal)
					declare @noti nchar(100)
					set @noti= 'k the them sv vao lop '+ @lop
					raiserror(@noti,16,1)
					rollback tran
				end
			else
				begin
					update lop set siso=siso+1
					where mal= (select mal from inserted)
				end
		end
end

insert into sv values('sv6', 'thien', '07-07-2006',0, 'l4')