USE clinic;

-- SELECT * FROM patient;

-- drops for testing
DROP TABLE IF EXISTS Medical_Record_Procedures;
DROP TABLE IF EXISTS Medical_Record_Diagnoses;
DROP TABLE IF EXISTS MedicalRecord_Medications_Prescribed;
DROP TABLE IF EXISTS Medical_Records_CPT_Codes;
DROP TABLE IF EXISTS Receptionist_Record_Access;
DROP TABLE IF EXISTS Medical_Record;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Patient_Medications;
DROP TABLE IF EXISTS Patient_Allergies;
DROP TABLE IF EXISTS Patient;
DROP TABLE IF EXISTS Physician_Subspecialties;
DROP TABLE IF EXISTS Receptionist;
DROP TABLE IF EXISTS Physician;
DROP TABLE IF EXISTS Staff_Emergency_Numbers;
DROP TABLE IF EXISTS Staff;

CREATE TABLE Staff(
Staff_ID INT PRIMARY KEY,
Name VARCHAR(100) NOT NULL,
SSN CHAR(9) UNIQUE NOT NULL, 
Date_of_Birth DATE NOT NULL,
Date_of_Employment DATE NOT NULL,
Type VARCHAR(50) NOT NULL, -- physician or receptionist
Company_email VARCHAR(100) UNIQUE NOT NULL,
Home_Address VARCHAR(255),
Company_Phone_Number VARCHAR(15),
Health_Screening_Complete BOOLEAN DEFAULT FALSE, 
Background_Check_Complete BOOLEAN DEFAULT FALSE
);


CREATE TABLE Staff_Emergency_Numbers(
Staff_ID INT,
Emergency_Phone_Number VARCHAR(10),
PRIMARY KEY (Staff_ID, Emergency_Phone_Number), -- composite key
FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID)
);


-- Staff types

CREATE TABLE Physician(
Physician_ID INT PRIMARY KEY,
STAFF_ID INT UNIQUE NOT NULL, -- 1 to 1 with staff
National_Provider_Identifier CHAR(10) UNIQUE NOT NULL,
Specialty VARCHAR(100) NOT NULL,
FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID)
);

CREATE TABLE Receptionist(
Receptionist_ID INT PRIMARY KEY,
Staff_ID INT UNIQUE NOT NULL, -- 1 to 1 with staff
Position VARCHAR(100) NOT NULL,
FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID)
);


CREATE TABLE Physician_Subspecialties(
Physician_ID INT,
Subspecialty VARCHAR(100),
PRIMARY KEY (Physician_ID, Subspecialty), -- composite primary key
FOREIGN KEY (Physician_ID) REFERENCES Physician(Physician_ID)
);




-- patient tables

CREATE TABLE Patient(
Patient_ID INT PRIMARY KEY,
Physician_ID INT, -- foreign key to primary physician
Name VARCHAR(100) NOT NULL,
SSN CHAR(9) UNIQUE NOT NULL,
Date_Of_Birth DATE NOT NULL,
Home_Address VARCHAR(255),
Insurance VARCHAR(255),
Balance DECIMAL(10, 2) DEFAULT 0.00,
Preferred_Pharmacy_Address VARCHAR(255),
Medical_Record_Number VARCHAR(50) UNIQUE NOT NULL,
FOREIGN KEY (Physician_ID) REFERENCES Physician(Physician_ID)
);


CREATE TABLE Patient_Allergies(
Patient_ID INT,
Allergy VARCHAR(100),
PRIMARY KEY (Patient_ID, Allergy),
FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID)
);


CREATE TABLE Patient_Medications(
Patient_ID INT,
Medication VARCHAR(100),
PRIMARY KEY (Patient_ID, Medication),
FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID)
);





CREATE TABLE Appointment(
Appointment_ID INT PRIMARY KEY,
Patient_ID INT NOT NULL,
Physician_ID INT NOT NULL,
Receptionist_ID INT NOT NULL,
Medical_Record_Number VARCHAR(50),
Duration INT, -- minutes?
Reason VARCHAR(255),
Date DATE NOT NULL,
Time TIME NOT NULL,
FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
FOREIGN KEY (Physician_ID) REFERENCES Physician(Physician_ID),
FOREIGN KEY (Receptionist_ID) REFERENCES Receptionist(Receptionist_ID)
);


CREATE TABLE Medical_Record(
Record_ID INT PRIMARY KEY,
Appointment_ID INT UNIQUE NOT NULL, -- 1 to 1 with appointment
Medical_Record_Number VARCHAR(50) NOT NULL,
Heart_Rate INT,
Physician_Notes TEXT,
Non_Physician_Notes TEXT,
Chief_Complaint VARCHAR(255),
Date DATE,
Time TIME,
Blood_Pressure VARCHAR(20),
Weight DECIMAL(5, 2),
Height DECIMAL(4, 2),
Glucose_Level INT,
FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID)
);




-- record dependencies and multi value tables

CREATE TABLE Receptionist_Record_Access(
Receptionist_ID INT,
Record_ID INT,
PRIMARY KEY (Receptionist_ID, Record_ID),
FOREIGN KEY (Receptionist_ID) REFERENCES Receptionist(Receptionist_ID),
FOREIGN KEY (Record_ID) REFERENCES Medical_Record(Record_ID)
);


CREATE TABLE Medical_Records_CPT_Codes(
    Record_ID INT,
    CPT_Code VARCHAR(20),
    PRIMARY KEY (Record_ID, CPT_Code),
    FOREIGN KEY (Record_ID) REFERENCES Medical_Record(Record_ID)
);

CREATE TABLE MedicalRecord_Medications_Prescribed(
    Record_ID INT,
    Medication_Prescribed VARCHAR(100),
    PRIMARY KEY (Record_ID, Medication_Prescribed),
    FOREIGN KEY (Record_ID) REFERENCES Medical_Record(Record_ID)
);

CREATE TABLE Medical_Record_Diagnoses(
    Record_ID INT,
    Diagnosis VARCHAR(255),
    PRIMARY KEY (Record_ID, Diagnosis),
    FOREIGN KEY (Record_ID) REFERENCES Medical_Record(Record_ID)
);

Create TABLE Medical_Record_Procedures(
Record_ID INT,
Procedure_Name VARCHAR(255), -- procedure is already a thing so I added _Name
PRIMARY KEY (Record_ID, Procedure_name),
FOREIGN KEY (Record_ID) REFERENCES Medical_Record(Record_ID)
);
    
    
    
    




-- SAMPLE DATA BELOW

-- ==========================================
-- BLOCK 1: STAFF & PROVIDERS
-- ==========================================

-- 1. Insert 48 Staff (IDs 101-124 are Physicians, 201-224 are Receptionists)
INSERT INTO Staff (Staff_ID, Name, SSN, Date_of_Birth, Date_of_Employment, Type, Company_email, Home_Address, Company_Phone_Number, Health_Screening_Complete, Background_Check_Complete) VALUES 
(101, 'Dr. Sarah Jenkins', '000000101', '1980-05-14', '2015-08-01', 'Physician', 's.jenkins@clinic.com', '123 Oak Ln, San Antonio, TX', '555-0101', TRUE, TRUE),
(102, 'Dr. Mark Allen', '000000102', '1975-11-22', '2012-03-15', 'Physician', 'm.allen@clinic.com', '456 Pine St, San Antonio, TX', '555-0102', TRUE, TRUE),
(103, 'Dr. Emily Carter', '000000103', '1988-01-30', '2019-06-01', 'Physician', 'e.carter@clinic.com', '789 Maple Ave, San Antonio, TX', '555-0103', TRUE, TRUE),
(104, 'Dr. Robert King', '000000104', '1965-07-19', '2005-09-10', 'Physician', 'r.king@clinic.com', '321 Elm St, San Antonio, TX', '555-0104', TRUE, TRUE),
(105, 'Dr. Jessica Wright', '000000105', '1990-04-12', '2021-01-20', 'Physician', 'j.wright@clinic.com', '654 Cedar Blvd, San Antonio, TX', '555-0105', TRUE, TRUE),
(106, 'Dr. William Scott', '000000106', '1982-08-05', '2016-11-01', 'Physician', 'w.scott@clinic.com', '987 Birch Rd, San Antonio, TX', '555-0106', TRUE, TRUE),
(107, 'Dr. Ashley Green', '000000107', '1985-02-14', '2018-05-15', 'Physician', 'a.green@clinic.com', '111 Walnut St, San Antonio, TX', '555-0107', TRUE, TRUE),
(108, 'Dr. Brian Adams', '000000108', '1978-09-21', '2010-08-25', 'Physician', 'b.adams@clinic.com', '222 Chestnut Ln, San Antonio, TX', '555-0108', TRUE, TRUE),
(109, 'Dr. Laura Nelson', '000000109', '1983-12-03', '2017-04-10', 'Physician', 'l.nelson@clinic.com', '333 Spruce Ave, San Antonio, TX', '555-0109', TRUE, TRUE),
(110, 'Dr. Kevin Hill', '000000110', '1972-06-18', '2008-02-28', 'Physician', 'k.hill@clinic.com', '444 Ash Dr, San Antonio, TX', '555-0110', TRUE, TRUE),
(111, 'Dr. Megan Baker', '000000111', '1989-10-09', '2020-07-01', 'Physician', 'm.baker@clinic.com', '555 Poplar St, San Antonio, TX', '555-0111', TRUE, TRUE),
(112, 'Dr. Jason Perez', '000000112', '1970-03-27', '2006-12-05', 'Physician', 'j.perez@clinic.com', '666 Cypress Blvd, San Antonio, TX', '555-0112', TRUE, TRUE),
(113, 'Dr. Rachel Roberts', '000000113', '1986-05-11', '2019-09-15', 'Physician', 'r.roberts@clinic.com', '777 Fir Pl, San Antonio, TX', '555-0113', TRUE, TRUE),
(114, 'Dr. David Turner', '000000114', '1979-08-22', '2014-01-10', 'Physician', 'd.turner@clinic.com', '888 Redwood Way, San Antonio, TX', '555-0114', TRUE, TRUE),
(115, 'Dr. Sarah Phillips', '000000115', '1991-02-08', '2022-06-01', 'Physician', 's.phillips@clinic.com', '999 Willow Ct, San Antonio, TX', '555-0115', TRUE, TRUE),
(116, 'Dr. Christopher Campbell', '000000116', '1974-11-15', '2009-03-20', 'Physician', 'c.campbell@clinic.com', '121 Aspen Rd, San Antonio, TX', '555-0116', TRUE, TRUE),
(117, 'Dr. Amanda Parker', '000000117', '1984-04-04', '2017-08-01', 'Physician', 'a.parker@clinic.com', '232 Hickory Ln, San Antonio, TX', '555-0117', TRUE, TRUE),
(118, 'Dr. Matthew Evans', '000000118', '1981-09-12', '2015-11-15', 'Physician', 'm.evans@clinic.com', '343 Dogwood St, San Antonio, TX', '555-0118', TRUE, TRUE),
(119, 'Dr. Nicole Edwards', '000000119', '1987-01-25', '2020-02-10', 'Physician', 'n.edwards@clinic.com', '454 Sycamore Ave, San Antonio, TX', '555-0119', TRUE, TRUE),
(120, 'Dr. Daniel Collins', '000000120', '1976-07-08', '2011-05-25', 'Physician', 'd.collins@clinic.com', '565 Magnolia Blvd, San Antonio, TX', '555-0120', TRUE, TRUE),
(121, 'Dr. Melissa Stewart', '000000121', '1992-10-14', '2023-01-05', 'Physician', 'm.stewart@clinic.com', '676 Palm Dr, San Antonio, TX', '555-0121', TRUE, TRUE),
(122, 'Dr. Justin Sanchez', '000000122', '1973-03-19', '2007-09-01', 'Physician', 'j.sanchez@clinic.com', '787 Olive Pl, San Antonio, TX', '555-0122', TRUE, TRUE),
(123, 'Dr. Heather Morris', '000000123', '1985-06-28', '2018-12-10', 'Physician', 'h.morris@clinic.com', '898 Peach Way, San Antonio, TX', '555-0123', TRUE, TRUE),
(124, 'Dr. Andrew Rogers', '000000124', '1980-12-07', '2016-04-15', 'Physician', 'a.rogers@clinic.com', '909 Cherry Ct, San Antonio, TX', '555-0124', TRUE, TRUE),
(201, 'Pam Beesly', '000000201', '1979-03-25', '2018-10-01', 'Receptionist', 'p.beesly@clinic.com', '17 Scranton Rd, San Antonio, TX', '555-0201', TRUE, TRUE),
(202, 'Donna Meagle', '000000202', '1976-11-18', '2015-01-10', 'Receptionist', 'd.meagle@clinic.com', 'Treat Yo Self Ln, San Antonio, TX', '555-0202', TRUE, TRUE),
(203, 'Angela Martin', '000000203', '1971-06-25', '2010-04-12', 'Receptionist', 'a.martin@clinic.com', '21 Cat Ave, San Antonio, TX', '555-0203', TRUE, TRUE),
(204, 'Tom Haverford', '000000204', '1985-02-28', '2019-07-01', 'Receptionist', 't.haverford@clinic.com', 'Swag Blvd, San Antonio, TX', '555-0204', TRUE, TRUE),
(205, 'Kelly Kapoor', '000000205', '1982-10-15', '2016-09-20', 'Receptionist', 'k.kapoor@clinic.com', 'Gossip St, San Antonio, TX', '555-0205', TRUE, TRUE),
(206, 'April Ludgate', '000000206', '1992-04-01', '2021-03-15', 'Receptionist', 'a.ludgate@clinic.com', 'Darkness Way, San Antonio, TX', '555-0206', TRUE, TRUE),
(207, 'Erin Hannon', '000000207', '1988-08-20', '2020-01-10', 'Receptionist', 'e.hannon@clinic.com', 'Sunshine Pl, San Antonio, TX', '555-0207', TRUE, TRUE),
(208, 'Andy Dwyer', '000000208', '1981-05-12', '2017-11-05', 'Receptionist', 'a.dwyer@clinic.com', 'Pit Rd, San Antonio, TX', '555-0208', TRUE, TRUE),
(209, 'Phyllis Vance', '000000209', '1965-01-30', '2005-08-25', 'Receptionist', 'p.vance@clinic.com', 'Refrigeration Ln, San Antonio, TX', '555-0209', TRUE, TRUE),
(210, 'Jerry Gergich', '000000210', '1958-12-14', '2000-02-18', 'Receptionist', 'j.gergich@clinic.com', 'Clumsy Ct, San Antonio, TX', '555-0210', TRUE, TRUE),
(211, 'Ryan Howard', '000000211', '1984-07-05', '2018-06-30', 'Receptionist', 'r.howard@clinic.com', 'Temp St, San Antonio, TX', '555-0211', TRUE, TRUE),
(212, 'Ann Perkins', '000000212', '1980-09-22', '2014-10-15', 'Receptionist', 'a.perkins@clinic.com', 'Beautiful Nurse Dr, San Antonio, TX', '555-0212', TRUE, TRUE),
(213, 'Oscar Martinez', '000000213', '1973-03-10', '2008-05-20', 'Receptionist', 'o.martinez@clinic.com', 'Accountant Ave, San Antonio, TX', '555-0213', TRUE, TRUE),
(214, 'Chris Traeger', '000000214', '1968-08-15', '2012-01-05', 'Receptionist', 'c.traeger@clinic.com', 'Literal Blvd, San Antonio, TX', '555-0214', TRUE, TRUE),
(215, 'Meredith Palmer', '000000215', '1969-11-02', '2009-09-12', 'Receptionist', 'm.palmer@clinic.com', 'Van St, San Antonio, TX', '555-0215', TRUE, TRUE),
(216, 'Ben Wyatt', '000000216', '1978-04-26', '2015-03-01', 'Receptionist', 'b.wyatt@clinic.com', 'Calzone Ln, San Antonio, TX', '555-0216', TRUE, TRUE),
(217, 'Creed Bratton', '000000217', '1945-02-08', '2002-12-10', 'Receptionist', 'c.bratton@clinic.com', 'Unknown Way, San Antonio, TX', '555-0217', TRUE, TRUE),
(218, 'Ron Swanson', '000000218', '1962-10-01', '2004-06-15', 'Receptionist', 'r.swanson@clinic.com', 'Cabin Rd, San Antonio, TX', '555-0218', TRUE, TRUE),
(219, 'Toby Flenderson', '000000219', '1975-01-18', '2011-08-05', 'Receptionist', 't.flenderson@clinic.com', 'HR Pl, San Antonio, TX', '555-0219', TRUE, TRUE),
(220, 'Leslie Knope', '000000220', '1976-05-09', '2013-02-20', 'Receptionist', 'l.knope@clinic.com', 'Waffle Ct, San Antonio, TX', '555-0220', TRUE, TRUE),
(221, 'Stanley Hudson', '000000221', '1959-09-14', '2006-11-30', 'Receptionist', 's.hudson@clinic.com', 'Pretzel St, San Antonio, TX', '555-0221', TRUE, TRUE),
(222, 'Jean-Ralphio Saperstein', '000000222', '1987-03-05', '2022-05-15', 'Receptionist', 'j.saperstein@clinic.com', 'Worst Ave, San Antonio, TX', '555-0222', TRUE, TRUE),
(223, 'Dwight Schrute', '000000223', '1974-06-22', '2007-04-10', 'Receptionist', 'd.schrute@clinic.com', 'Beet Farm Ln, San Antonio, TX', '555-0223', TRUE, TRUE),
(224, 'Mark Brendanawicz', '000000224', '1979-12-11', '2014-09-01', 'Receptionist', 'm.brendanawicz@clinic.com', 'City Hall Dr, San Antonio, TX', '555-0224', TRUE, TRUE);

-- 2. Insert 24 Staff Emergency Numbers
INSERT INTO Staff_Emergency_Numbers (Staff_ID, Emergency_Phone_Number) VALUES 
(101, '555-9901'), (102, '555-9902'), (103, '555-9903'), (104, '555-9904'), (105, '555-9905'),
(106, '555-9906'), (107, '555-9907'), (108, '555-9908'), (109, '555-9909'), (110, '555-9910'),
(201, '555-8801'), (202, '555-8802'), (203, '555-8803'), (204, '555-8804'), (205, '555-8805'),
(206, '555-8806'), (207, '555-8807'), (208, '555-8808'), (209, '555-8809'), (210, '555-8810'),
(211, '555-8811'), (212, '555-8812'), (213, '555-8813'), (214, '555-8814');

-- 3. Insert 24 Physicians (Linking to Staff 101-124)
INSERT INTO Physician (Physician_ID, Staff_ID, National_Provider_Identifier, Specialty) VALUES 
(1, 101, '1000000001', 'Internal Medicine'), (2, 102, '1000000002', 'Cardiology'),
(3, 103, '1000000003', 'Pediatrics'), (4, 104, '1000000004', 'Neurology'),
(5, 105, '1000000005', 'Oncology'), (6, 106, '1000000006', 'Orthopedics'),
(7, 107, '1000000007', 'Dermatology'), (8, 108, '1000000008', 'Psychiatry'),
(9, 109, '1000000009', 'General Surgery'), (10, 110, '1000000010', 'Endocrinology'),
(11, 111, '1000000011', 'Gastroenterology'), (12, 112, '1000000012', 'Pulmonology'),
(13, 113, '1000000013', 'Rheumatology'), (14, 114, '1000000014', 'Nephrology'),
(15, 115, '1000000015', 'Hematology'), (16, 116, '1000000016', 'Urology'),
(17, 117, '1000000017', 'Ophthalmology'), (18, 118, '1000000018', 'Otolaryngology'),
(19, 119, '1000000019', 'Gynecology'), (20, 120, '1000000020', 'Infectious Disease'),
(21, 121, '1000000021', 'Allergy & Immunology'), (22, 122, '1000000022', 'Geriatrics'),
(23, 123, '1000000023', 'Sports Medicine'), (24, 124, '1000000024', 'Emergency Medicine');

-- 4. Insert 24 Receptionists (Linking to Staff 201-224)
INSERT INTO Receptionist (Receptionist_ID, Staff_ID, Position) VALUES 
(1, 201, 'Lead Receptionist'), (2, 202, 'Billing Specialist'),
(3, 203, 'Scheduling Coordinator'), (4, 204, 'Front Desk Clerk'),
(5, 205, 'Records Manager'), (6, 206, 'Intake Specialist'),
(7, 207, 'Patient Advocate'), (8, 208, 'Insurance Coordinator'),
(9, 209, 'Referral Coordinator'), (10, 210, 'Front Desk Clerk'),
(11, 211, 'Front Desk Clerk'), (12, 212, 'Front Desk Clerk'),
(13, 213, 'Front Desk Clerk'), (14, 214, 'Front Desk Clerk'),
(15, 215, 'Front Desk Clerk'), (16, 216, 'Front Desk Clerk'),
(17, 217, 'Front Desk Clerk'), (18, 218, 'Front Desk Clerk'),
(19, 219, 'Front Desk Clerk'), (20, 220, 'Front Desk Clerk'),
(21, 221, 'Front Desk Clerk'), (22, 222, 'Front Desk Clerk'),
(23, 223, 'Front Desk Clerk'), (24, 224, 'Front Desk Clerk');

-- 5. Insert 24 Physician Subspecialties
INSERT INTO Physician_Subspecialties (Physician_ID, Subspecialty) VALUES 
(2, 'Interventional Cardiology'), (3, 'Neonatology'), (4, 'Epilepsy'),
(5, 'Radiation Oncology'), (6, 'Sports Orthopedics'), (7, 'Pediatric Dermatology'),
(8, 'Addiction Psychiatry'), (9, 'Trauma Surgery'), (10, 'Diabetes Management'),
(11, 'Hepatology'), (12, 'Sleep Medicine'), (13, 'Pediatric Rheumatology'),
(14, 'Transplant Nephrology'), (15, 'Coagulation Disorders'), (16, 'Pediatric Urology'),
(17, 'Glaucoma Specialist'), (18, 'Rhinology'), (19, 'Reproductive Endocrinology'),
(20, 'Tropical Medicine'), (21, 'Clinical Immunology'), (22, 'Palliative Care'),
(23, 'Concussion Management'), (24, 'Toxicology'), (1, 'Adolescent Medicine');




-- ==========================================
-- BLOCK 2: PATIENTS & MULTI-VALUED ATTRS
-- ==========================================

-- 6. Insert 24 Patients (Assigned evenly across Physicians 1-24)
INSERT INTO Patient (Patient_ID, Physician_ID, Name, SSN, Date_Of_Birth, Home_Address, Insurance, Balance, Preferred_Pharmacy_Address, Medical_Record_Number) VALUES 
(1, 1, 'Alice Johnson', '111000001', '1990-05-12', '123 Apple St, San Antonio, TX', 'Aetna', 0.00, '999 Pharmacy Rd', 'MRN-001'),
(2, 2, 'Bob Smith', '111000002', '1985-08-22', '456 Banana Ave, San Antonio, TX', 'BlueCross', 150.00, '888 Drugstore Ln', 'MRN-002'),
(3, 3, 'Charlie Brown', '111000003', '2010-11-05', '789 Cherry Blvd, San Antonio, TX', 'Cigna', 20.00, '777 Meds St', 'MRN-003'),
(4, 4, 'Diana Prince', '111000004', '1978-02-14', '321 Date Ct, San Antonio, TX', 'UnitedHealthcare', 0.00, '999 Pharmacy Rd', 'MRN-004'),
(5, 5, 'Evan Wright', '111000005', '1965-09-30', '654 Elderberry Dr, San Antonio, TX', 'Medicare', 500.00, '666 Pill Ave', 'MRN-005'),
(6, 6, 'Fiona Gallagher', '111000006', '1992-04-18', '987 Fig Way, San Antonio, TX', 'Medicaid', 0.00, '888 Drugstore Ln', 'MRN-006'),
(7, 7, 'George Miller', '111000007', '1980-12-01', '111 Grape Pl, San Antonio, TX', 'Humana', 75.50, '555 Health Rd', 'MRN-007'),
(8, 8, 'Hannah Abbott', '111000008', '1995-07-25', '222 Honeydew St, San Antonio, TX', 'Aetna', 0.00, '999 Pharmacy Rd', 'MRN-008'),
(9, 9, 'Ian Malcolm', '111000009', '1970-03-10', '333 Kiwi Ln, San Antonio, TX', 'BlueCross', 200.00, '444 Cure Blvd', 'MRN-009'),
(10, 10, 'Julia Child', '111000010', '1955-08-15', '444 Lemon Ave, San Antonio, TX', 'Medicare', 10.00, '888 Drugstore Ln', 'MRN-010'),
(11, 11, 'Kevin Hart', '111000011', '1982-01-20', '555 Mango Dr, San Antonio, TX', 'Cigna', 0.00, '999 Pharmacy Rd', 'MRN-011'),
(12, 12, 'Laura Croft', '111000012', '1988-10-10', '666 Nectarine Ct, San Antonio, TX', 'UnitedHealthcare', 35.00, '777 Meds St', 'MRN-012'),
(13, 13, 'Michael Scott', '111000013', '1968-05-15', '777 Orange Blvd, San Antonio, TX', 'Humana', 120.00, '555 Health Rd', 'MRN-013'),
(14, 14, 'Nina Simone', '111000014', '1960-02-28', '888 Papaya Way, San Antonio, TX', 'Medicare', 0.00, '888 Drugstore Ln', 'MRN-014'),
(15, 15, 'Oscar Isaac', '111000015', '1979-11-11', '999 Quince Pl, San Antonio, TX', 'Aetna', 45.00, '999 Pharmacy Rd', 'MRN-015'),
(16, 16, 'Penelope Cruz', '111000016', '1981-06-05', '121 Raspberry St, San Antonio, TX', 'BlueCross', 0.00, '666 Pill Ave', 'MRN-016'),
(17, 17, 'Quincy Jones', '111000017', '1945-03-14', '232 Strawberry Ln, San Antonio, TX', 'Medicare', 80.00, '444 Cure Blvd', 'MRN-017'),
(18, 18, 'Rachel Green', '111000018', '1975-09-22', '343 Tangerine Ave, San Antonio, TX', 'Cigna', 0.00, '999 Pharmacy Rd', 'MRN-018'),
(19, 19, 'Samwise Gamgee', '111000019', '1983-04-01', '454 Ugli Dr, San Antonio, TX', 'UnitedHealthcare', 15.00, '777 Meds St', 'MRN-019'),
(20, 20, 'Tina Fey', '111000020', '1970-12-18', '565 Vanilla Ct, San Antonio, TX', 'Humana', 0.00, '888 Drugstore Ln', 'MRN-020'),
(21, 21, 'Uma Thurman', '111000021', '1973-08-08', '676 Watermelon Blvd, San Antonio, TX', 'Aetna', 25.00, '555 Health Rd', 'MRN-021'),
(22, 22, 'Victor Hugo', '111000022', '1950-02-26', '787 Xigua Way, San Antonio, TX', 'Medicare', 0.00, '999 Pharmacy Rd', 'MRN-022'),
(23, 23, 'Wanda Maximoff', '111000023', '1990-10-31', '898 Yuzu Pl, San Antonio, TX', 'BlueCross', 300.00, '444 Cure Blvd', 'MRN-023'),
(24, 24, 'Xavier Woods', '111000024', '1986-07-14', '909 Zucchini St, San Antonio, TX', 'Cigna', 0.00, '888 Drugstore Ln', 'MRN-024');

-- 7. Insert 24 Patient Allergies
INSERT INTO Patient_Allergies (Patient_ID, Allergy) VALUES 
(1, 'Penicillin'), (2, 'Peanuts'), (3, 'Latex'), (4, 'Dust Mites'), (5, 'Sulfa Drugs'),
(6, 'Shellfish'), (7, 'Pollen'), (8, 'Amoxicillin'), (9, 'Bee Stings'), (10, 'Dairy'),
(11, 'Soy'), (12, 'Gluten'), (13, 'Aspirin'), (14, 'Ibuprofen'), (15, 'Cat Dander'),
(16, 'Dog Dander'), (17, 'Mold'), (18, 'Tree Nuts'), (19, 'Eggs'), (20, 'Sesame'),
(21, 'Wheat'), (22, 'Fish'), (23, 'Tetracycline'), (24, 'Iodine');

-- 8. Insert 24 Patient Medications
INSERT INTO Patient_Medications (Patient_ID, Medication) VALUES 
(1, 'Lisinopril'), (2, 'Atorvastatin'), (3, 'Albuterol'), (4, 'Levothyroxine'), (5, 'Metformin'),
(6, 'Omeprazole'), (7, 'Amlodipine'), (8, 'Losartan'), (9, 'Gabapentin'), (10, 'Hydrochlorothiazide'),
(11, 'Sertraline'), (12, 'Simvastatin'), (13, 'Montelukast'), (14, 'Escitalopram'), (15, 'Rosuvastatin'),
(16, 'Bupropion'), (17, 'Pantoprazole'), (18, 'Trazodone'), (19, 'Dextroamphetamine'), (20, 'Fluoxetine'),
(21, 'Duloxetine'), (22, 'Meloxicam'), (23, 'Clopidogrel'), (24, 'Glipizide');



-- ==========================================
-- BLOCK 3: APPOINTMENTS & RECORDS
-- ==========================================

-- 9. Insert 24 Appointments
INSERT INTO Appointment (Appointment_ID, Patient_ID, Physician_ID, Receptionist_ID, Medical_Record_Number, Duration, Reason, Date, Time) VALUES 
(1, 1, 1, 1, 'MRN-001', 30, 'Annual Physical', '2023-10-01', '09:00:00'),
(2, 2, 2, 2, 'MRN-002', 45, 'Chest Pain Follow-up', '2023-10-01', '10:00:00'),
(3, 3, 3, 3, 'MRN-003', 15, 'Vaccination', '2023-10-02', '11:00:00'),
(4, 4, 4, 4, 'MRN-004', 60, 'Migraine Consultation', '2023-10-02', '13:00:00'),
(5, 5, 5, 5, 'MRN-005', 30, 'Chemotherapy Review', '2023-10-03', '09:30:00'),
(6, 6, 6, 6, 'MRN-006', 45, 'Knee Pain', '2023-10-03', '14:00:00'),
(7, 7, 7, 7, 'MRN-007', 15, 'Skin Rash', '2023-10-04', '08:30:00'),
(8, 8, 8, 8, 'MRN-008', 60, 'Therapy Session', '2023-10-04', '15:00:00'),
(9, 9, 9, 9, 'MRN-009', 30, 'Post-Op Check', '2023-10-05', '10:30:00'),
(10, 10, 10, 10, 'MRN-010', 30, 'Diabetes Check', '2023-10-05', '11:30:00'),
(11, 11, 11, 11, 'MRN-011', 45, 'Stomach Pain', '2023-10-06', '09:00:00'),
(12, 12, 12, 12, 'MRN-012', 30, 'Asthma Review', '2023-10-06', '13:30:00'),
(13, 13, 13, 13, 'MRN-013', 45, 'Joint Stiffness', '2023-10-07', '10:00:00'),
(14, 14, 14, 14, 'MRN-014', 30, 'Kidney Stone Consult', '2023-10-07', '14:30:00'),
(15, 15, 15, 15, 'MRN-015', 60, 'Anemia Follow-up', '2023-10-08', '09:00:00'),
(16, 16, 16, 16, 'MRN-016', 30, 'UTI Symptoms', '2023-10-08', '11:00:00'),
(17, 17, 17, 17, 'MRN-017', 15, 'Vision Blur', '2023-10-09', '13:00:00'),
(18, 18, 18, 18, 'MRN-018', 30, 'Ear Infection', '2023-10-09', '15:30:00'),
(19, 19, 19, 19, 'MRN-019', 45, 'Prenatal Visit', '2023-10-10', '09:30:00'),
(20, 20, 20, 20, 'MRN-020', 30, 'Fever and Chills', '2023-10-10', '10:30:00'),
(21, 21, 21, 21, 'MRN-021', 15, 'Allergy Shots', '2023-10-11', '14:00:00'),
(22, 22, 22, 22, 'MRN-022', 60, 'Memory Assessment', '2023-10-11', '16:00:00'),
(23, 23, 23, 23, 'MRN-023', 30, 'Sprained Ankle', '2023-10-12', '08:00:00'),
(24, 24, 24, 24, 'MRN-024', 45, 'Laceration Repair', '2023-10-12', '09:00:00');

-- 10. Insert 24 Medical Records
INSERT INTO Medical_Record (Record_ID, Appointment_ID, Medical_Record_Number, Heart_Rate, Physician_Notes, Non_Physician_Notes, Chief_Complaint, Date, Time, Blood_Pressure, Weight, Height, Glucose_Level) VALUES 
(1, 1, 'MRN-001', 72, 'Patient healthy.', 'Vitals normal.', 'Annual checkup', '2023-10-01', '09:15:00', '120/80', 150.50, 65.0, 95),
(2, 2, 'MRN-002', 88, 'EKG normal.', 'Patient anxious.', 'Chest pain', '2023-10-01', '10:15:00', '135/85', 180.00, 70.0, 105),
(3, 3, 'MRN-003', 95, 'Administered flu shot.', 'Child cried briefly.', 'Vaccine', '2023-10-02', '11:10:00', '110/70', 85.00, 50.0, 90),
(4, 4, 'MRN-004', 68, 'Prescribed Imitrex.', 'Light sensitivity noted.', 'Migraine', '2023-10-02', '13:20:00', '115/75', 140.00, 64.0, 98),
(5, 5, 'MRN-005', 76, 'Counts look good.', 'Patient fatigued.', 'Chemo follow-up', '2023-10-03', '09:45:00', '125/82', 160.00, 68.0, 110),
(6, 6, 'MRN-006', 80, 'Suspect meniscus tear.', 'Limping on right leg.', 'Knee pain', '2023-10-03', '14:20:00', '130/80', 190.50, 72.0, 100),
(7, 7, 'MRN-007', 70, 'Contact dermatitis.', 'Applied hydrocortisone.', 'Rash on arm', '2023-10-04', '08:40:00', '118/76', 155.00, 66.0, 92),
(8, 8, 'MRN-008', 75, 'Progressing well.', 'Mood improved.', 'Anxiety', '2023-10-04', '15:15:00', '122/78', 135.00, 63.0, 96),
(9, 9, 'MRN-009', 82, 'Incision healing perfectly.', 'Stitches removed.', 'Post-op', '2023-10-05', '10:45:00', '128/84', 175.00, 69.0, 102),
(10, 10, 'MRN-010', 78, 'A1C elevated.', 'Discussed diet changes.', 'Diabetes management', '2023-10-05', '11:45:00', '140/90', 210.00, 67.0, 145),
(11, 11, 'MRN-011', 90, 'Ordered ultrasound.', 'Tenderness in lower right.', 'Abdominal pain', '2023-10-06', '09:20:00', '132/86', 165.00, 68.0, 99),
(12, 12, 'MRN-012', 85, 'Refilled inhaler.', 'Wheezing present.', 'Shortness of breath', '2023-10-06', '13:45:00', '126/80', 145.00, 64.0, 94),
(13, 13, 'MRN-013', 74, 'Osteoarthritis confirmed.', 'Recommended physical therapy.', 'Joint pain', '2023-10-07', '10:20:00', '138/88', 195.00, 71.0, 108),
(14, 14, 'MRN-014', 98, 'Stone passed.', 'Pain subsided.', 'Flank pain', '2023-10-07', '14:45:00', '145/95', 185.00, 70.0, 101),
(15, 15, 'MRN-015', 88, 'Iron levels low.', 'Prescribed supplements.', 'Fatigue', '2023-10-08', '09:25:00', '110/70', 130.00, 62.0, 88),
(16, 16, 'MRN-016', 76, 'Prescribed antibiotics.', 'Urine sample collected.', 'Painful urination', '2023-10-08', '11:15:00', '120/78', 150.00, 65.0, 97),
(17, 17, 'MRN-017', 70, 'Updating prescription.', 'Dilated eyes.', 'Blurry vision', '2023-10-09', '13:10:00', '118/74', 140.00, 66.0, 95),
(18, 18, 'MRN-018', 84, 'Otitis media.', 'Fluid behind tympanic membrane.', 'Ear ache', '2023-10-09', '15:45:00', '124/82', 160.00, 68.0, 100),
(19, 19, 'MRN-019', 78, 'Fetal heart rate 140.', 'Patient feeling kicks.', 'Pregnancy checkup', '2023-10-10', '09:50:00', '115/75', 155.00, 64.0, 90),
(20, 20, 'MRN-020', 102, 'Flu swab positive.', 'Instructed to rest and hydrate.', 'Fever', '2023-10-10', '10:45:00', '110/70', 170.00, 70.0, 98),
(21, 21, 'MRN-021', 72, 'Administered serum.', 'Observed for 15 mins.', 'Allergies', '2023-10-11', '14:15:00', '120/80', 145.00, 65.0, 96),
(22, 22, 'MRN-022', 68, 'Mild cognitive impairment.', 'Scheduled follow-up in 6 mos.', 'Memory loss', '2023-10-11', '16:30:00', '135/85', 165.00, 67.0, 105),
(23, 23, 'MRN-023', 80, 'Grade 2 sprain.', 'Provided brace and crutches.', 'Ankle injury', '2023-10-12', '08:20:00', '128/82', 180.00, 71.0, 102),
(24, 24, 'MRN-024', 92, 'Sutured 5 stitches.', 'Cleaned wound thoroughly.', 'Cut on hand', '2023-10-12', '09:25:00', '130/86', 175.00, 69.0, 110);

-- 11. Insert 24 Receptionist Record Access Logs
INSERT INTO Receptionist_Record_Access (Receptionist_ID, Record_ID) VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), 
(19, 19), (20, 20), (21, 21), (22, 22), (23, 23), (24, 24);

-- 12. Insert 24 CPT Codes
INSERT INTO Medical_Records_CPT_Codes (Record_ID, CPT_Code) VALUES 
(1, '99213'), (2, '93000'), (3, '90471'), (4, '99214'), (5, '99215'),
(6, '73562'), (7, '99212'), (8, '90834'), (9, '99024'), (10, '83036'),
(11, '76700'), (12, '94010'), (13, '73030'), (14, '74176'), (15, '85025'),
(16, '81000'), (17, '92012'), (18, '69210'), (19, '59400'), (20, '87804'),
(21, '95115'), (22, '96116'), (23, '73630'), (24, '12002');

-- 13. Insert 24 Prescribed Medications
INSERT INTO MedicalRecord_Medications_Prescribed (Record_ID, Medication_Prescribed) VALUES 
(1, 'None'), (2, 'Nitroglycerin'), (3, 'None'), (4, 'Sumatriptan'), (5, 'Ondansetron'),
(6, 'Naproxen'), (7, 'Hydrocortisone Cream'), (8, 'None'), (9, 'None'), (10, 'Insulin Glargine'),
(11, 'Dicyclomine'), (12, 'Albuterol Inhaler'), (13, 'Celecoxib'), (14, 'Tamsulosin'), (15, 'Ferrous Sulfate'),
(16, 'Nitrofurantoin'), (17, 'Timolol Drops'), (18, 'Amoxicillin'), (19, 'Prenatal Vitamins'), (20, 'Oseltamivir'),
(21, 'None'), (22, 'Donepezil'), (23, 'Ibuprofen'), (24, 'Cephalexin');

-- 14. Insert 24 Diagnoses
INSERT INTO Medical_Record_Diagnoses (Record_ID, Diagnosis) VALUES 
(1, 'Healthy Adult'), (2, 'Angina Pectoris'), (3, 'Prophylactic Vaccination'), (4, 'Chronic Migraine'), (5, 'Malignant Neoplasm'),
(6, 'Meniscus Tear'), (7, 'Contact Dermatitis'), (8, 'Generalized Anxiety Disorder'), (9, 'Postoperative State'), (10, 'Type 2 Diabetes Mellitus'),
(11, 'Abdominal Pain Unspecified'), (12, 'Asthma Exacerbation'), (13, 'Osteoarthritis of Knee'), (14, 'Nephrolithiasis'), (15, 'Iron Deficiency Anemia'),
(16, 'Urinary Tract Infection'), (17, 'Myopia'), (18, 'Otitis Media'), (19, 'Normal Pregnancy'), (20, 'Influenza A'),
(21, 'Allergic Rhinitis'), (22, 'Mild Cognitive Impairment'), (23, 'Sprained Ankle'), (24, 'Open Wound of Hand');

-- 15. Insert 24 Procedures
INSERT INTO Medical_Record_Procedures (Record_ID, Procedure_Name) VALUES 
(1, 'Routine Exam'), (2, 'Electrocardiogram'), (3, 'Immunization Administration'), (4, 'Neurological Assessment'), (5, 'Oncology Review'),
(6, 'Knee X-Ray'), (7, 'Skin Assessment'), (8, 'Psychotherapy'), (9, 'Suture Removal'), (10, 'Hemoglobin A1C Test'),
(11, 'Abdominal Ultrasound'), (12, 'Spirometry'), (13, 'Shoulder X-Ray'), (14, 'CT Abdomen/Pelvis'), (15, 'Complete Blood Count'),
(16, 'Urinalysis'), (17, 'Eye Exam'), (18, 'Cerumen Removal'), (19, 'Fetal Heart Monitoring'), (20, 'Rapid Flu Test'),
(21, 'Allergen Immunotherapy'), (22, 'Cognitive Assessment'), (23, 'Ankle X-Ray'), (24, 'Simple Laceration Repair');
