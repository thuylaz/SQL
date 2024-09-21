create database qlbh1011

go
use qlbh1011
go

create table hang(
	mah int not null primary key,
	tenh nchar(20),
	sl int
)

create table nkbh(
	stt int not null primary key,
	ngay datetime,
	nguoimua nchar(20),
	mah int not null,
	slb int,
	gia money,
	constraint fk_nkb_mah foreign key(mah)
	references hang(mah)
)

insert into hang values
(1, 'Keo', 100),
(2, 'Banh', 200),
(3, 'Thuoc', 100)

insert into nkbh values
(1, '1999-02-09', 'ab', 2, 230, 50),
(3, '2020-10-05', 'xy', 1, 20, 40),
(5, '2021-08-21', 'Nam', 3, 10, 70)


--a
create trigger a
on nkbh
for insert 
as
	update hang
	set hang.sl=hang.sl-inserted.slb
	from hang join inserted
	on hang.mah=inserted.mah

select *from hang
select *from nkbh

insert into nkbh(stt, ngay, nguoimua, mah, slb, gia) 
values(2,'1999-02-09', 'ab', 2, 30, 50)

--a
create trigger a
on nkbh
for insert 
as
	update hang
	set hang.sl=hang.sl-inserted.slb
	from hang join inserted
	on hang.mah=inserted.mah


--b
create trigger b
on nkbh
for update
as
	declare @trc int
	declare @sau int
	select @trc= slb from deleted
	select @sau= slb from inserted
	if(@sau<>@trc)
		begin
		update hang
		set hang.sl=hang.sl-(@sau-@trc)
		from inserted,deleted
		where deleted.mah=hang.mah
		and inserted.stt=deleted.stt
		end


select *from hang
select *from nkbh

update nkbh set slb=slb+20 where stt=1
select *from hang
select *from nkbh

--c
create trigger c
on nkbh
for insert 
as
begin
	declare @slco int
	declare @slban int
	declare @mahang nchar(10)
	select @mahang=mah, @slban=slb from inserted
	select @slco=sl from hang where mah=@mahang
	if(@slco<@slban)
	rollback transaction
	else
	update hang set sl=sl-@slban where mah=@mahang
end

--d
create trigger d
on nkbh 
for update
as
begin	
	declare @mahang nchar(10)
	declare @trc int
	declare @sau int
	if(select count(*) from inserted)>1
	begin
	raiserror('khong duoc sua qua 1 dong lenh',16,1)
	rollback transaction
	end
	else
	if update(sl)
	begin
	select @trc=slb from deleted
	select @sau=slb from inserted
	select @mahang=mah from inserted
	update hang set sl=sl-(@sau-@trc)where mah=@mahang
	end
end

--e
create trigger e
on nkbh
for delete
as
begin
	declare @mahang nchar(10)
	if(select count(*) from deleted)>1
		begin
			raiserror('khong the xoa >1 ban ghi',16,1)
			rollback transaction
		end
	else
		begin
		--lay ma hang cua ban ghi da xoa
		select @mahang=mah from deleted

		--cap nhat bang hang voi sl tang
		update hang set sl=sl+1
		where mah=@mahang

		--xoa ban ghi trong nkbh
		delete from nkbh
		where mah=@mahang
		end
end

--f
create trigger f
on nkbh
for update
as
begin
	if(select count(*) from inserted)>1
		begin
			raiserror('khong the cap nhat > 1 ban ghi',16,1)
			rollback transaction
		end
	else
		begin
			declare @slcn int
			declare @slco int
			set @slcn=(select slb from inserted)
			set @slco=(select sl from hang join inserted
						on hang.mah=inserted.mah)
			if(@slcn<@slco)
				begin
					raiserror('loi cap nhat',16,1)
					rollback transaction
				end
			else
				if(@slcn=@slco)
					begin
						raiserror('k can cap nhat',16,1)
						rollback transaction
					end
			else
				begin
					update nkbh set slb=@slcn
					from nkbh join inserted
					on nkbh.mah=inserted.mah
				end
		end
end


select *from hang
select *from nkbh
update nkbh set slb=110 where mah=1
select *from hang
select *from nkbh

--g
create proc g(@mahang int)
as
begin
	if(not exists(select *from hang where mah=@mahang))
		print('hang nay khong ton tai')
	else
		begin
			delete from nkbh
			where mah=@mahang
			delete from hang
			where mah=@mahang
		end
end

exec g 3
select *from hang
select *from nkbh

--h
create function h(@tenhang nchar(20))
returns money
as
begin
	declare @tongtien money
	set @tongtien=(
				select sum(nkbh.slb*gia)
				from nkbh join hang
				on nkbh.mah=hang.mah
				where tenh=@tenhang
				group by hang.mah,tenh)
			return @tongtien
end

select dbo.h('Banh')
