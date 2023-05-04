CREATE DATABASE TicketFilm;
USE TicketFilm;

-- Tạo bảng
CREATE TABLE tblPhim (
PhimID int primary key,
ten_phim varchar(30),
loai_phim varchar(25),
thoi_gian int
);

CREATE TABLE tblPhong (
PhongID int primary key,
ten_phong varchar(20),
trang_thai tinyint
);

CREATE TABLE tblGhe (
GheID int primary key,
PhongID int,
So_ghe varchar(10),
foreign key (PhongID) references tblPhong(PhongID)
);

CREATE TABLE tblVe (
PhimID int,
GheID int,
Ngay_chieu datetime,
trang_thai varchar(20),
foreign key (PhimID) references tblPhim(PhimID),
foreign key (GheID) references tblGhe(GheID)
);

-- Thêm dữ liệu
insert into tblPhim values 
(1, "Em bé Hà Nội", "Tâm lý",90),
(2, "Nhiệm vụ bất khả thi", "Hành Động",100),
(3, "Dị Nhân", "Viễn Tưởng",90),
(4, "Cuốn theo chiều gió", "Tình Cảm",120);

insert into tblPhong values 
(1, "Phòng chiếu 1", 1),
(2, "Phòng chiếu 2", 1),
(3, "Phòng chiếu 3", 0);

insert into tblGhe values
(1,1,"A3"),
(2,1,"B5"),
(3,2,"A7"),
(4,2,"D1"),
(5,3,"T2");

insert into tblVe values
(1,1,"2008-10-20", "Đã bán"),
(1,3,"2008-11-20", "Đã bán"),
(1,4,"2008-12-23", "Đã bán"),
(2,1,"2009-02-14", "Đã bán"),
(3,1,"2009-02-14", "Đã bán"),
(2,5,"2009-03-08", "Chưa bán"),
(2,3,"2009-03-08", "Chưa bán");

-- 2 Hiển thị danh sách các phim (chú ý: danh sách phải được sắp xếp theo trường Thoi_gian)				
select *from tblphim order by thoi_gian asc;
-- 3 Hiển thị Ten_phim có thời gian chiếu dài nhất
select ten_phim from tblPhim where thoi_gian = (select max(thoi_gian) from tblPhim);

-- 4 Hiển thị Ten_Phim có thời gian chiếu ngắn nhất
select ten_phim from tblPhim where thoi_gian = (select min(thoi_gian) from tblPhim);
-- 5 Hiển thị danh sách So_Ghe mà bắt đầu bằng chữ ‘A’
select * from tblGhe where so_ghe like "A%";
-- 6 Sửa cột Trang_thai của bảng tblPhong sang kiểu nvarchar(25)			
alter table tblPhong modify trang_thai varchar(25);
-- 7 Cập nhật giá trị cột Trang_thai của bảng tblPhong theo các luật sau:			
	-- Nếu Trang_thai=0 thì gán Trang_thai=’Đang sửa’
    -- Nếu Trang_thai=1 thì gán Trang_thai=’Đang sử dụng’
	-- Nếu Trang_thai=null thì gán Trang_thai=’Unknow’
	-- Sau đó hiển thị bảng tblPhong  (Yêu cầu dùng procedure để hiển thị đồng thời sau khi update)
    
    delimiter //
    create procedure changeStatus()
    begin
		update tblPhong
        set Trang_thai = if(Trang_thai=0,'Đang sửa',if(Trang_thai=1,'Đang sử dụng','Unknown'));
        select * from tblPhong;
    end; //
    delimiter ;
    
    call changeStatus();
    
-- 8 Hiển thị danh sách tên phim mà  có độ dài >15 và < 25 ký tự 			
	select ten_phim from tblPhim where length(ten_phim) >15 and length(ten_phim)<25;
-- 9 Hiển thị Ten_Phong và Trang_Thai trong bảng tblPhong  trong 1 cột với tiêu đề ‘Trạng thái phòng chiếu’
select concat(Ten_Phong,'    ',Trang_Thai)as 'Trang thai phong chieu' from tblPhong;
-- 10 Tạo view có tên tblRank với các cột sau: STT(thứ hạng sắp xếp theo Ten_Phim), TenPhim, Thoi_gian
create view tblRank as select row_number() over (order by ten_phim) as STT, ten_phim, thoi_gian from tblPhim;
-- 11 Trong bảng tblPhim :
	-- a Thêm trường Mo_ta kiểu nvarchar(max)
    alter table tblPhim add Mo_ta nvarchar(255);
	-- b Cập nhật trường Mo_ta: thêm chuỗi “Đây là bộ phim thể loại  ” + nội dung trường LoaiPhim				
    update tblPhim set Mo_ta = concat("Đây là bộ phim thể loại ", loai_phim);
	-- c Hiển thị bảng tblPhim sau khi cập nhật		
    select * from tblPhim;
	-- d Cập nhật trường Mo_ta: thay chuỗi “bộ phim” thành chuỗi “film” (Dùng replace)
    update tblPhim set Mo_ta = replace(Mo_ta, "bộ phim","film");
	-- e Hiển thị bảng tblPhim sau khi cập nhật	
    select * from tblPhim;

-- 12 Xóa tất cả các khóa ngoại trong các bảng trên.						
alter table tblghe drop foreign key tblghe_ibfk_1;
alter table tblve drop foreign key tblve_ibfk_1;
alter table tblve drop foreign key tblve_ibfk_2;

-- 13 Xóa dữ liệu ở bảng tblGhe
	delete from tblGhe;

-- 14 Hiển thị ngày giờ hiện chiếu và ngày giờ chiếu cộng thêm 5000 phút trong bảng tblVe
select ngay_chieu, addtime(time(ngay_chieu), "83:20:00") as "Giờ chiếu"
from tblve

