﻿-- -------------------------------------- SMÁVEGIS UM TRIGGER Í MYSQL ----------------------------------

-- 1:  Trigger er sérstök function sem gansett með því að gefa SQL skipanir(insert, update og jafnvel delete)
-- 2:  Trigger eru skilgreindur til að fara í gang við ákveðna aðgerð í ákveðinni töflu
-- 3:  Trigger getur keyrt sinn kóða á undan eða eftir þeirri skipun sem ræsir hann
-- 4:  Trigger hefur aðgang að þeim gögnum sem gefin eru upp í SQL skipunum(new / old)

-- Lesefni:  http://www.mysqltutorial.org/mysql-triggers.aspx


select * from studentstatus;
-- Trigger template(before insert):
delimiter $$
create trigger nafn_a_trigger 
before insert on nafn_a_töflu
for each row 
begin
    -- Kóðinn sem triggerinn keyrir 
    -- ÁÐUR en insert(before insert) into kóðinn keyrir
end $$


-- Trigger template(after insert):
delimiter $$
create trigger nafn_a_trigger 
after insert on nafn_a_töflu
for each row 
begin
    -- Kóðinn sem triggerinn keyrir 
    -- EFTIR að insert skipunin hefur keyrt(after insert) into kóðinn keyrir
end $$

-- Ef trigger á að keyra á undan / eftir update skipun þá eru notaðar skipanirnar
-- before update / after update

-- Dæmi um trigger sem stoppar insert skipun í því að keyra ef skilyrði er ekki uppfyllt:
delimiter $$
create trigger check_semester_dates
before insert on Semesters
for each row
begin
	 -- tímagildin úr insert skipuninni eru skoðuð hér og ef
     -- lokadagsetning annar er sú sama eða á undan upphafsdagsetningu þá segir triggerinn stop!
     if (new.semesterEnds <= new.semesterStarts) then
		-- Villu er kastað og villuskilaboðin birt
		signal sqlstate '45000' set message_text = 'Semester end must be after Semester start';
     end if;
end $$
delimiter ;

-- Núna fer þessi trigger í gang við hvert einasta insert into sem gert er á töfluna Semesters.
insert into Semesters(semesterName,semesterStarts,semesterEnds,academicYear)
values('No-can-do','2021-10-01','2021-09-01','2021-2022');


-- Hvað með trigger sem keyrir á update Semesters??

delimiter $$
create trigger check_semester_date_when_updating
before update on Semesters
for each row
begin
	if (new.semesterEnds <= new.semesterStarts) then
		signal sqlstate '45000' set message_text = 'Semester end must be after Semester start';
	end if;
end $$
delimiter ;

-- Þar sem allar annirnar í ProgressTracker grunninum eru með réttum upplýsingum
-- þá bætum við við einu semestri sem er með smá villu/ónákvæmni 
-- en er ekki stoppuð af insert triggernum:
insert into Semesters(semesterName,semesterStarts,semesterEnds,academicYear)
values('Haust2026','2021-10-01','2021-11-01','2026-2027');

-- uppfærum gögnin í semesterStarts og semesterEnds:
update Semesters
set semesterStarts = '2026-08-01', semesterEnds = '2026-01-31'
where semesterID = 23;

-- Skoða:
select * from Semesters;



