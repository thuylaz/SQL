create database triggerhd

go
use triggerhd
go

create table hang(
	mahang nvarchar(20) not null primary key,
	tenhang varchar(20),
	sl int,
	gia int
)

create table hoadon(
	mahd nvarchar(10) not null primary key,
	mahang nvarchar(20) not null,
	slb int,
	ngayban datetime,
	constraint fk_hd_h foreign key(mahang)
	references hang(mahang)
)

create trigger trg_insert_hoadon
on hoadon
for insert
as
begin
if(not exists(select *from hang join inserted
				on hang.mahang=inserted.mahang))
begin 
raiserror('loi khong co hang',16,1)
rollback transaction
end
else
begin
declare @sl int
declare @slb int
select @sl=sl from hang join inserted
on hang.mahang= inserted.mahang
select @slb=inserted.slb
from inserted
if(@sl<@slb)
begin
raiserror('ban khong du hang',16,1)
rollback transaction
end
else
update hang set sl=sl-@slb
from hang join inserted
on hang.mahang=inserted.mahang
end
end

select * from hang
select * from hoadon
insert into hoadon values(1,3,25,'2/9/1999')