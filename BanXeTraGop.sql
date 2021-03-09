create database SalonBanXe
go
use SaLonBanXe
go
--drop database SalonBanXe
CREATE TABLE DauXe
(
	MaDX varchar(10) primary key,
	TenDX nvarchar(200) not null,
	Gia float not null,
	SoLuong int
)

go
CREATE TABLE ChiecXe
(
	MaXe varchar(10) primary key,
	MaDX varchar(10) not null,
	TrangThai char(5),--Nếu trạng thái là 'True': đã trả xong;'False': chưa trả xong
	SoKhungXe char(50),
	foreign key (MaDX) references DauXe(MaDX)
)
go

CREATE TABLE KhachHang
(
	MaKH varchar(10) primary key,
	Ten nvarchar(50),
	Ho nvarchar(50),
	TenLot nvarchar(50),
	SDT char(11) not null,
	CMND char(11) not null,
	Email varchar(50),
	NgayTao smalldatetime,
	DiaChi nvarchar(500) not null
)
go

CREATE TABLE KyHan
(
	MaKyHan varchar(10) primary key,
	SoThang int not null,
	LaiXuat float not null
)

go
CREATE TABLE HopDongTraGop
(
	MaTG varchar(10) primary key,
	MaKH varchar(10),
	MaXe varchar(10),
	MaKyHan varchar(10),
	NgayBatDau smalldatetime not null,
	TienTraTruoc float not null,
	TienNo float not null,
	TienDinhKy float not null,
	TienDaTra float,
	SoThang int,
	LaiXuat float,
	foreign key (MaXe) references ChiecXe(MaXe),
	foreign key (MaKH) references KhachHang(MaKH),
	foreign key (MaKyHan) references KyHan(MaKyHan)
)

go  
CREATE TABLE PhieuTraGop
(
	MaPhieuTG varchar(10) primary key,
	MaTG varchar(10) not null,
	NgayTra smalldatetime,
	NgayHen smalldatetime,
	TienPhat float,
	TienThucThu float not null,
	foreign key (MaTG) references HopDongTraGop(MaTG),
)
go

CREATE TABLE ThamSo
(
	Id int,
	Ten varchar(100),
	SoLieu float
)
go

CREATE TABLE NhanVien
(
	MaNV varchar(10) primary key,
	Ten nvarchar(50),
	Ho nvarchar(50),
	TenLot nvarchar(50),
	SDT char(11),
	CMND char(11),
	Email varchar(50),
	NgayTao smalldatetime,
	Luong int,
	ChucVu nvarchar(100) not null, --Nhan vien, quan ly kho, ke toan, quan ly nhan su
)

go
CREATE TABLE NhaCungCap
(
	MaNCC varchar(10) primary key,
	TenNCC nvarchar(200),
	DiaChiNCC nvarchar(200),
	SDTNCC char(11)
) 

go
CREATE TABLE PhieuNhapXe
(
	MaPhieuNhapXe varchar(10) primary key,
	MaNCC varchar(10),
	SLNhap int not null,
	ThanhTien float,
	NgayNhap smalldatetime,
	foreign key (MaNCC) references NhaCungCap(MaNCC)
)
select * from NhaCungCap

insert into NhaCungCap values('N01','Nha cung cap 1','123 CAO DAT','48455')
insert into NhaCungCap values('N02','Nha cung cap 2','541 PHAN HUY ICH','0541515')
insert into NhaCungCap values('N03','Nha cung cap 3','12 HOANG VIET','84512')
insert into NhaCungCap values('N04','Nha cung cap 4','88 TRAN NHAN TON','894965')
go
Create view NhaCungCap_view as
select MaNCC, TenNCC, DiaChiNCC
from NhaCungCap
where TenNCC = 'Nha cung cap 1' 
and DiaChiNCC = '123 CAO DAT'
go

select * from NhaCungCap_view
go
Create view KyHan_view as
select MaKyHan,SoThang,LaiXuat
from KyHan
where SoThang = '4' 
and LaiXuat = '4'
go

select * from KyHan_view

select * from DauXe

insert into DauXe values('X001','Blade','21000000','10')
insert into DauXe values('X002','Sirius','20000000','15')
insert into DauXe values('X003','Exciter','56000000','22')

insert into ChiecXe values('CX001','X001','False','123456-122')
insert into ChiecXe values('CX002','X002','False','123456-123')
insert into ChiecXe values('CX003','X003','False','123456-124')
insert into ChiecXe values('CX004','X002','True','123456-125')

go
create trigger trg_KT_DauXe on DauXe for insert,update
as
begin
	if((select Gia from inserted)<0)
	begin
		print N'Gia se khong duoc la so am'
		rollback tran
	end
end
go

--insert into DauXe values('X004','Vision','-2000000','22')

select * from KyHan

insert into KyHan values('K01','12','8')
insert into KyHan values('K02','4','4')
insert into KyHan values('K03','8','6')
go
create trigger trg_KT_KyHan on KyHan for insert,update
as
begin
	if((select SoThang from inserted) % 2 !=0 or (select SoThang from inserted) > 12 or (select SoThang from inserted) < 0 )
	begin
		print N'So thang cua ky han phai la 2,4,6,8,10,12'
		rollback tran
	end
end
go

--insert into KyHan values('K04','13','9')
go
--Mô tả: Lấy danh sách các chiếc xe đã hợp đồng theo tên DauXe
create function fuDanhSachChiecXeBanTheoDauXe
(@TenDauXe nvarchar(200))
returns table
as
	return (select * from ChiecXe where MaDX in (select MaDX from DauXe where TenDX=@TenDauXe))
go

select * from dbo.fuDanhSachChiecXeBanTheoDauXe('Sirius')