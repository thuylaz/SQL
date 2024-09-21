--Bài 1: Scalar Valued Funcion
--a.Hãy xây dựng hàm Đưa ra tên HangSX khi nhập vào MaSP từ bàn phím
Create Function fn_TimHang(@MaSP nvarchar(10))
Returns nvarchar(20)
As
	Begin
	Declare @ten nvarchar(20)
	Set @ten = (Select TenHang From HangSX Inner join SanPham
				on HangSX.MaHangSX = SanPham.MaHangSX
				Where MaSP = @MaSP)
	Return @ten
End
--Gọi hàm
Select dbo.fn_TimHang('sp01')

--b.Hãy xây dựng hàm đưa ra tổng giá trị nhập từ năm nhập x đến năm nhập y, với x, y được 
--nhập vào từ bàn phím.
Create Function fn_ThongKeNhapTheoNam(@ngayx int,@ngayy int)
Returns int
As
	Begin
	Declare @tongTien int
	Select @tongTien = sum(SoLuongN*DonGiaN)
	From Nhap Inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
	Where Year(NgayNhap) Between @ngayx And @ngayy
	Return @tongTien 
End
--Gọi hàm
 Select dbo.fn_ThongKeNhapTheoNam(2016,2020)

--c.Hãy viết hàm thống kê tổng số lượng thay đổi nhập xuất của tên sản phẩm x trong năm 
--y, với x,y nhập từ bàn phím.
Create Function fn_ThongKeNhapXuat(@TenSP nvarchar(20),@namxuat int,@namnhap int)
Returns int
As
Begin
	Declare @tongnhap int
	Declare @tongxuat int
	Declare @thaydoi int
	Select @tongnhap = Sum(SoLuongN) From Nhap
	Inner join SanPham on Nhap.MaSP = SanPham.MaSP
	Inner join PNhap on PNhap.SoHDN=Nhap.SoHDN
	Where TenSP = @TenSP And Year(NgayNhap)=@namnhap
	Select @tongxuat = Sum(SoLuongX) From Xuat
	Inner join SanPham on Xuat.MaSP = SanPham.MaSP
	Inner join PXuat on PXuat.SoHDX=Xuat.SoHDX
	Where TenSP = @TenSP And Year(NgayXuat)=@namxuat
	Set @thaydoi = @tongnhap - @tongxuat
	Return @thaydoi
End
--Gọi hàm
select dbo.fn_ThongKeNhapXuat('Galaxy Note 11',2018,2020)

--Bài 2: Table Valued Function
--a. Hãy xây dựng hàm đưa ra thông tin các sản phẩm của hãng có tên nhập từ bàn phím.
Create Function fn_DSSP(@TenHang nvarchar(20))
Returns @bang Table (
           MaSP nvarchar(10),
           TenSP nvarchar(20),
           SoLuong int,
           MauSac nvarchar(20),
           GiaBan money,
           DonViTinh nvarchar(10),
           MoTa nvarchar(max)
          )
As
   Begin
     Insert Into @bang
                 Select MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
                 From SanPham Inner join HangSX 
                 on SanPham.MaHangSX = HangSX.MaHangSX
                 Where TenHang = @TenHang
     Return
End
--Gọi hàm
select * from dbo.fn_DSSP('Samsung')

--b. Hãy viết hàm Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được nhập 
--từ ngày x đến ngày y, với x,y nhập từ bàn phím.
create function fn_thongkexuatnhap(@ngayx date, @ngayy date)
returns @bang table (
                  MaSP nvarchar(10),
                  TenSP nvarchar(20),
                  TenHang nvarchar(20),
                  NgayNhap datetime,
                  SoLuongN int,
                  DonGiaN money
				  )
as 
begin
     insert into @bang
	 select  SanPham.MaSP ,  TenSP, TenHang, NgayNhap, SoLuongN, DonGiaN
	  from Nhap inner join SanPham on SanPham.MaSP=Nhap.MaSP
	  inner join HangSX on SanPham.MaHangSX=HangSX.MaHangSX
	  inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
	  where NgayNhap between @ngayx and @ngayy
	   return 
end
--Gọi hàm
select * from dbo.fn_thongkexuatnhap('01/02/2020','02/02/2020')

--c.Hãy xây dựng hàm Đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn, 
--nếu lựa chọn = 0 thì Đưa ra danh sách các sản phẩm có SoLuong = 0, ngược lại lựa chọn 
--=1 thì Đưa ra danh sách các sản phẩm có SoLuong >0.
Create Function fn_dssptheosoluong(@TenHang nvarchar(20), @luachon int)
Returns @bang Table (
             MaSP nvarchar(10),
             TenSP nvarchar(20),
             TenHang nvarchar(20),
             SoLuong int,
             MauSac nvarchar(20),
             GiaBan money,
             DonViTinh nvarchar(10),
             MoTa nvarchar(max)
             )
As
Begin
      If(@luachon=0)
             Insert Into @bang
                       Select MaSP,TenSP,TenHang,SoLuong,MauSac,GiaBan,DonViTinh,MoTa
                       From SanPham Inner join HangSX
                       on SanPham.MaHangSX = HangSX.MaHangSX
                       Where TenHang = @TenHang And SoLuong=0
       Else
       If(@luachon =1)
             Insert Into @bang
                       Select MaSP,TenSP,TenHang,SoLuong,MauSac,GiaBan,DonViTinh,MoTa
                       From SanPham Inner join HangSX
                       on SanPham.MaHangSX = HangSX.MaHangSX
                       Where TenHang = @TenHang And SoLuong >0
        Return
End
--Gọi hàm
select *from dbo.fn_dssptheosoluong('Samsung',1)
select *from dbo.fn_dssptheosoluong('Samsung',0)

--d.Hãy xây dựng hàm Đưa ra danh sách các nhân viên có tên phòng nhập từ bàn phím.
create function fn_dsnvtheophong(@tenphong nvarchar(20))
returns @bang table(
                  MaNV nchar(10),
				  TenNV nvarchar(20),
				  GioiTinh bit,
				  DiaChi nvarchar(30),
				  SoDT nvarchar(20),
				  Email nvarchar(30)
				  )
as 
begin
     insert into @bang
	 select MaNV, TenNV, GioiTinh, DiaChi, SoDT, Email from NhanVien
	 where TenPhong=@tenphong
	 return
end
--Gọi hàm
select * from dbo.fn_dsnvtheophong('Nhan Su')

