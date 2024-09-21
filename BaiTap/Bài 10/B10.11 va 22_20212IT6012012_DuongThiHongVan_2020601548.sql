create database QLBH10
go
use QLBH10
go
create table MatHang(
	MaHang int primary key,
	TenHang nvarchar(20),
	SoLuong int
)
go
create NhatKyBanHang(
	STT int primary key,
	Ngay date,
	NguoiMua nvarchar(20),
	MaHang int foreign key(MaHang) references MatHang(MaHang) on update cascade on delete cascade,
	SoLuong int ,
	GiaBan money
)go
insert into MatHang values  (1, 'Keo', 100),
							(2, 'Banh', 200),
							(3, 'Thuoc', 100)
go
insert into NhatKyBanHang values  (1,'1999-02-09','ab',2,230,50000)
go
select * from MatHang
select * from NhatKyBanHang

/* a. trg_nhatkybanhang_insert. Trigger này có chức năng tự động giảm số lượng 
hàng hiện có (Trong bảng MATHANG) khi một mặt hàng nào đó được bán (tức 
là khi câu lệnh INSERT được thực thi trên bảng NHATKYBANHANG). */
create trigger  trg_nhatkybanhang_insert
on NHATKYBANHANG
for insert
as
begin
	update MATHANG set SoLuong=MATHANG.SoLuong-inserted.SoLuong
	from MATHANG inner join inserted on MATHANG.MaHang=inserted.MaHang
end
---goi trigger
select*from MATHANG
select*from NHATKYBANHANG
insert into NHATKYBANHANG values(2,'2020-02-19','ac',1,5,20000)

/* b. trg_nhatkybanhang_update_soluong được kích hoạt khi ta tiến hành cập nhật 
cột SOLUONG cho một bản ghi của bảng NHATKYBANHANG (lưu ý là chỉ
cập nhật đúng một bản ghi) */
create trigger trg_nhatkybanhang_update_soluong2
on NHATKYBANHANG
for update
as
begin
	if update(SoLuong)
		update MATHANG set MATHANG.SoLuong=MATHANG.SoLuong-(inserted.SoLuong-deleted.SoLuong)
		from MATHANG inner join deleted on deleted.MaHang=MATHANG.MaHang
		inner join inserted on inserted.MaHang=MATHANG.MaHang
end
--go thu tuc
select*from MATHANG
select*from NHATKYBANHANG
update NHATKYBANHANG set SoLuong=SoLuong+2 where STT=2

/* c. Trigger dưới đây được kích hoạt khi câu lệnh INSERT được sử dụng để bổ sung 
một bản ghi mới cho bảng NHATKYBANHANG. Trong trigger này kiểm tra
điều kiện hợp lệ của dữ liệu là số lượng hàng bán ra phải nhỏ hơn hoặc bằng số
lượng hàng hiện có. Nếu điều kiện này không thoả mãn thì huỷ bỏ thao tác bổ
sung dữ liệu */
create trigger cauc
on NHATKYBANHANG
for insert
as
begin
	declare @slco int
	declare @slban int
	select @slco=SoLuong from MATHANG
	select @slban=SoLuong from inserted
	if(@slco<@slban)
		rollback transaction
	else
		update	MATHANG set MATHANG.SoLuong=MATHANG.SoLuong-inserted.SoLuong
		from MATHANG inner join inserted on MATHANG.MaHang=inserted.MaHang
end
---goi trigger
select*from MATHANG
select*from NHATKYBANHANG
--TH:so luong co <so luong ban
insert into NHATKYBANHANG values(4,'2020-12-23','ad',3,200,10000)
---TH: so luong co >so luong ban
insert into NHATKYBANHANG values(3,'2020-12-23','ad',3,5,10000)

/* d. Trigger dưới đây nhằm để kiểm soát lỗi update bảng nhatkybanhang, nếu update 
>1 bản ghi thì thông báo lỗi(Trigger chỉ làm trên 1 bản ghi), quay trở về. Ngược 
lại thì update lại số lượng cho bảng mathang. */

create trigger caud
on NHATKYBANHANG
for update 
as
begin
	if(select count(*) from inserted)>1
		begin
			raiserror(N'Không được cập nhật quá 1 bản ghi',16,1)
			rollback transaction
			return
		end
	else
		if update(SoLuong)
			update MATHANG set MATHANG.SoLuong=MATHANG.SoLuong-(inserted.SoLuong-deleted.SoLuong)
			from MATHANG inner join deleted on deleted.MaHang=MATHANG.MaHang
			inner join inserted on inserted.MaHang=MATHANG.MaHang
end

---goi trigger
select*from MATHANG
select*from NHATKYBANHANG
--Th cap nhat >1 ban ghi
update NHATKYBANHANG set SoLuong=SoLuong+10 where STT=2 or STT=1
--TH cap nhat 1ban ghi
update NHATKYBANHANG set SoLuong=SoLuong+10 where STT=2

/* e. Hãy tao Trigger xoa 1 ban ghi bang nhatkybanhang, neu xoa nhieu hon 1 record 
thi hay thong bao loi xoa ban ghi, nguoc lai hay update bang mathang voi cot so 
luong tang len voi ma hang da xoa o bang nhatkybanhang. */
create trigger caue
on NHATKYBANHANG
for delete
as
begin
	if(select count(*) from deleted)>1
		begin
			raiserror(N'Lỗi xóa bản ghi',16,1)
			rollback transaction
			return
		end
	else
			update MATHANG set MATHANG.SoLuong= MATHANG.SoLuong+deleted.SoLuong
			from MATHANG inner join deleted on deleted.MaHang=MATHANG.MaHang
end
---goi trigger
select*from MATHANG
select*from NHATKYBANHANG
---TH nhieu hon 1 record
delete from NHATKYBANHANG where STT=1 or STT=2
--TH dung
delete from NHATKYBANHANG  where STT=2

/* f. Tạo Trigger cập nhật bảng nhật ký bán hàng, nếu cập nhật nhiều hơn 1 bản ghi 
thông báo lỗi và phục hồi phiên giao dịch, ngược lại kiểm tra xem nếu giá trị số
lượng cập nhật <giá trị số lượng có thì thông báo lỗi sai cập nhật, ngược lại nếu nếu 
giá trị số lượng cập nhật =giá trị số lượng có thì thông báo không cần cập nhật ngược 
lại thì hãy cập nhật giá trị*/
create trigger cauf
on NHATKYBANHANG
for update
as
begin
	declare @slcapnhat int
	declare @slco int
	if(select count(*) from inserted)>1
		begin
			raiserror(N'lỗi và phục hồi phiên giao dịch',16,1)
			rollback transaction
			return
		end
	else
		select @slcapnhat=SoLuong from inserted
		select @slco =SoLuong from deleted
		if(@slcapnhat<@slco)
			begin
				raiserror(N'lỗi sai cập nhật',16,1)
			    rollback transaction
			    return
			end
		else
			if(@slcapnhat=@slco)
			begin
				raiserror(N'Không cần cập nhật',16,1)
			    rollback transaction
			    return
			end
		else
			begin
				update MATHANG set MATHANG.SoLuong=MATHANG.SoLuong-(@slco-@slcapnhat)
				from MATHANG inner join deleted on deleted.MaHang=MATHANG.MaHang
				inner join inserted on inserted.MaHang=MATHANG.MaHang
			end
end
---goi trigger
select*from MATHANG
select*from NHATKYBANHANG
--TH  nhiều hơn 1 bản ghi
update NHATKYBANHANG set SoLuong=5 where STT=3 or STT=1 
--TH số lượng cập nhật <giá trị số lượng
update NHATKYBANHANG set SoLuong=3 where STT=3 
--TH số lượng cập nhật =giá trị số lượng
update NHATKYBANHANG set SoLuong=185 where STT=3 ----(SoLuong dung bang so luong ban)
--TH cap nhat
update NHATKYBANHANG set SoLuong= 300 where STT=1

/*g. Viết thủ tục xóa 1 bản ghi trên bảng mathang, voi mahang được nhập từ bàn phím. 
Kiểm tra xem mahang co tồn tại hay không, nếu không đưa ra thông báo, ngược lại 
hãy xóa, có tác động đến 2 bảng.*/
create proc caug(@MaHang int)
as
begin
	if(not exists(Select *from MATHANG where MaHang=@MaHang))
		begin
			print(N'Mặt hàng này không tồn tại')
		end
	else
		begin
			delete from NHATKYBANHANG where MaHang=@MaHang
			delete from MATHANG where MaHang=@MaHang
		end
end
----goi thu tuc
select*from MATHANG
select*from NHATKYBANHANG
exec caug 2

--h. Viết 1 hàm tính tổng tiền của 1 mặt hàng có tên hàng được nhập từ bàn phím.
create function cauh(@TenHang nvarchar(20))
returns money
as
begin
	declare @TongTien money
	select @TongTien=sum(NHATKYBANHANG.SoLuong*GiaBan) from NHATKYBANHANG inner join MATHANG on MATHANG.MaHang=NHATKYBANHANG.MaHang where TenHang=@TenHang
	return @TongTien
end
---goi ham
select*from MATHANG
select*from NHATKYBANHANG
select dbo.cauh('Thuoc')
