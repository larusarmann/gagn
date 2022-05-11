
-- 2. Birta upplýsingar um einn ákveðinn áfanga með Stored Procedure.
delimiter €€
drop procedure if exists readCourse €€
create procedure readCourse(course_number char(15))
begin
	select * from courses where course_number in(courseNumber);
end €€

-- Test 
call readCourse('DANS2BM05AT');
call readCourse('ÍSLE2GO05BT');


-- 3. Nýskráning áfanga með Stored Procedure.
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

-- Test:
call addCourse('GAGN3FS05EU', 'Gagnavísindi og tölfræðigreining', 5);
call readCourse('GAGN3FS05EU');


-- 4. Uppfæra áfanga með Stored Procedure.
delimiter €€
drop procedure if exists updateCourse €€
create procedure updateCourse(oldCourse char(15), course_number char(15), course_name varchar(75), course_credits int)
begin
	UPDATE courses
	SET courseNumber = course_number, courseName = course_name, courseCredits = course_credits
	WHERE courseNumber = oldCourse;
end €€

-- Test 
call updateCourse('GAGN3FS05EU', 'LÁRU2UN05CU', 'Lárus Ármann Kjartansson', 5);
call readCourse('GAGN3FS05EU');
call readCourse('LÁRU2UN05CU');


-- 5. Eyða áfanga úr grunninum með Stored Procedure.
delimiter €€
drop procedure if exists deleteCourse €€
create procedure deleteCourse(course_number char(15))
begin
	Delete from courses where courseNumber = course_number;
end €€

-- Test
call readCourse('LÁRU2UN05CU');
call deleteCourse('LÁRU2UN05CU');


-- 6. Reikna út(telja) heildarfjölda áfanga með Function
delimiter €€
drop function if exists FjoldAfanga; 
create function FjoldAfanga()
returns int
deterministic
begin
	declare sumering int;
	select count(*) as summa from courses into sumering;
    return sumering;
end €€

-- Test
select FjoldAfanga();


-- 7. Function sem telur einingar sem eru í boði á ákveðinni námsleið
delimiter €€
drop function if exists brautarEining;
create function brautarEining(braut int)
Returns int
deterministic
begin
	declare heild int;
	select sum(a.courseCredits) as Heildareiningar 
    from courses a inner join trackcourses b On a.courseNumber= b.courseNumber where braut = b.trackID into heild ;
    return heild;
end €€

-- Test
select brautarEining(3); -- braut sem er tóm í DB
select brautarEining(9); -- eina brautin í DB


-- 8. Skrifa Function sem kannar hvort að ákv. dagsetning(date) sé á hlaupári
delimiter €€
drop function if exists hlaupar;
create function hlaupar(dob date)
returns bool
DETERMINISTIC
 begin
	declare ja bool;
    select YEAR(dob) % 4 = 0 into ja;
    return ja;
 end €€
 
-- Test
select hlaupar('1996-08-08');


-- 9. Skrifa Function sem reiknar út aldur ef upp er gefin dagsetning 
delimiter €€
drop function if exists ageCalculation €€
create function ageCalculation(givenDATE date)
returns int
deterministic
 begin
    declare age int;
    select TIMESTAMPDIFF(YEAR,givenDATE,CURDATE()) into age;
 return age;
 end €€
 delimiter €€

-- Test 
select ageCalculation('1999-05-10');
select ageCalculation('1999-05-25');


-- 10. Stored Procedure sem skilar öllum nemendum á ákveðinni önn(semester)
delimiter €€
drop procedure if exists allirNemar €€
create procedure allirNemar(onn int)
begin
select
	S.studentID as nemandanumer, S.firstName as Fornafn, S.lastName as Eftirnafn, S.dob as Fæðingardagur, 
    ss.statusName as status, T.trackName as námsleið, D.divisionName as brautarheiti, C.schoolname as skólaheiti
		FROM students S 
		inner join registration R on R.studentID = S.studentID
		inner join semesters o on o.semesterID = R.semesterID
		inner join studentStatus as ss on ss.ID = S.studentStatus
		inner join tracks T on T.trackID = S.trackID
		inner join divisions D on T.divisionID
		inner join schools C on C.schoolID = D.schoolID
		where R.semesterID = onn;
end €€

-- Test
call allirNemar(15);
call allirNemar(7);

-- studentID - students, registration
-- firstName,lastName eða samsett með concat() fallinu - students
-- dob - students
-- statusName - studentstatus
-- trackName - tracks
-- divisionName - divisions
-- SchoolName - schools
-- -------------------------------------------------------------------------------------------------------------------------------
-- semester.semesterID = registration.semesterID
-- registration.studentID = students.studentID
-- students.studentStatus = studentStatus.ID
-- tracks.trackID = students.trackID
-- divisions.divisonID = tracks.divisionID
-- schools.schoolID = divisions.schoolID