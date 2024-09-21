create database qlmuonsach116

go
use qlmuonsach116
go

create table docgia(
	madg nchar(10) not null primary key,
	tendg nchar(20),
	dc nchar(20),
	sodt int
)

create table sach(
	mas nchar(10) not null primary key,
	tens nchar(20),
	sl int,
	nhaxb nchar(20),
	namxb int
)

create table phieumuon(	
	mapm nchar(10) not null,
	mas nchar(10) not null,
	madg nchar(10) not null,
	slm int, 
	ngaym datetime,
	constraint fk_pm_s foreign key(mas)
	references sach(mas),
	constraint fk_pm_dg foreign key(madg)
	references docgia(madg)
)

insert into docgia values
('dg1', 'thuy', 'nd', 7777),
('dg2', 'nhung', 'hn', 8888),
('dg3', 'thien', 'hy', 77779)


insert into sach values
('s1', 'kd', 200, 'kim dong', 2003),
('s2', 'tt', 250, 'nha1', 2002),
('s3', 'tn', 270, 'nha2',2004)

insert into phieumuon values
('p1', 's1', 'dg1',4, '03-22-2006'),
('p2', 's2', 'dg2',5, '03-21-2006'),
('p2', 's3', 'dg3',6, '03-29-2006'),
('p1', 's2', 'dg2',10, '03-18-2006'),
('p3', 's3', 'dg1',12, '03-7-2006')

--ham
create function a(@mdg nchar(10))
returns int
as 
begin
	declare @tong int
	set @tong=(select sum(slm) from sach join phieumuon
					on sach.mas=phieumuon.mas
					join docgia on docgia.madg=phieumuon.madg
					where @mdg=phieumuon.madg
					group by phieumuon.madg)
	return @tong
end

select dbo.a('dg1')

--proc 
create proc b(@mpm nchar(10), @ts nchar(20), @tdg nchar(20), @slm int, @nm datetime)
as
begin
	if(not exists(select *from sach where @ts=tens))
		print('loi k co sach')
	else
		if(not exists(select *from docgia where @tdg=tendg))
		print('loi k co doc gia')
	else 
		begin
			declare @ms nchar(10)
			select @ms=mas from sach
			declare @mdg nchar(10)
			select @mdg=madg from docgia
			insert into phieumuon values(@mpm,@ms,@mdg,@slm,@nm)
		end
end

--k thuc thi
exec b 'p4', 'kd', 'thhuy',6, '03-29-2006'

--thuc thi
exec b 'p4', 'kd', 'thuy',6, '03-29-2006'

--trigger
create trigger c
on phieumuon
for delete
as
begin
	declare @slmm int
	select @slmm= slm from deleted
	update sach set sl=sl+@slmm
	from sach join deleted
	on sach.mas=deleted.mas
	where sach.mas=deleted.mas
end

select *from sach
select *from phieumuon
delete from phieumuon where mapm='p1'
select *from sach
select *from phieumuon