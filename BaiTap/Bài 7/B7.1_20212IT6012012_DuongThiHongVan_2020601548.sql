
--Bài 1 (5đ). Scalar Valued Function
--a. Hãy xây dựng hàm Đưa ra tên hãng sản xuất khi nhập vào MaSP từ bàn phím
create function fn_Ten(@MaSP nchar(10))
returns nvarchar
as
begin
   declare @Ten nvarchar
   set @Ten = (select TenSP from SanPham where MaSP=@MaSP)
   return @Ten
end
--b. Hãy xây dựng hàm đếm số sản phẩm có giá bán từ x đến y do hãng z cung ứng, với x,y,z 
--nhập từ bàn phím.
create function fn_ThongKe (@tenhang nvarchar(20), @giaban1 money, @giaban2 money)
returns int
as
begin
   declare @thongke int
   set @thongke = (select count(MaSP)
					from HangSX inner join SanPham on HangSX.MaHangSX=SanPham.MaHangSX
					where TenHang=@tenhang and GiaBan between @giaban1 and @giaban2
				  )
   return @thongke
end

--Bài 2 (5đ). Table valued funtion
--c. Hãy tạo hàm đưa ra thông tin các sản phẩm có giá bán >=x và do hãng y cung ứng. Với 
--x,y nhập từ bàn phím.
create function fn_thongkesp(@giaban money, @tenhang nvarchar(20))
returns @bang table
				(
                MaSP nchar(10),
				TenHang nvarchar(20),
				TenSP nchar(10),
				Soluong int,
				MauSac nchar(10),
				GiaBan money,
				DonViTinh nchar(10),
				MoTa nvarchar(max)
                )
as
begin 
  insert into @bang
                select MaSP, TenHang, TenSP, Soluong, MauSac, GiaBan,DonViTinh, MoTa
				from SanPham inner join HangSX on SanPham.MaHangSX=HangSX.MaHangSX
				where GiaBan>=@giaban and TenHang=@tenhang
return
end