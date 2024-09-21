create database qlsach14598

go
use qlsach14598
go

create table tacgia(
	matg char(10) not null primary key,
	tentg nchar(20),
	slco int
)

create table nxb(
	manxb nchar(10) not null primary key,
	tennxb nchar(20),
	slco int
)

create table sach(
	masach char(10) not null primary key,
	tensach nchar(20),
	manxb nchar(10) not null,
	matg char(10) not null,
	namxb int,
	sl int,
	gia money,
	constraint fk_s_tg foreign key(matg)
	references tacgia(matg),
	constraint fk_s_n foreign key(manxb)
	references nxb(manxb)
)

insert into tacgia values
('tg1', 'thuy', 400),
('tg2', 'nhung', 500),
('tg3', 'thien', 700),
('tg4', 'lan', 800)

insert into nxb values
('nxb1', 'samsung', 20),
('nxb2', 'oppo', 15),
('nxb3', 'apple', 17),
('nxb4', 'redmi', 18)

insert into sach values
('s1', 'cartoon1', 'nxb1', 'tg1', 2018, 30, 2000),
('s2', 'drama2', 'nxb2', 'tg3', 2020, 50, 25000),
('s3', 'cartoon2', 'nxb4', 'tg2', 2019, 70, 3000),
('s4', 'drama1', 'nxb3', 'tg4', 2018, 90, 4000),
('s5', 'cartoon3', 'nxb1', 'tg2', 2017, 130, 22000)

--thu tuc
create proc a(@ms nchar(10), @ts nchar(20), @tnxb nchar(20), @mtg nchar(10), @sll int, @g money)
as
begin
	if(not exists(select *from nxb where tennxb=@tnxb))
		print('loi k co nxb nay')
	else
		begin
			declare @mnxb nchar(10)
			select @mnxb=manxb from nxb 
			declare @nam nchar(10)
			select @nam=namxb from sach 
			insert into sach values(@ms,@ts,@mnxb, @mtg,@nam,@sll,@g)
		end
end

--k thuc thi
exec a 's6', 'drama3', 'hghgh', 'tg3', 40, 25000
select *from sach

--thuc thi
exec a 's6', 'drama3', 'samsung', 'tg3', 40, 25000
select *from sach

--ham
create function b(@ttg nchar(20))
returns int
as
begin
	declare @tongtien int
	set @tongtien= (select sl*gia from sach join tacgia
						on sach.matg=tacgia.matg
						where @ttg=tentg)
	return @tongtien
end

select dbo.b('thuy')

--trigger
create trigger c
on sach
for insert
as
begin
	if(not exists(select *from inserted join nxb on nxb.manxb=inserted.manxb))
		begin 
			raiserror('loi k co nxb',16,1)
			rollback tran
		end
end
drop trigger c
--k thuc thi
ALTER TABLE Sach NOCHECK CONSTRAINT ALL
insert into sach values('s8', 'drama2', 'nxb778', 'tg3', 2020, 50, 25000)
select *from nxb
select *from sach

--thuc thi
ALTER TABLE Sach NOCHECK CONSTRAINT ALL
insert into sach values('s9', 'drama2', 'nxb2', 'tg3', 2020, 50, 25000)
select *from nxb
select *from sach
