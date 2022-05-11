drop database if exists mannfjoldi;
create database mannfjoldi;

use mannfjoldi;

drop table if exists Mannfjoldi;
create table Mannfjoldi(
sveitarfelagsNumer int not null,
sveitarfelag char(30) not null,
fjoldi int not null,
dagsetning date not null
);

select*from Mannfjoldi;

delimiter €€
drop procedure if exists mannfjoldo €€
CREATE PROCEDURE mannfjoldar()
begin
select * from Mannfjoldi;
end €€
-- Test
call mannfjoldar;


-- 1. Birta allar upplýsingar um ákveðið sveitarfélag 
delimiter €€
drop procedure if exists sveitarFelag €€
CREATE PROCEDURE sveitarFelag(in sveitarNafn varchar(30))
begin
SELECT * FROM Mannfjoldi WHERE sveitarfelag = sveitarNafn;
end €€

-- Test 
call sveitarFelag('Reykjavík'); 
call sveitarFelag('Kópavogur');

-- 2. Birta yfirlit yfir landssvæði 
delimiter €€
drop procedure if exists svaedi €€
create procedure svaedi(in byrjunTala varchar(30))
begin
SELECT * FROM Mannfjoldi WHERE sveitarfelagsNumer LIKE byrjunTala;
end €€

-- Test 
call svaedi('1%');
call svaedi('3%');
call svaedi('7%');


-- 3. Birta heildarmannfölda fyrir ákveðið ár 
delimiter €€
drop procedure if exists summuAr;
create procedure summuAr(in talan int)
begin
select SUM(fjoldi) as 'Summa' from Mannfjoldi where extract(Year from dagsetning ) = talan; 
end €€
select * from Mannfjoldi;

-- Test 
call summuAr(2017);
call summuAr(2018);


-- 4. Birta breytinu á mannfjölda milli ákveðinna ára sem hlutfall af mannfjölda 
delimiter €€
drop procedure if exists hlutfall;
create procedure hlutfall(in ar int, in ar2 int)
begin
declare fjoldiAr int;
declare fjoldiAr2 int;
select SUM(fjoldi) as 'Summa' from Mannfjoldi where extract(Year from dagsetning ) = ar into fjoldiAr;
select SUM(fjoldi) as 'Summa' from Mannfjoldi where extract(Year from dagsetning ) = ar2 into fjoldiAr2;
select fjoldiAr2/fjoldiAr;
end €€

-- Test 
call hlutfall(2017, 2018);


-- 5. Birta mannfjöldabreytingu ákveðins sveitarfélags milli ákveðinna ára 
delimiter €€
drop procedure if exists sveitarHlutfall;
create procedure sveitarHlutfall(in sveit varchar(30), in ar int, in ar2 int)
begin
declare fjoldiAr int;
declare fjoldiAr2 int;
select SUM(fjoldi) as 'Summa' from Mannfjoldi where sveitarfelagsNumer = sveit and extract(Year from dagsetning ) = ar into fjoldiAr;
select SUM(fjoldi) as 'Summa' from Mannfjoldi where sveitarfelagsNumer = sveit and extract(Year from dagsetning ) = ar2 into fjoldiAr2;
select fjoldiAr2/fjoldiAr;
end €€

-- Test 
call sveitarHlutfall('1300', 2017, 2018);


-- 6. Birta heildarmannfjölda ákveðins landssvæðis 
delimiter €€
drop procedure if exists sveitarHlutfall;
create procedure sveitarHlutfall(in sveit varchar(30), in ar int)
begin
select SUM(fjoldi) as 'Summa' from Mannfjoldi where sveitarfelagsNumer like sveit and extract(Year from dagsetning ) = ar;
end €€

-- Test 
call sveitarHlutfall('1%', 2017);


-- JSON hlutinn 
drop table if exists MannfjoldiJson;
create table MannfjoldiJson as 
select JSON_ARRAYAGG(JSON_OBJECT('SveitarfelagsNumer',sveitarfelagsNumer,'Sveitarfelag',sveitarfelag,'Fjoldi',fjoldi,'Dagsetning',dagsetning)) as jason from Mannfjoldi ;

-- Test
select jason from MannfjoldiJson;
























insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(0,"Reykjavík",126108,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(1000,"Kópavogur",35903,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(1100,"Seltjarnarnesbær",4569,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(1300,"Garðabær",15691,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(1400,"Hafnarfjörður",29371,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(1604,"Mosfellsbær",10514,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(1606,"Kjósarhreppur",221,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(2000,"Reykjanesbær",17732,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(2300,"Grindavíkurbær",3326,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(2503,"Sandgerðisbær",1785,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(2504,"SveitarfélagiðGarður",1599,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(2506,"SveitarfélagiðVogar",1269,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3000,"Akraneskaupstaður",7225,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3506,"Skorradalshreppur",56,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3511,"Hvalfjarðarsveit",656,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3609,"Borgarbyggð",3745,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3709,"Grundarfjarðarbær",884,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3710,"Helgafellssveit",59,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3711,"Stykkishólmsbær",1178,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3713,"Eyja-ogMiklaholtshreppur",123,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3714,"Snæfellsbær",1637,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3811,"Dalabyggð",666,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4100,"Bolungarvíkurkaupstaður",943,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4200,"Ísafjarðarbær",3709,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4502,"Reykhólahreppur",277,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4604,"Tálknafjarðarhreppur",245,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4607,"Vesturbyggð",1023,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4803,"Súðavíkurhreppur",196,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4901,"Árneshreppur",41,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4902,"Kaldrananeshreppur",109,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4911,"Strandabyggð",449,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5200,"SveitarfélagiðSkagafjörður",3945,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5508,"Húnaþingvestra",1190,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5604,"Blönduósbær",892,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5609,"SveitarfélagiðSkagaströnd",480,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5611,"Skagabyggð",92,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5612,"Húnavatnshreppur",387,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5706,"Akrahreppur",194,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6000,"Akureyrarkaupstaður",18789,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6100,"Norðurþing",3278,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6250,"Fjallabyggð",2011,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6400,"Dalvíkurbyggð",1889,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6513,"Eyjafjarðarsveit",1012,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6515,"Hörgársveit",581,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6601,"Svalbarðsstrandarhreppur",482,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6602,"Grýtubakkahreppur",372,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6607,"Skútustaðahreppur",493,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6611,"Tjörneshreppur",58,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6612,"Þingeyjarsveit",969,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6706,"Svalbarðshreppur",92,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6709,"Langanesbyggð",480,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7000,"Seyðisfjarðarkaupstaður",674,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7300,"Fjarðabyggð",4780,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7502,"Vopnafjarðarhreppur",661,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7505,"Fljótsdalshreppur",76,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7509,"Borgarfjarðarhreppur",108,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7613,"Breiðdalshreppur",183,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7617,"Djúpavogshreppur",461,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7620,"Fljótsdalshérað",3545,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7708,"SveitarfélagiðHornafjörður",2299,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8000,"Vestmannaeyjabær",4283,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8200,"SveitarfélagiðÁrborg",8964,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8508,"Mýrdalshreppur",626,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8509,"Skaftárhreppur",564,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8610,"Ásahreppur",251,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8613,"Rangárþingeystra",1801,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8614,"Rangárþingytra",1599,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8710,"Hrunamannahreppur",777,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8716,"Hveragerðisbær",2554,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8717,"SveitarfélagiðÖlfus",2106,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8719,"Grímsnes-ogGrafningshreppur",479,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8720,"Skeiða-ogGnúpverjahreppur",679,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8721,"Bláskógabyggð",1115,"2017-12-01");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8722,"Flóahreppur",640,"2017-12-01");


insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(0,"Reykjavík",126771,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(1000,"Kópavogur",36290,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(1100,"Seltjarnarnesbær",4608,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(1300,"Garðabær",15869,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(1400,"Hafnarfjörður",29603,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(1604,"Mosfellsbær",10730,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(1606,"Kjósarhreppur",227,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(2000,"Reykjanesbær",18074,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(2300,"Grindavíkurbær",3380,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(2503,"Sandgerðisbær",1807,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(2504,"SveitarfélagiðGarður",1597,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(2506,"SveitarfélagiðVogar",1275,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3000,"Akraneskaupstaður",7299,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3506,"Skorradalshreppur",55,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3511,"Hvalfjarðarsveit",649,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3609,"Borgarbyggð",3751,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3709,"Grundarfjarðarbær",888,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3710,"Helgafellssveit",59,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3711,"Stykkishólmsbær",1186,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3713,"Eyja-ogMiklaholtshreppur",126,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3714,"Snæfellsbær",1672,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(3811,"Dalabyggð",663,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4100,"Bolungarvíkurkaupstaður",935,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4200,"Ísafjarðarbær",3771,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4502,"Reykhólahreppur",278,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4604,"Tálknafjarðarhreppur",244,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4607,"Vesturbyggð",1004,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4803,"Súðavíkurhreppur",200,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4901,"Árneshreppur",45,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4902,"Kaldrananeshreppur",108,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(4911,"Strandabyggð",451,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5200,"SveitarfélagiðSkagafjörður",3985,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5508,"Húnaþingvestra",1184,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5604,"Blönduósbær",906,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5609,"SveitarfélagiðSkagaströnd",466,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5611,"Skagabyggð",88,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5612,"Húnavatnshreppur",379,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(5706,"Akrahreppur",195,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6000,"Akureyrarkaupstaður",18817,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6100,"Norðurþing",3202,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6250,"Fjallabyggð",2013,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6400,"Dalvíkurbyggð",1886,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6513,"Eyjafjarðarsveit",1017,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6515,"Hörgársveit",596,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6601,"Svalbarðsstrandarhreppur",499,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6602,"Grýtubakkahreppur",365,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6607,"Skútustaðahreppur",507,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6611,"Tjörneshreppur",58,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6612,"Þingeyjarsveit",930,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6706,"Svalbarðshreppur",93,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(6709,"Langanesbyggð",493,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7000,"Seyðisfjarðarkaupstaður",687,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7300,"Fjarðabyggð",4810,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7502,"Vopnafjarðarhreppur",657,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7505,"Fljótsdalshreppur",74,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7509,"Borgarfjarðarhreppur",105,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7613,"Breiðdalshreppur",191,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7617,"Djúpavogshreppur",462,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7620,"Fljótsdalshérað",3540,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(7708,"SveitarfélagiðHornafjörður",2323,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8000,"Vestmannaeyjabær",4289,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8200,"SveitarfélagiðÁrborg",9131,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8508,"Mýrdalshreppur",652,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8509,"Skaftárhreppur",568,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8610,"Ásahreppur",243,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8613,"Rangárþingeystra",1818,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8614,"Rangárþingytra",1608,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8710,"Hrunamannahreppur",780,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8716,"Hveragerðisbær",2582,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8717,"SveitarfélagiðÖlfus",2111,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8719,"Grímsnes-ogGrafningshreppur",468,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8720,"Skeiða-ogGnúpverjahreppur",701,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8721,"Bláskógabyggð",1108,"2018-04-15");
insert into Mannfjoldi(sveitarfelagsNumer,sveitarfelag,fjoldi,dagsetning)values(8722,"Flóahreppur",646,"2018-04-15");
