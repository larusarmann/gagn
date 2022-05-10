delimiter €€
drop procedure if exists AddStudent €€

create procedure AddStudent(first_name varchar(55), last_name varchar(55), date_of_birth date, track_id int)
begin
    insert into Students(firstName,lastName,dob,trackID,registerDate)
    values(first_name,last_name,date_of_birth,track_id, date(now()));

    select row_count();
end €€


delimiter €€
drop procedure if exists AddStudentJson €€

create procedure AddStudentJson(json_data json)
begin
    insert into Students(firstName,lastName,dob,trackID,registerDate)
    values(json_data->>'$.first_name',json_data->>'$.last_name',json_data->>'$.dob',json_data->>'$.track_id', date(now()));

    select json_object('table', 'Students', 'rows_inserted', row_count()) as result;
end €€
delimiter ;


delimiter $$
drop procedure if exists StudentList $$

create procedure StudentList()
begin
    select studentID, concat(firstName,' ', lastName) as 'name', dob as 'date of birth'
    from Students 
    order by firstName, lastName;
end$$
delimiter ;

delimiter $$
drop procedure if exists StudentListJSon $$

create procedure StudentListJSon()
begin
    select json_object('id',studentID, 'name', concat(firstName,' ', lastName),'dob', dob) as Students
    from Students 
    order by firstName, lastName;
end$$
delimiter ;

delimiter $$
drop procedure if exists SingleStudent $$

create procedure SingleStudent(student_id int)
begin
    select Students.firstName, Students.lastName, Students.dob, Tracks.trackName,StudentStatus.statusName
    from Students 
    inner join Tracks on Students.trackID = Tracks.trackID
    inner join StudentStatus on Students.studentStatus = StudentStatus.ID
    and Students.studentID = student_id;
end$$
delimiter ;

-- TEST:
select * from courses;
call StudentList();
call StudentListJSon();
call SingleStudent(14);
call AddStudent('Frédéric', 'Chopin', '1810-03-01', 9);
call AddStudentJSon(json_object('first_name', 'Franz', 'last_name', 'Liszt', 'dob', '1811-10-22', 'track_id', 9));