create database BanHang
go 
use BanHang
go
create table Hang(	
	MaHang char(10) primary key, 
	TenHang nvarchar(20) not null,
	SoLuong int not null,
	GiaBan money not null
)
go
create table HoaDon(
	MaHD char(10),
	MaHang char(10) not null foreign key(MaHang) references Hang(MaHang) on update cascade
	on delete cascade,
	SoLuongBan int not null,
	NgayBan date not null
)
go

insert into Hang values ('H01', 'Bim bim', 10000, 5000), 
						('H02', 'Xúc xích', 5000, 5000),
						('H03', 'Mì tôm', 3000, 5000),
						('H04', 'Nước Lavie', 5000, 5000),
						('H05', 'Bánh ngọt', 1000, 5000)
go
insert into HoaDon values	('001', 'H02', 3000, '2022/5/21'),
							('003', 'H05', 600, '2022/5/20'),
							('005', 'H01', 8000, '2022/5/21')
go

select * from Hang
select * from HoaDon
--Phiếu 1
/*Hãy tạo 1 trigger insert HoaDon, hãy kiểm tra xem mahang cần mua có tồn 
tại trong bảng HANG không, nếu không hãy đưa ra thông báo.
 - Nếu thỏa mãn hãy kiểm tra xem: soluongban <= soluong? Nếu không hãy đưa 
ra thông báo.
 - Ngược lại cập nhật lại bảng HANG với: soluong = soluong - soluongban */
 create trigger trg_insert_HoaDon
 on HoaDon
 for insert
 as
 begin
 if(not exists(select * from Hang inner join inserted
				on Hang.MaHang=inserted.MaHang))
	begin 
		raiserror('Lỗi. Không có hàng',16,1)
		rollback transaction
	end 
 else
	begin
		declare @soluong int
		declare @soluongban int
		select @soluong=SoLuong from Hang inner join inserted 
		on Hang.MaHang=inserted.MaHang

		select @soluongban=inserted.SoLuongBan
		from inserted 

	if(@soluong = @soluongban)
		begin
			raiserror('Bán không dư hàng', 16, 1)
			rollback transaction
		end
	else
		update Hang set SoLuong=Soluong-@soluongban
		from Hang inner join inserted 
		on Hang.MaHang=inserted.MaHang
	end
end

select * from Hang
select * from HoaDon
insert into HoaDon values(1,3,25,'2/9/1999')

--Phiếu 2

/* Viết trigger kiểm soát việc Delete bảng HOADON, Hãy cập nhật lại 
soluong trong bảng HANG với: SOLUONG =SOLUONG + 
DELETED.SOLUONGBAN */
create trigger trg_delete_HoaDon
on HoaDon
for delete
as
begin
	update Hang set SoLuong=SoLuong+ deleted.SoLuongBan
	from Hang inner join deleted 
	on Hang.MaHang=deleted.MaHang
end

select * from Hang
select * from HoaDon
delete from HoaDon where MaHD='HD01'
/* Hãy viết trigger kiểm soát việc Update bảng HOADON. Khi đó hãy
update lại soluong trong bảng HANG*/
create trigger trg_update_HoaDon
on HoaDon
for update 
as
begin
	declare @sltruoc int
	declare @slsau int
	select @sltruoc=deleted.SoLuongBan from deleted
	select @slsau=inserted.SoLuongBan from inserted
	update Hang set SoLuong=SoLuong-(@slsau-@sltruoc)
	from Hang inner join inserted 
	on inserted.MaHang=Hang.MaHang
end

select * from Hang
select * from HoaDon
update HoaDon set SoLuongBan=SoLuongBan+5
where MaHang='H01'