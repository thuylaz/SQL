use master
go
create database QLBHang
use QLBHang
go

create table mathang
(mahang char(4) not null primary key,
tenhang nvarchar(100) not null,
soluong int not null
)
drop table mathang

create table nhatkibanhang
(stt int not null primary key identity(1,1),
ngay date not null,
nguoimua nvarchar(100) not null,
giaban float not null,
mahang char(4) not null,
soluong int not null,
constraint fk1 foreign key (mahang) references mathang(mahang)
)
drop table nhatkibanhang

insert into mathang
(mahang, tenhang, soluong)
values	(1, 'keo', 100),
		(2, 'banh', 200),
		(3, 'thuoc', 100);

insert into nhatkibanhang
(ngay, nguoimua, mahang, soluong, giaban)
values ('1999-02-09', 'ab', 2, 230, 50000);

select * from mathang
select * from nhatkibanhang
 
--cau a
drop trigger trg_nhatkibanhang_insert
create trigger trg_nhatkibanhang_insert
on nhatkibanhang
for insert
as 
update mathang
set mathang.soluong = mathang.soluong - inserted.soluong
from mathang inner join inserted
on mathang.mahang = inserted.mahang


delete from mathang
delete from nhatkibanhang

--test
select * from mathang
select * from nhatkibanhang
insert into nhatkibanhang(ngay, nguoimua, mahang, soluong, giaban)
values ('1999-02-09', 'ab', '2', 30, 50000)
select * from mathang
select * from nhatkibanhang

disable trigger  trg_nhatkibanhang_insert
on nhatkibanhang
enable trigger trg_nhatkibanhang_insert
on nhatkibanhang

--cau b
create trigger trg_nhatkibanhang_update_soluong
on nhatkibanhang
for update
as
	if	update(soluong)
		update mathang
		set mathang.soluong = mathang.soluong - (inserted.soluong - deleted.soluong)
		from (deleted inner join inserted on deleted.stt = inserted.stt)
		inner join mathang 
		on mathang.mahang = deleted.mahang


--test
disable trigger  trg_nhatkibanhang_update_soluong
on nhatkibanhang
enable trigger trg_nhatkibanhang_update_soluong
on nhatkibanhang

select * from mathang
select * from nhatkibanhang
update nhatkibanhang set soluong = soluong + 20
where stt=11
select * from mathang
select * from nhatkibanhang

--cau c
create trigger trg_nhatkibanhang_insert
on nhatkibanhang
for insert 
as begin
	declare @sl_co int /*so luong hang hien co*/
	declare @sl_ban int /*so luong hang duoc ban*/
	declare @mahang nvarchar(5) /*ma hang duoc ban*/
	select @mahang = mahang from inserted
	select @sl_ban= soluong from inserted
	-- set @mahang=inserted.mahang, @sl_ban=inserted.soluong
	select @sl_co = soluong from mathang where mahang = @mahang
	if (@sl_co < @sl_ban)
		raiserror(N'So luong ban lon hon so luong co!',16,1)
		rollback transaction
	else
		update mathang set soluong = soluong - @sl_ban where mahang = @mahang
	end
drop trigger trg_nhatkibanhang_insert

--test 
disable trigger  trg_nhatkibanhang_insert
on nhatkibanhang
enable trigger trg_nhatkibanhang_insert
on nhatkibanhang

select * from mathang
select * from nhatkibanhang
insert into nhatkibanhang(ngay, nguoimua, mahang, soluong, giaban)
values('02/09/1999', 'cd', '3', 200, 120)
select * from mathang
select * from nhatkibanhang

--cau d
create trigger trg_update_nhatkibanhang
on nhatkibanhang
for update 
as
	begin
		declare @mahang nvarchar(5) 
		declare @truoc int
		declare @sau int
		if(select count(*) from inserted) > 1
		begin
			raiserror ('khong duoc sua qua 1 dong lenh', 16,1)
			rollback tran
			return
		end
		else
			if update (soluong)
				begin
					select @truoc = soluong from deleted
					select @sau = soluong from inserted
					select @mahang = mahang from inserted
					update mathang set soluong = soluong - (@sau-@truoc)
					where mahang = @mahang
				end
	end

--test 
disable trigger trg_update_nhatkibanhang
on nhatkibanhang
enable trigger trg_update_nhatkibanhang
on nhatkibanhang

--cau e
create trigger trg_nhatkibanhang_delete
on nhatkibanhang
for delete
as
	begin
		declare @mahang nvarchar(5)
		declare @truoc int
		declare @sau int
		if(select count(*) from deleted) > 1
		begin
			raiserror ('khong xoa duoc',16,1)
			rollback tran
			return
		end
		else
			if update(soluong)
				begin
					select @truoc = soluong from deleted
					select @sau = soluong from inserted
					select @mahang = mahang from inserted
					update mahang set soluong=soluong-(@sau-@truoc)
					where mahang = @mahang
				end
	end

--test
disable trigger trg_nhatkibanhang_delete
on nhatkibanhang
enable trigger trg_nhatkibanhang_delete
on nhatkibanhang

--cau f
create trigger trg_nhatkibanhang2_update
on nhatkibanhang
for update 
as
	begin
		declare @mahang int 
		declare @truoc int
		declare @sau int
		declare @sl_co int
		declare @sl_ban int
		select @mahang = mahang, @sl_ban = soluong from inserted
		select @sl_co = soluong from mathang
		where mahang = @mahang
		if(select count(*) from deleted) > 1
		begin
			raiserror ('khong can cap nhat',16,1)
			rollback tran
			return
		end
		else
			if (@sl_co < @sl_ban)
				begin
					raiserror ('khong du so luong',16,1)
					rollback tran
					return
				end
			if update(soluong)
				begin
					select @truoc = soluong from deleted
					select @sau = soluong from inserted
					select @mahang = mahang from inserted
					update mahang set soluong=soluong-(@sau-@truoc)
					where mahang = @mahang
				end
	end

--test
disable trigger trg_nhatkibanhang2_update
on nhatkibanhang
enable trigger trg_nhatkibanhang2_update
on nhatkibanhang