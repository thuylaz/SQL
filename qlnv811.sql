create database qlnv811

go 
use qlnv811
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


--c1
create proc nhap_nv(@mnv nvarchar(4), @mcv nvarchar(2), @tnv nvarchar(30), @ngay datetime, @l float, @ngayc int, @phuc float)
as
begin 
	if(not exists(select *from cv where macv=@mcv))
		print(N'ma chuc vu khong ton tai')
	else 
		begin
			insert into nv 
			values(@mnv, @mcv, @tnv, @ngay, @l, @ngayc, @phuc)
		end
end

exec nhap_nv 'NV06', 'KT', N'Nguyễn Thu Huyền', '1978-12-25', 400000, 26, 300000

select *from nv

--c2
create proc nhap(@mnv nvarchar(4), @mcv nvarchar(2), @tnv nvarchar(30), @ngay datetime, @l float, @ngayc int, @phuc float)
as
begin
	if(not exists(select *from cv where macv=@mcv))
		print(N'ma chuc vu khong ton tai')
	else 
		update nv
		set macv= @mcv,
		tennv= @tnv,
		ngaysinh=@ngay,
		luong=@l,
		phucap=@phuc
		where manv=@mnv
end

exec nhap 'NV03', 'GD', N'Nguyễn Hải Nam', '1978-12-15', 400000, 27, 300000
select * from nv

--c3
create proc luong
as
begin
	select tennv, luong*ngaycong+phucap as 'luong ln'
	from nv
end

exec luong