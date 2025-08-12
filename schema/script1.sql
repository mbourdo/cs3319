-- ---------------------------------
-- SCRIPT 1

-- Set up the database
SHOW DATABASES;
DROP DATABASE IF EXISTS assign2db;
CREATE DATABASE assign2db;
USE assign2db; 

-- Create the tables for the database
SHOW TABLES;

CREATE TABLE doctor(docid CHAR(5) NOT NULL, firstname VARCHAR(20) NOT NULL, lastname VARCHAR(20) NOT NULL, birthdate DATE, startdate DATE, PRIMARY KEY(docid));

CREATE TABLE patient (ohip CHAR(9) NOT NULL, firstname VARCHAR(20) NOT NULL, lastname VARCHAR(20), weight SMALLINT, birthdate DATE, height DECIMAL(3,2), treatsdocid CHAR(5), PRIMARY KEY(ohip), FOREIGN KEY (treatsdocid) REFERENCES doctor(docid) ON DELETE RESTRICT);

CREATE TABLE nurse (nurseid CHAR(5) NOT NULL, firstname VARCHAR(20) NOT NULL, lastname VARCHAR(20) NOT NULL, startdate DATE, reporttonurseid CHAR(5),  PRIMARY KEY(nurseid), FOREIGN KEY(reporttonurseid) REFERENCES nurse(nurseid));

CREATE TABLE workingfor (docid CHAR(5), nurseid CHAR(5), hours SMALLINT, PRIMARY KEY (docid, nurseid), FOREIGN KEY(docid) REFERENCES doctor(docid), FOREIGN KEY(nurseid) REFERENCES nurse(nurseid));

SHOW TABLES;

-- ------------------------------------
-- insert some data

-- insert into the doctor table
SELECT * FROM doctor;
INSERT INTO doctor (docid, firstname, lastname, birthdate, startdate) VALUES
('RAD34', 'Sue', 'Tanaka', '1978-06-15', '2010-04-20'),
('AGD56', 'Sean', 'Aziz', '1985-02-23', '2015-08-14'),
('HIT45', 'Scott', 'Mortensen', '1960-11-07', '2000-12-01'),
('YRT67', 'Gerry', 'Webster', '1972-04-11', '2005-07-18'),
('JKK78', 'Jon', 'Joselyn', '1980-09-19', '2012-03-25'),
('SEE66', 'Colleen', 'Tyler', '1965-01-30', '1999-09-10');
SELECT * FROM doctor;

-- insert into the patient table
SELECT * FROM patient;
INSERT INTO patient (ohip, firstname, lastname, weight, birthdate, height, treatsdocid) VALUES
('111111111', 'Homer', 'Simpson', 66, '1987-02-02', 1.81, 'AGD56'),
('222222222', 'Marge', 'Simpson', 58, '1990-03-19', 1.72, 'RAD34'),
('333333333', 'Bart', 'Simpson', 40, '2010-04-01', 1.55, 'AGD56'),
('444444444', 'Lisa', 'Simpson', 30, '2012-05-09', 1.45, 'AGD56'),
('555555555', 'Maggie', 'Simpson', 20, '2020-06-21', 0.91, 'AGD56'),
('666666666', 'Ned', 'Flanders', 80, '1968-01-15', 1.75, 'YRT67'),
('777777777', 'Jon', 'Burns', 70, '1930-02-22', 1.68, 'YRT67'),
('888888888', 'Rod', 'Flanders', 45, '2000-11-05', 1.60, 'SEE66'),
('999999999', 'Todd', 'Flanders', 50, '1999-12-12', 1.65, 'SEE66'),
('000000000', 'Milhouse', 'Van Houten', 60, '1985-07-15', 1.70, 'RAD34');
SELECT * FROM patient;

-- insert into the nurse table
SELECT * FROM nurse;
INSERT INTO nurse (nurseid, firstname, lastname, startdate, reporttonurseid) VALUES ('AAAA1', 'Hannah', 'Montana', '2020-03-03', NULL),
('BBBB2', 'Alex', 'Russo', '2018-07-10', NULL),
('CCCC3', 'Justin', 'Russo', '2015-06-12', NULL),
('DDDD4', 'Max', 'Russo', '2017-05-15', NULL),
('EEEE5', 'Miley', 'Stewart', '2019-08-20', NULL),
('FFFF6', 'Lilly', 'Truscott', '2021-02-14', NULL),
('GGGG7', 'Oliver', 'Oken', '2016-11-30', NULL),
('HHHH8', 'Harper', 'Finkle', '2014-09-25', NULL);
SELECT * FROM nurse;

-- insert into the workingfor table
SELECT * FROM workingfor;
INSERT INTO workingfor (docid, nurseid, hours) VALUES
('RAD34','BBBB2',100), ('RAD34','CCCC3',242),('RAD34','HHHH8',22),('SEE66','BBBB2',100),('SEE66','CCCC3',55), ('AGD56','CCCC3',55), ('AGD56','DDDD4',75), ('AGD56','BBBB2',55), ('YRT67','FFFF6',100), ('JKK78','HHHH8',200),('RAD34','GGGG7',10),('SEE66','GGGG7',20),('AGD56','GGGG7',15),('YRT67','GGGG7',5),('JKK78','GGGG7',7),('YRT67','EEEE5',33);
SELECT * FROM workingfor;

-- assign the nurses to their supervisors
UPDATE nurse SET reporttonurseid='BBBB2' WHERE firstname='Max' OR firstname='Justin';
UPDATE nurse SET reporttonurseid='HHHH8' WHERE nurseid='BBBB2';
UPDATE nurse SET reporttonurseid='EEEE5' WHERE nurseid="GGGG7" OR nurseid="FFFF6" OR nurseid="GGGG7";
SELECT * FROM nurse;
