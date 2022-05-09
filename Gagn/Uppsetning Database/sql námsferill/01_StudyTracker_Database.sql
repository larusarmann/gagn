drop database if exists StudyTracker;

create database StudyTracker
	default character set utf8
	default collate utf8_general_ci;

set default_storage_engine = innodb;
set sql_mode = 'STRICT_ALL_TABLES';

use StudyTracker;

-- Semesters
create table Semesters
(
	semesterID int auto_increment,
    semesterName char(10) not null,
    semesterStarts date not null,
    semesterEnds date not null,
    academicYear char(10) null,
    constraint semester_PK primary key(semesterID)
);

-- School information
create table Schools
(
	schoolID int auto_increment,
    schoolName varchar(75),
    constraint school_PK primary key(schoolID)
);

-- Divisions belonging to certain scool(s)
create table Divisions
(
	divisionID int auto_increment,
    divisionName varchar(75) not null,
    schoolID int not null,
    constraint division_PK primary key(divisionID),
    constraint division_school_FK foreign key(schoolID) references Schools(schoolID)
);

-- Each division has at least one track
create table Tracks
(
	trackID int auto_increment,
    trackName varchar(75),
    divisionID int not null,
    constraint track_PK primary key(trackID),
    constraint track_division_FK foreign key(divisionID) references Divisions(divisionID)
);

-- All the courses in the database
create table Courses 
(
  courseNumber char(15),
  courseName varchar(75) not null,
  courseCredits int default 3,
  constraint course_PK primary key(courseNumber)
);

-- A course may or may not have restrictors applied to them
create table Restrictors 
(
  courseNumber char(15) not null,
  restrictorID char(15) not null,
  restrictorType char(1) default '1',
  constraint restrictor_PK primary key (courseNumber,restrictorID),
  constraint course_course_FK foreign key (courseNumber) references Courses (courseNumber),
  constraint restrictor_course_FK foreign key (courseNumber) references Courses (courseNumber)
);

-- Courses belonging to a certain track. A course can belong to more then one track(N:M)
create table TrackCourses
(
	trackID int not null,
    courseNumber char(15) not null,
    semester int unsigned null,
    mandatory int unsigned,
    constraint trackcourse_PK primary key(trackID,courseNumber),
    constraint track_course_tracks_FK foreign key(trackID) references Tracks(trackID),
    constraint track_course_courses_FK foreign key(courseNumber) references Courses(courseNumber)
);

create table StudentStatus
(
	ID int auto_increment,
    statusName varchar(25),
    constraint status_PK primary key(ID),
    constraint status_name_UQ unique(statusName)
);

create table Students
(
	studentID int auto_increment,
    firstName varchar(55),
    lastName varchar(55),
    dob date,
    trackID int,
    registerDate date not null,
    studentStatus int,
    constraint student_PK primary key(studentID),
    constraint student_status_FK foreign key(studentStatus) references StudentStatus(ID),
    constraint student_track_FK foreign key(trackID) references Tracks(trackID)
);


create table Registration
(
	registrationID int auto_increment,
    studentID int not null,
    courseNumber char(15) not null,
    processDate date,
    grade float default null,
    semesterID int not null,
    constraint registration_PK primary key(registrationID),
    constraint registration_student_FK foreign key(studentID) references Students(studentID),
    constraint registration_course_FK foreign key(courseNumber) references TrackCourses(courseNumber),
	constraint registration_semester_FK foreign key(semesterID) references Semesters(semesterID)
);
