use studytracker;
select count(*) from Students;
select count(*) from Registration;
select * from Students;
select * from Semesters;
select * from Registration;
select * from courses;
select * from TrackCourses;
select * from tracks;

-- Liður 2
delimiter €€
drop procedure if exists readCourse €€
create procedure readCourse(course_number char(15))
begin
	select * from courses where course_number in(courseNumber);
end €€

-- test 
call readCourse('DANS2BM05AT');
call readCourse('ÍSLE2GO05BT');

-- Liður 3
delimiter €€
drop procedure if exists addCourse €€
create procedure addCourse(course_number char(15), course_name varchar(75), course_credits int)
begin
	if not exists(select * from Courses where courseNumber = course_number) then
		insert into Courses(courseNumber,courseName,courseCredits)
		values(course_number, course_name, course_credits);
	else
		select -1;
	end if;
end €€
-- test 1:
call addCourse('GAGN3FS05EU', 'Gagnavísindi og tölfræðigreining', 5);
call readCourse('GAGN3FS05EU');

-- Liður 4
delimiter €€
drop procedure if exists updateCourse €€
create procedure updateCourse(oldCourse char(15), course_number char(15), course_name varchar(75), course_credits int)
begin
	UPDATE courses
	SET courseNumber = course_number, courseName = course_name, courseCredits = course_credits
	WHERE courseNumber = oldCourse;
end €€

-- test 
call updateCourse('GAGN3FS05EU', 'LÁRU2UN05CU', 'Lárus Ármann Kjartansson', 5);
call readCourse('GAGN3FS05EU');
call readCourse('LÁRU2UN05CU');

-- Liður 5
delimiter €€
drop procedure if exists deleteCourse €€
create procedure deleteCourse(course_number char(15))
begin
	Delete from courses where courseNumber = course_number;

end €€

call readCourse('LÁRU2UN05CU');
call deleteCourse('LÁRU2UN05CU');

-- Liður 6
select count(*) from courses as summa;

-- Liður 7
delimiter €€
create function brautarEining(einingar int)
Returns int
begin
	select SUM(courses.courseCredits) as Heildareiningar
    from courses inner join trackcourses On courses.courseNumber=trackcourses.courseNumber;
end €€
-- Klára seinna ..........................................................................................................................................................

-- 8
select * from students 
drop function if exists hlaupar;

delimiter €€
create function hlaupar(leap int)
returns int
 begin
    select YEAR(dob) % 4 = 0 from Students as leap;
    -- true or false seinna
 end €€
-- 1996 og 2000 LEAP YEARS
delimiter;

 -- 9 
select * from Students


delimiter €€
drop function if exists ageCalculation €€
create function ageCalculation(givenDATE int)
returns int
deterministic
 begin
    declare givenDATE int;
    declare age int;
    SELECT DATEDIFF(NOW(),givenDATE)/365.25 into age;
 return age;
 end €€
 delimiter €€
 
select ageCalculation(1999-08-11);


-- Liður 10
select * from semesters;
select * from students;
select * from studentstatus;
select * from tracks;
select * from divisions

delimiter €€
drop procedure if exists allirNemar €€
create procedure allirNemar(semesterID int)
begin
	
end €€
