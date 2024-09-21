create database qlsv22

go
use qlsv22
go

create table khoa(
	mak nchar(10) not null primary key,
	tenk nchar(20),
	ngaytl datetime
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
	mal nchar(10) not null,
	constraint fk_l_s foreign key(mal)
	references lop(mal)
)

insert into khoa values
('k1', 'cntt', '09-22-2003'),
('k2', 'kt', '10-01-2003'),
('k3', 'nn', '02-22-2003')

insert into lop values
('l1', 'sql', 45, 'k1'),
('l2', 'qtkd', 70, 'k2'),
('l3', 'nna', 75, 'k3')

insert into sv values
('sv1', 'thuy', '03-22-2006', 'l1'),
('sv2', 'nhung', '10-25-2006', 'l2'),
('sv3', 'thien', '07-07-2006', 'l3'),
('sv4', 'lan', '12-06-2006', 'l2'),
('sv5', 'trang', '03-14-2006', 'l1')

--c2
create function a(@tk nchar(20))
returns @bang table(
					mal nchar(10),
					tenl nchar(20),
					siso int
					)
as
begin
	insert into @bang
	select mal, tenl, siso from lop join khoa
	on lop.mak=khoa.mak
	where @tk=tenk
	return
end

select *from dbo.a('cntt')

--c3
create proc b(@msv nchar(10), @ht nchar(20), @ngay datetime, @ml nchar(10), @tl nchar(20))
as
begin
	if(not exists(select *from lop where tenl=@tl))
		print('loi k co lop')
	else
		begin
		insert into sv
		values(@msv,@ht,@ngay,@ml)
		end
end

drop proc b
exec b 'sv6', 'thuy', '03-22-2006', 'l1', 'sql'
select *from sv

--c4
create trigger c
on sv
for update
as
begin
	declare @ml nchar(10)
	declare @ss int
	select mal=@ml from inserted
	select siso from lop join inserted
	on lop.mal=inserted.mal
	where @ss=siso from inserted
	if update(mal)
		begin
			update lop set siso=siso-1 where mal=@ml
			if(select siso from lop where mal=@ml)>=80
				begin
					raiserror('loi k dc cap nhat',16,1)
					rollback tran
				end
		end
end

drop trigger cau4
select *from sv
update sv set mal='l2' where masv='sv5'
select *from lop
select *from sv


create trigger cau4
on sv
for update
as
	begin
		declare @sisosau int
		set @sisosau=(select siso from lop inner join inserted on lop.mal=inserted.mal
		where lop.mal=inserted.mal)
		if(@sisosau>=80)
			begin
				raiserror(N'Khong the cap nhat do lop vuot qua 80 nguoi',16,1)
				rollback transaction
			end
		else
			begin
				declare @sisotrc int
				set @sisotrc=(select siso from lop inner join deleted on lop.mal=deleted.mal
				where lop.mal=deleted.mal)
				update lop set siso=siso-1 from lop inner join deleted on lop.mal=deleted.mal
				where lop.mal=deleted.mal
				update lop set siso=siso+1 from lop inner join inserted on lop.mal=inserted.mal
				where lop.mal=inserted.mal
			end
	end

update sv set mal='l3' where masv='sv2'
select *from lop
select *from sv

create trigger c
on sv
for update
as
begin
	declare @sssau int
	set @sssau= (select siso from lop join inserted on lop.mal=inserted.mal
					where lop.mal=inserted.mal)
	if(@sssau>=80)
		begin
			raiserror('loi k the cap nhat',16,1)
			rollback tran
		end
	else
		declare @sstrc int
		set @sstrc
end