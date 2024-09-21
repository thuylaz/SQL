--f bai7.22
create function soluong(@x nvarchar(20))
returns int
as
begin
      declare @soLuong int
	  set @soLuong =(
	     select sum(soLuong)
		 from SanPham inner join HangSX
		 on sanpham.MaHangSX=hangsx.MaHangSX
		 where TenHang=@x
		 group by HangSX.MaHangSX
	  )
	  return @soLuong
end