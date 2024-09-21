create database hang101

go
use hang101
go

create table hang(
	mah nchar(10) not null primary key,
	tenh nchar(20),
	sl int,
	gia money
)

create table hoadon(
	mahd nchar(10) not null primary key,
	mah nchar(10) not null,
	slb int,
	ngayb datetime,
	constraint fk_hd_h foreign key(mah)
	references hang(mah)
)

insert into hang values
('h1', 'ban', 4, 20000),
('h2', 'ghe', 12, 260000),
('h3', 'but', 14, 520000),
('h4', 'vo', 64, 770000)

insert into hoadon values
('hd1', 'h1', 1, '03-05-2018'),
('hd2', 'h3', 5, '03-05-2018'),
('hd3', 'h4', 8, '03-05-2018'),
('hd4', 'h2', 4, '03-05-2018'),
('hd5', 'h1', 2, '03-05-2018')


--trigger
create trigger a
on hoadon
for insert 
as
begin
	if(not exists(select *from hang join inserted
					on hang.mah=inserted.mah))
						begin
							raiserror('loi khong co hang',16,1)
							rollback transaction
						end
	else
		begin
			declare @sll int
			declare @slbb int
			select @sll= sl from hang join inserted 
					on hang.mah=inserted.mah
			select @slbb= inserted.slb from inserted
			if(@sll<@slbb)
				begin
					raiserror('ban khong du hang', 16,1)
					rollback transaction
				end
			else
				update hang set sl=sl- @slbb
				from hang join inserted
				on hang.mah=inserted.mah
		end
end

insert into hoadon values('hd299', 'h99', 5, '03-05-2018')

select *from hang
select *from hoadon

--phieu 2
--c1
create trigger a2
on hoadon
for delete
as
begin
	update hang set sl=sl+ deleted.slb
	from hang join deleted
	on hang.mah=deleted.mah
	where hang.mah=deleted.mah
end

delete from hoadon where mahd='hd2'

select *from hang
select *from hoadon



--c2
create trigger b
on hoadon
for update 
as
begin
	declare @trc int
	declare @sau int

	select @trc = deleted.slb from deleted
	select @sau = inserted.slb from inserted
	update hang set sl=sl-(@sau-@trc)
	from hang join inserted on hang.mah=inserted.mah
end

update hoadon set slb=slb-1 where mah='h2'

select *from hang
select *from hoadon


