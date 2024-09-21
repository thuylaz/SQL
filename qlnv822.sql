create database qlnv822

go 
use qlnv822
go

create table cv(
	macv nvarchar(2) not null primary key,
	tencv nvarchar(30)
)

create table nv(
	manv nvarchar(4) not null primary key,
	macv nvarchar(2) not null,
	tennv nvarchar(30),
	ngaysinh datetime,
	luong float,
	ngaycong int,
	phucap float,
	constraint fk_nhan_chuc foreign key(macv)
	references cv(macv)
)

insert into cv 
values('BV', N'Bảo Vệ'),
('GD', N'Giám Đốc'),
('HC', N'Hành Chính'),
('KT', N'Kế Toán'),
('TQ', N'Thủ Quỹ'),
('VS', N'Vệ Sinh')

insert into nv
values('NV01', 'GD', N'Nguyễn Văn An', '1977-12-12', 700000, 25, 500000),
('NV02', 'BV', N'Bùi Văn Tí', '1978-10-10', 400000, 24, 100000),
('NV03', 'KT', N'Trần Thanh Nhật', '1977-09-09', 600000, 26, 400000),
('NV04', 'VS', N'Nguyễn Thị Út', '1980-10-10', 300000, 26, 300000),
('NV05', 'HC', N'Lê Thị Hà', '1979-10-10', 500000, 27, 200000)

--1
create proc a(@mnv nvarchar(4), @mcv nvarchar(2), @tnv nvarchar(30), @ngay datetime, @l float, @ngayc int, @phuc float, @trave int out)
as
begin
	if(not exists(select *from cv where macv=@mcv))
		set @trave=0
	else 
		begin
			insert into nv 
			values(@mnv, @mcv, @tnv, @ngay, @l, @ngayc, @phuc)
		end
		return @trave
end

declare @bien1 int
exec a 'NV06', 'KT', N'Phạm Minh Đức', '1977-02-14', 300000, 25, 200000, @bien1 out
select @bien1

select *from nv

--2
create proc b(@mnv nvarchar(4), @mcv nvarchar(2), @tnv nvarchar(30), @ngay datetime, @l float, @ngayc int, @phuc float, @trave int out)
as
begin
	if(not exists(select *from cv where macv=@mcv))
		set @trave=1
	else
		if(exists(select *from nv where manv=@mnv))
			set @trave=0
	else
		begin
			insert into nv 
			values(@mnv, @mcv, @tnv, @ngay, @l, @ngayc, @phuc)
		end
end

declare @bien2 int
exec b 'NV08', 'BV', N'Lê Phương Thảo', '2003-03-04', 200000, 23, 150000, @bien2 out
select @bien2

select *from nv

--c3
create proc c(@mnv nvarchar(4), @ngay datetime, @trave int out)
as
begin
	if(not exists(select *from nv where manv=@mnv))
		set @trave=0
	else 
		begin
		update nv
		set ngaysinh=@ngay
		where manv=@mnv
		end

end

declare @bien3 int
exec c 'NV04', '1996-11-25', @bien3 out
select @bien3

select *from nv
