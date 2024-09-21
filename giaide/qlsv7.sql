create database qlsv7

go
use qlsv7
go

create table khoa(
	mak nchar(10) not null primary key,
	tenk nchar(20),
	sdt int
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
	gioi nchar(20),
	ngays datetime,	
	mal nchar(10) not null,
	constraint fk_l_s foreign key(mal)
	references lop(mal)
)

insert into khoa values
('k1', 'cntt', 949494),
('k2', 'kt', 75757),
('k3', 'nn', 646464)

insert into lop values
('l4', 'nna', 85, 'k3'),
('l1', 'sql', 45, 'k1'),
('l2', 'qtkd', 70, 'k2'),
('l3', 'nna', 75, 'k3')

insert into sv values
('sv7', 'trang','nu', '03-14-2006', 'l4'),
('sv1', 'thuy','nu', '03-22-2006', 'l1'),
('sv2', 'nhung','nu', '10-25-2006', 'l2'),
('sv3', 'thien','nam', '07-07-2006', 'l3'),
('sv4', 'lan','nu', '12-06-2006', 'l2'),
('sv5', 'trang','nu', '03-14-2006', 'l1')

--ham
create function a(@tk nchar(20))
returns @bang table(
					mal nchar(10),
					tenl nchar(20),
					siso int)
as
begin
	insert into @bang
	select mal, tenl, siso from lop join khoa
	on lop.mak=khoa.mak
	where @tk=tenk
	return 
end

select *from dbo.a('cntt')

--thu tuc
create proc b(@msv nchar(10), @ht nchar(20), @gt nchar(20), @ns datetime, @tl nchar(20))
as
begin
	if(not exists(select *from lop where @tl=tenl))
		print('loi k co lop nay')
	else
		begin
			declare @ml nchar(10)
			select @ml=mal from lop
			insert into sv values(@msv,@ht,@gt,@ns,@ml)
		end
end

--k thuc thi
exec b 'sv6', 'mai','nu', '12-06-2006', 'sqll'

--thuc thi
exec b 'sv6', 'mai','nu', '12-06-2006', 'sql'

--trigger
create trigger c
on sv
for update
as
begin
	declare @sstrc int
	set @sstrc=(select siso from lop join deleted
					on lop.mal=deleted.mal)
	declare @sss int
	set @sss=(select siso from lop join inserted
					on lop.mal=inserted.mal)
	if(@sstrc>=80)
		begin
			raiserror('loi k cap nhat',16,1)
			rollback tran
		end
	else
		begin
			update lop set siso= @sstrc-1
			from lop join deleted
			on lop.mal=deleted.mal
			update lop set siso= @sss+1
			from lop join inserted
			on lop.mal=inserted.mal
		end
end

--k thuc thi
update sv set mal='l4' where masv='sv7'

--thuc thi
select *from lop
select *from sv
update sv set mal='l3' where masv='sv2'
select *from lop
select *from sv