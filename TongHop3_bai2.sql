create database Tonghop3_bai2;
use Tonghop3_bai2;
-- 1 (Yến) tạo 4 bảng (như hình)
	create table Class(
    ClassId int primary key auto_increment,
    ClassName varchar(255) not null,
    StartDate datetime not null,
    Status bit
    );
    Create table Student(
    StudentId int primary key,
    StudentName varchar(30) not null,
    Address varchar(50),
    Phone varchar (20),
    Status bit,
    ClassId int not null
    );
    create table Subject(
    subId int primary key auto_increment,
    subName varchar(30) not null,
    Credit tinyint not null default 1 check(credit>=1),
    Status bit default 1
    );
    create table Mark(
    MarkId int primary key auto_increment,
    SubId int not null ,
    StudentId int not null ,
    Mark float default 0 check(mark between 0 and 100),
    ExamTimes tinyint default 1,
    unique(SubId,StudentId)
    );
-- 2 () Sử dụng câu lệnh sử đổi bảng để thêm các ràng buộc vào các bảng theo mô tả:
	-- a (Yến) Thêm ràng buộc khóa ngoại trên cột ClassID của  bảng Student, tham chiếu đến cột ClassID trên bảng Class.
	alter table Student
    add foreign key (ClassID) references Class(ClassID);
    
    -- b (Yến) Thêm ràng buộc cho cột StartDate của  bảng Class là ngày hiện hành.
    select * from Class;
	alter table Class
    alter column StartDate
    set default (now());
    -- c (Minh) Thêm ràng buộc mặc định cho cột Status của bảng Student là 1.
    alter table student 
	alter column status 
	set default 1;

    -- d (Minh) Thêm ràng buộc khóa ngoại cho bảng Mark trên cột:
	alter table mark 
    -- SubID trên bảng Mark tham chiếu đến cột SubID trên bảng Subject
	add foreign key (subID) references subject(subID),
    -- StudentID tren bảng Mark tham chiếu đến cột StudentID của bảng Student. 
	add foreign key (studentID) references student(studentID);

-- 3 (Minh) Thêm dữ liệu vào bảng (như hình)
insert into class (className, startDate, status) values
("A1","2008-12-20",1),
("A2","2008-12-22",1),
("B3",curdate(),0);
insert into student values
(1,"Hung","Ha noi","0912113113",1,1),
(2,"Hoa","Hai phong",null,1,1),
(3,"Manh","HCM", "0123123123",0,2);
insert into subject (subName,credit,status) values
("CF",5,1),
("C",6,1),
("HDJ",5,1),
("RDBMS",10,1);
insert into mark (subID,studentID,mark,examTimes) values
(1,1,8,1),
(1,2,10,2),
(3,1,12,1);

-- 4 Cập nhật dữ liệu.
	-- a (Thu) Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2.
		update Student set ClassID = 2 where StudentName='Hùng';
    -- b (Thu) Cập nhật cột phone trên bảng sinh viên là ‘No phone’ cho những sinh viên chưa có số điện thoại.
		update Student set Phone = 'No Phone ' where Phone is null;
    -- c (Thu) Nếu trạng thái của lớp (Stutas) là 0 thì thêm từ ‘New’ vào trước tên lớp. (Chú ý: phải sử dụng phương thức write).
		update Class set ClassName = concat('New', ClassName) where Status=0;
	-- d (Sơn) Nếu trạng thái của status trên bảng Class là 1 và tên lớp bắt đầu là ‘New’ thì thay thế ‘New’ bằng ‘old’. (Chú ý: phải sử dụng phương thức write)
		update class set classname = replace(classname, 'new', 'old') where classname like 'new%' and status = 1;
    -- e (Sơn) Nếu lớp học chưa có sinh viên thì thay thế trạng thái là 0 (status=0).
		update class set status  = 0 where classId not in (select classId from student);
    -- f (Sơn) Cập nhật trạng thái của môn học (bảng subject) là 0 nếu môn học đó chưa có sinh viên dự thi.
		update subject set status  = 0 where subId not in (select subId from mark);
-- 5 Hiện thị thông tin.
	-- a (Vân) Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘h’.
    select student.studentName from student where studentName like "h%";
	-- b (Vân) Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12.
    select * from class where startDate like "%-12-%";
	-- c (Vân) Hiển thị giá trị lớn nhất của credit trong bảng subject.
    select max(subject.credit) as "MAX CREDIT" from subject;
	-- d (Đạt) Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.
    select * from subject where credit=(select max(credit)from subject);
	-- e (Đạt) Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5.
    select * from subject where credit between 3 and 5;
	-- f (Đạt) Hiển thị các thông tin bao gồm: classid, className, studentname, Address từ hai bảng Class, student
    select c.ClassId ,c.ClassName, s.StudentName,s.Address from class c join student s on c.ClassId= s.ClassId;
	-- g (Chuân) Hiển thị các thông tin môn học chưa có sinh viên dự thi.
    select subname from Subject 
    where subid not in (select subid from mark);
    
	-- h (Chuân) Hiển thị các thông tin môn học có điểm thi lớn nhất.
    select * from Subject where subid = (select subid from mark where mark = (select max(mark) from mark));
    
	-- i (Chuân) Hiển thị các thông tin sinh viên và điểm trung bình tương ứng.
    select Student.*, avg(Mark.Mark) as AVG from Student 
		join Mark on Student.studentId = Mark.StudentId
        group by Student.StudentID;
    
	-- j (Huy) Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần (gợi ý: sử dụng hàm rank)
    select s.studentname 'tenSV', avg(m.mark) 'dtb' from mark m 
    join student s on s.studentid = m.studentid
    group by s.studentid
    order by m.mark desc;
	-- k (Huy)  Hiển thị các thông tin sinh viên và điểm trung bình, chỉ đưa ra các sinh viên có điểm trung bình lớn hơn 10.
    select s.studentname 'tenSV', avg(m.mark) 'dtb' from mark m 
    join student s on s.studentid = m.studentid
    group by s.studentid
    having avg(m.mark) > 10
    order by m.mark desc;    
	-- l (Huy) Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần.
    select s.studentname, sub.subname, m.mark from student s
    join mark m on m.studentid = s.studentid
    join subject sub on sub.subid = m.subid
    group by m.mark
    order by m.mark desc , s.studentname asc;
-- 6 (còn lại Vượng cân tất) Xóa dữ liệu.
	-- a Xóa tất cả các lớp có trạng thái là 0.
    delete from class where status = 0;
	-- b Xóa tất cả các môn học chưa có sinh viên dự thi.
    delete from subject where not exists (select 1 from mark m where m.subid = subject.subid);
	-- c Xóa bỏ cột ExamTimes trên bảng Mark.
    alter table mark drop examtimes;
	-- d(hà) Sửa đổi cột status trên bảng class thành tên ClassStatus.
    alter table class change `status` `ClassStatus` bit;
	-- e(hà) Đổi tên bảng Mark thành SubjectTest.
	alter table mark rename to `SubjectTest`;
    
