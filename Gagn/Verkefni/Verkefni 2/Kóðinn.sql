
use studytracker;

select * from students;
select * from studentstatus;
select * from registration;

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

UPDATE registration SET courseNumber = 'DANS2BM05AT', grade = 6, semesterID = 6 where registrationID = 645

select * from students
select * from registration

delimiter €€
drop procedure if exists lidur3 €€
create procedure lidur3(student_id int)
begin
    select sum(grade)*5 as 'samtals einingar' from registration where studentID = student_id and grade <= 5;
end €€

call lidur3(1)









-- búa til stored procedure sem tekur  inn upplýsingar sem þarf til að skrá inn í students töfluna
-- stored procedurinn insertar þessum gögnum inn í students töfluna og 
-- insertar inn í registration töfluna eftir gildunum sem eru inni í track corses töflunni

-- insert into students
-- SELECT LAST_INSERT_ID() into yourVariable
-- insert into registration as select null as registrationID,LAST_INSERT_ID() as studentID ,courseNumber,curdate() as processDate,0 as grade ,semester as semesterID from trackcourses where trackID = 9 and mandatory = 1

select * from students
select * from trackcourses where mandatory = 1
select * from tracks