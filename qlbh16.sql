create database qlbh16

go
use qlbh16
go

create table sp(
	masp nchar(10) not null primary key,
	tensp nchar(20),
	sl int,
	dg int,
	mau nchar(20)
)

create table nhap(
	sohdn nchar(10) not null primary key,
	masp nchar(10) not null,
	ngayn datetime,
	sln int,
	dgn int,
	constraint fk_n_s foreign key(masp)
	references sp(masp)
)

create table xuat(
	sohdx nchar(10) not null primary key,
	masp nchar(10) not null,
	ngayx datetime,
	slx int,
	constraint fk_x_s foreign key(masp)
	references sp(masp)
)

insert into sp values
('s1', 'but', 50, 2000, 'do'),
('s2', 'thuoc', 43, 5000, 'xanh'),
('s3', 'ban', 72, 7000, 'den'),
('s4', 'ghe', 86, 23000, 'vang'),
('s5', 'bang', 83, 22000, 'nau')

insert into nhap values
('n1', 's1', '02-07-2022', 34, 2500),
('n2', 's3', '02-07-2022', 45, 4000),
('n3', 's5', '02-07-2022', 52, 11000)

insert into xuat values
('x1', 's1', '03-07-2022', 20),
('x2', 's3', '04-07-2022', 22),
('x3', 's5', '05-07-2022', 23)

--thu tuc
create proc a(@shdx nchar(10), @msp nchar(10), @ngay datetime, @slxx int)
as
begin
	if(not exists(select *from sp where masp=@msp))
		print('khong co san pham nay')
	else
		begin
			insert into xuat values
			(@shdx, @msp, @ngay, @slxx)
		end
end

--k thuc thi
exec a 'x4', 's6', '03-07-2022', 20
select *from xuat

--thuc thi
exec a 'x4', 's2', '03-07-2022', 20
select *from xuat

--trigger
create trigger b
on xuat
for insert
as
begin
	if(not exists(select *from sp join inserted
						on inserted.masp=sp.masp
						where inserted.masp=sp.masp))
		begin
			raiserror('k co sp nay',16,1)
			rollback transaction
		end
	else
		begin
			declare @sll int
			declare @slxx int
			set @sll=(select sl from sp join inserted
							on sp.masp=inserted.masp
							where sp.masp=inserted.masp)
			set @slxx=(select slx from inserted)
			if(@slxx>@sll)
				begin
					raiserror('slx>=sl',16,1)
					rollback transaction
				end
			else
				begin
					update sp set sl=sl-@slxx
					from sp join inserted
					on sp.masp=inserted.masp
					where sp.masp=inserted.masp
				end
		end

end

drop trigger tr

--k thuc thi
select *from sp
select *from xuat
insert into xuat values('x5', 's1', '03-07-2022', 20)
select *from sp
select *from xuat


create proc tt(@shdx nchar(10), @msp nchar(10), @ngayxx datetime, @slxx int)
as
begin
	if(not exists(select *from sp where masp= @msp))
		print('loi k co san pham')
	else
		insert into xuat values(@shdx, @msp, @ngayxx, @slxx)
end

drop proc tt
exec tt 'x6', 's2', '03-07-2022', 20
select *from xuat

create trigger tr
on xuat
for insert
as
begin
	declare @msp nchar(10) 
	select @msp=masp from inserted
	declare @slxx int
	select @slxx=slx from inserted
	declare @sll int
	select @sll= sl from sp
	declare @slxc int
	select @slxc=slx from deleted
	if(not exists(select *from sp where masp=@msp))
		begin
			raiserror('loi k co san pham',16,1)
			rollback tran
		end
	else
		if(@slxx>=@sll)
			begin
				raiserror('loi k co san pham',16,1)
				rollback tran
			end
	else 
		begin
		update sp set sl=sl-@slxx from sp join inserted
			on sp.masp=inserted.masp
		end
end

select *from sp
select *from xuat
insert into xuat values('x8', 's2', '03-07-2022', 10)
select *from sp
select *from xuat