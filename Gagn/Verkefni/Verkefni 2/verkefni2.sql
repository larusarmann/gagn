use studytracker;

delimiter $$
drop trigger if exists lidur1;
create trigger lidur1
before insert on registration
for each row 
begin
    declare msg varchar(50);
    if (StudentStatus(New.studentId ) in(2,3,4,5,6)) then
            set msg = concat('student must be virkur');
            signal sqlstate '45000' set message_text = msg;
     end if;
end $$

-- Test
insert into registration(studentID, courseNumber, grade, semesterID) Values(1,'DANS2BM05AT',7,11)
insert into registration(studentID, courseNumber, grade, semesterID) Values(15,'DANS2BM05AT',7,11)


select * from registration;
delimiter €€
drop trigger if exists lidur2;
create trigger lidur2
before update on registration
for each row
begin
	declare msg varchar(50);
    
    if (StudentStatus(New.studentId ) in(2,3,4,5,6)) then
            set msg = concat('student must be virkur');
            signal sqlstate '45000' set message_text = msg;
     end if;
end €€

-- Test
UPDATE registration SET courseNumber = 'DANS2BM05AT', grade = 6, semesterID = 6 where registrationID = 645


delimiter €€
drop procedure if exists lidur3 €€
create procedure lidur3(student_id int)
begin
    select sum(b.courseCredits) as 'samtals einingar' from registration a inner join courses b on b.courseNumber = a.courseNumber where a.studentID = student_id and a.grade >= 5;
end €€

-- Test
call lidur3(1)


delimiter €€
drop procedure if exists lidur4 €€
create procedure lidur4( first_name varchar(20), last_name varchar(30), Dateob date, trackID int)
begin
	insert into students(firstName,lastName,dob,trackID,registerDate, studentStatus) values(first_name,last_name,Dateob,trackID,curdate(), 1);
    insert into registration select null as registrationID,
    LAST_INSERT_ID() as studentID ,courseNumber,curdate()
    as processDate,0 as grade ,semester as semesterID from trackcourses
    where trackID = trackID and mandatory = 1;
end €€

-- Test
call lidur4('Lárus', 'Kjartansson', '2003-11-03', 9);

