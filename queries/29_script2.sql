-- ---------------------------------
-- SCRIPT 2

-- Use database
USE assign2db;
 
-- Part 1 SQL Updates
-- Show all data in the nurse table before modifying it
SELECT * FROM nurse;

-- Update any nurse with the firstname 'Miley' to have the lastname 'Cyrus'
UPDATE nurse SET lastname = 'Cyrus' WHERE firstname = 'Miley';

-- Update the start date for any nurse working with Dr. Tanaka to match Dr. Tanaka's start date
UPDATE nurse AS n
JOIN workingfor AS wf ON n.nurseid = wf.nurseid
JOIN doctor AS d ON wf.docid = d.docid
SET n.startdate = d.startdate
WHERE d.lastname = 'Tanaka';

-- Show all data in the nurse table after modifications to confirm updates
SELECT * FROM nurse;

-- Part 2 SQL Inserts
-- Insert a new doctor (TV character) into the doctor table
INSERT INTO doctor (docid, firstname, lastname, birthdate, startdate) VALUES ('DOC10', 'Gregory', 'House', '2003-02-15', '2020-01-01');

-- Insert a new patient (TV character) who reports to the new doctor
INSERT INTO patient (ohip, firstname, lastname, weight, birthdate, height, treatsdocid)VALUES ('295512515', 'James', 'Wilson', 80, '1970-08-17', 2.11, 'DOC10');

-- Insert a new nurse (TV actor) into the nurse table and assign hours with the new doctor
INSERT INTO nurse (nurseid, firstname, lastname, startdate, reporttonurseid) VALUES ('NRS10', 'Blake', 'Lively', '2018-07-11', 'BBBB2');
INSERT INTO workingfor (docid, nurseid, hours) VALUES ('DOC10','NRS10',50);

-- Verify all new data
SELECT * FROM doctor;
SELECT * FROM patient;
SELECT * FROM nurse;
SELECT * FROM workingfor;

-- Part 3 SQL Queries
-- Query 1: Show the last names of all patients
SELECT lastname FROM patient;

-- Query 2: Show unique last names of all patients
SELECT DISTINCT lastname FROM patient;

-- Query 3: Show all doctors ordered by their start date
SELECT * FROM doctor ORDER BY startdate;

-- Query 4: Show OHIP, first and last name, and weight of patients 50kg or more
SELECT ohip, firstname, lastname, weight 
FROM patient 
WHERE weight >= 50 
ORDER BY weight;

-- Query 5: List first and last names of patients with Dr. Tanaka
SELECT p.firstname, p.lastname 
FROM patient AS p 
JOIN doctor AS d ON p.treatsdocid = d.docid 
WHERE d.lastname = 'Tanaka';

-- Query 6: List doctors with their patients (null if no patients)
SELECT d.firstname AS doctor_firstname, d.lastname AS doctor_lastname, 
       p.firstname AS patient_firstname, p.lastname AS patient_lastname
FROM doctor AS d
LEFT JOIN patient AS p ON d.docid = p.treatsdocid;

-- Query 7: Find doctors with no patients
SELECT firstname, lastname FROM doctor 
WHERE docid NOT IN (SELECT treatsdocid FROM patient);

-- Query 8: Find the average hours worked by nurses for all doctors
SELECT SUM(wf.hours) / COUNT(DISTINCT n.nurseid) AS avg_hours
FROM workingfor AS wf 
JOIN nurse AS n ON wf.nurseid = n.nurseid;

-- Query 9: List nurses and their supervisors
SELECT n1.firstname AS "Nurse First Name", n1.lastname AS "Nurse Last Name", 
       n2.firstname AS "Supervisor First Name", n2.lastname AS "Supervisor Last Name"
FROM nurse AS n1
LEFT JOIN nurse AS n2 ON n1.reporttonurseid = n2.nurseid;

-- Query 10: Find total pay for each nurse and order by highest to lowest
SELECT n.firstname AS "Nurse First Name", 
       n.lastname AS "Nurse Last Name", 
       SUM(wf.hours) AS "Total Hours", CONCAT('$', FORMAT(SUM(wf.hours) * 30, 2)) AS "Total Pay"
FROM nurse AS n
JOIN workingfor AS wf ON n.nurseid = wf.nurseid
GROUP BY n.nurseid
ORDER BY SUM(wf.hours) DESC;

-- Query 11: List patients and potential nurses based on their doctor
SELECT p.firstname AS patient_firstname, p.lastname AS patient_lastname, 
       n.firstname AS nurse_firstname, n.lastname AS nurse_lastname
FROM patient AS p
JOIN doctor AS d ON p.treatsdocid = d.docid
JOIN workingfor AS wf ON d.docid = wf.docid
JOIN nurse AS n ON wf.nurseid = n.nurseid
ORDER BY p.firstname;

-- Query 12: List patients and doctors where the doctor is younger than the patient
SELECT p.firstname AS " Patient First", p.lastname AS "Patient Last", 
       TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) AS "Patient age", p.birthdate AS "Patient Birthdate", 
       d.firstname AS "Dr First", d.lastname AS "Dr Last", 
       TIMESTAMPDIFF(YEAR, d.birthdate, CURDATE()) AS "Dr age", d.birthdate AS "Dr Birth Date"
FROM patient AS p
JOIN doctor AS d ON p.treatsdocid = d.docid
WHERE TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) > TIMESTAMPDIFF(YEAR, d.birthdate, CURDATE());

-- Query 13: List nurses not working for Dr. Tanaka (no repeats)
SELECT DISTINCT n.firstname, n.lastname
FROM nurse AS n
JOIN workingfor AS wf ON n.nurseid = wf.nurseid
JOIN doctor AS d ON wf.docid = d.docid
WHERE d.lastname != 'Tanaka';

-- Query 14: Find nurses working for more than 1 doctor
SELECT n.firstname, n.lastname, COUNT(wf.docid) AS num_doctors
FROM nurse AS n
JOIN workingfor AS wf ON n.nurseid = wf.nurseid
GROUP BY n.nurseid
HAVING COUNT(wf.docid) > 1;

-- Query 15 - My Query: List all doctors younger than 30 
SELECT firstname, lastname, TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) AS age
FROM doctor
WHERE TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) < 30;


-- Part 4 SQL Views/Deletes
-- Create a view showing doctors and their patient count
CREATE VIEW doctor_patient_count AS
SELECT d.firstname, d.lastname, COUNT(p.ohip) AS numofpat
FROM doctor AS d
LEFT JOIN patient AS p ON d.docid = p.treatsdocid
GROUP BY d.docid;

-- Show doctors with exactly 2 patients from the view
SELECT * FROM doctor_patient_count WHERE numofpat = 2;

-- Show all doctor information
SELECT * FROM doctor; 

-- Delete doctor with id HIT45 and verify deletion
DELETE FROM doctor WHERE docid = 'HIT45';
SELECT * FROM doctor;

-- Count number of doctors remaining
SELECT COUNT(*) AS doctor_count FROM doctor;

-- Delete doctor with id RAD34 and verify deletion
DELETE FROM doctor WHERE docid = 'RAD34';
SELECT COUNT(*) AS doctor_count FROM doctor;

-- Explanation: 
-- Deletions were performed to remove inactive or reassigned doctors.
-- Doctor 'HIT45' was successfully deleted as there were no dependencies preventing the deletion. 
-- Doctor 'RAD34' may not have been deleted if there were patients or other dependencies linked to them, enforcing referential integrity.



