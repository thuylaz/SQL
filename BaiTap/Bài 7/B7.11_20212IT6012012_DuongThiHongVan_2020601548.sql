--Hãy thực hiện tạo hàm với Scalar Valued Function

--a (1đ). Hãy xây dựng hàm Đưa ra tổng giá trị xuất của hãng tên hãng là A, trong năm tài 
--khóa x, với A, x được nhập từ bàn phím.
create function fn_tonggtrixuat(@A nvarchar(20), @x int)
returns int
as
begin 
 declare @tong int
            set @tong=(select sum(SoLuong) from Xuat
			          inner join Pxuat on Pxuat.SoHDX=Xuat.SoHDX
					  inner join SanPham on SanPham.MaSP=Xuat.MaSP
					  inner join HangSX on HangSX.MaHangSX=SanPham.MaHangSX
					  where TenHang=@A and year(NgayXuat)=@x
					  )
		    return @tong
end

select dbo.fn_tonggtrixuat('Samsung',2018)

--b (1đ). Hãy xây dựng hàm thống kê số lượng nhân viên mỗi phòng với tên phòng nhập từ
--bàn phím.
create function fn_thongkenvtheophong(@tenphong nvarchar(20))
returns int
as 
begin
     declare @soluong int
	 set @soluong=(select count(MaNV) from NhanVien
	 where TenPhong=@tenphong)
	 return @soluong
end

select dbo.fn_thongkenvtheophong('Nhan Su')

--c (2đ). Hãy viết hàm thống kê xem tên sản phẩm x đã xuất được bao nhiêu sản phẩm trong 
--ngày y, với x,y nhập từ bản phím.
create function fn_soluongxuat(@x nvarchar(20), @y datetime)
returns int 
as
begin
     declare @tong int
	 set @tong=(select sum(SoluongX) from Xuat 
	            inner join Pxuat on Xuat.SoHDX=Pxuat.SoHDX
				inner join SanPham on SanPham.MaSP=Xuat.MaSP
				where TenSP=@x and NgayXuat=@y)
		return @tong
end

select dbo.fn_soluongxuat('Tivi','01/01/2020')


--d (2đ). Hãy viết hàm trả về số diện thoại của nhân viên đã xuất số hóa đơn x, với x nhập từ
--bàn phím.
create function fn_trasdtnv(@x nchar(10))
returns nvarchar
as
begin 
     declare @sdt nvarchar(20)
	 set @sdt=(select SoDT from NhanVien inner join Pxuat
	           on NhanVien.MaNV=Pxuat.MaNV
			   where SoHDX=@x
			   )
	 return @sdt
end

select dbo.fn_trasdtnv('00001234')

--e (2đ). Hãy viết hàm thống kê tổng số lượng thay đổi nhập xuất của tên sản phẩm x trong 
--năm y, với x,y nhập từ bàn phím.
create function fn_tksoluong (@x nvarchar(20), @y int)
returns int
as
begin
     declare @soluongcon int
	 declare @tongnhap int
	 declare @tongxuat int
	 select @tongnhap=sum(SoLuongN) from Nhap 
                   inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
				   inner join SanPham on SanPham.MaSP=Nhap.MaSP
				   where TenSP=@x and year(NgayNhap)=@y
				   
	 Select @tongxuat=sum(SoluongX) from Xuat
	               inner join Pxuat on Pxuat.SoHDX=Xuat.SoHDX  
                   inner join SanPham on SanPham.MaSP=Xuat.MaSP
				   where TenSP=@x and year(NgayXuat)=@y
	 set @soluongcon=@tongnhap-@tongxuat
	return @soluongcon
end

select dbo.fn_tksoluong ('Ipad', 2020)

--f (2đ). Hãy viết hàm thống kê tổng số lượng sản phầm của hãng x, với tên hãng nhập từ
--bàn phím.
create function fn_tkesosp(@x nvarchar(20))
returns int
as
begin
     declare @thongke int
	 declare @tongsp int
	select @thongke=count( SanPham.MaSP) from SanPham
	 inner join HangSX on HangSX.MaHangSX=SanPham.MaHangSX
	            where TenHang=@x
     set @tongsp= sum(@thongke)
	return @tongsp
end

select dbo.fn_tkesosp('Apple')
