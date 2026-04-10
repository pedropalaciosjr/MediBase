USE clinic;

-- Create Audit_Log table to store a log of Patient and Staff record modifications

DROP TABLE IF EXISTS Audit_Log;

CREATE TABLE Audit_Log (
	Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    Log_Date DATE NOT NULL,
    Log_Time TIME NOT NULL,
    Author VARCHAR(100) NOT NULL,
    Operation TEXT NOT NULL
);
-- Triggers -------------------------------------

-- Deletion, insertion, and update triggers for a Patient record
DROP TRIGGER IF EXISTS patient_deletion_trigger;
DELIMITER //
CREATE TRIGGER patient_deletion_trigger
	AFTER DELETE ON Patient
	FOR EACH ROW
	BEGIN
		INSERT INTO Audit_Log (Log_date, Log_Time, Author, Operation)
        VALUES (CURRENT_DATE(), CURRENT_TIME(), USER(), CONCAT("Deleted record for patient ", old.Patient_ID));
	END //
DELIMITER ;

DROP TRIGGER IF EXISTS patient_insertion_trigger;
DELIMITER //
CREATE TRIGGER patient_insertion_trigger
	AFTER INSERT ON Patient
	FOR EACH ROW
	BEGIN
		INSERT INTO Audit_Log (Log_date, Log_Time, Author, Operation)
        VALUES (CURRENT_DATE(), CURRENT_TIME(), USER(), CONCAT("Inserted record for patient ", new.Patient_ID));
	END //
DELIMITER ;

DROP TRIGGER IF EXISTS patient_update_trigger;
DELIMITER //
CREATE TRIGGER patient_update_trigger
	AFTER UPDATE ON Patient
	FOR EACH ROW
	BEGIN
		INSERT INTO Audit_Log (Log_date, Log_Time, Author, Operation)
        VALUES (CURRENT_DATE(), CURRENT_TIME(), USER(), CONCAT("Updated record for patient ", new.Patient_ID));
	END //
DELIMITER ;

-- Deletion, insertion, and update triggers for a Staff record
DROP TRIGGER IF EXISTS staff_deletion_trigger;
DELIMITER //
CREATE TRIGGER staff_deletion_trigger
	AFTER DELETE ON Staff
	FOR EACH ROW
	BEGIN
		INSERT INTO Audit_Log (Log_date, Log_Time, Author, Operation)
        VALUES (CURRENT_DATE(), CURRENT_TIME(), USER(), CONCAT("Deleted record for patient ", old.Staff_ID));
	END //
DELIMITER ;

DROP TRIGGER IF EXISTS staff_insertion_trigger;
DELIMITER //
CREATE TRIGGER staff_insertion_trigger
	AFTER INSERT ON Staff
	FOR EACH ROW
	BEGIN
		INSERT INTO Audit_Log (Log_date, Log_Time, Author, Operation)
        VALUES (CURRENT_DATE(), CURRENT_TIME(), USER(), CONCAT("Inserted record for patient ", new.Staff_ID));
	END //
DELIMITER ;

DROP TRIGGER IF EXISTS staff_update_trigger;
DELIMITER //
CREATE TRIGGER staff_update_trigger
	AFTER UPDATE ON Staff
	FOR EACH ROW
	BEGIN
		INSERT INTO Audit_Log (Log_date, Log_Time, Author, Operation)
        VALUES (CURRENT_DATE(), CURRENT_TIME(), USER(), CONCAT("Updated record for staff ", new.Staff_ID));
	END //
DELIMITER ;

--

-- Stored Procedure for Querying Patient Medications:
-- This procedure accepts a Patient_ID as the argument and retrieves all of the medications associated with the Patient_ID from
-- the Patient_Medications table.
DROP PROCEDURE IF EXISTS get_patient_medications;
DELIMITER //
CREATE PROCEDURE get_patient_medications (IN ID INT)
BEGIN
	SELECT Medication FROM Patient_Medications WHERE Patient_ID = ID;
END //
DELIMITER ;

-- Function for determining a Staff is able to work
-- A Staff member is determined ready if they meet both the health screening and background check requirement.
DROP FUNCTION IF EXISTS eligible_to_work;
DELIMITER //
CREATE FUNCTION eligible_to_work(ID int)
RETURNS VARCHAR(12)
DETERMINISTIC
BEGIN
	DECLARE health_screening_completed INT;
    DECLARE background_check_completed INT;
    
    SELECT Health_Screening_Complete, Background_Check_Complete INTO health_screening_completed, background_check_completed
    FROM Staff WHERE Staff_ID = ID;
    
    RETURN IF((health_screening_completed = 1 AND background_check_completed = 1), "Eligible", "Not Eligible");
END //
DELIMITER ;


-- Test the record insertion trigger
INSERT INTO Patient (Patient_ID, Physician_ID, Name, SSN, Date_Of_Birth, Home_Address, Insurance, Balance, Preferred_Pharmacy_Address, Medical_Record_Number)
VALUES (25, 24, 'Pedro Palacios', '111000025', '1986-07-14', '909 Zucchini St, San Antonio, TX', 'Cigna', 0.00, '888 Drugstore Ln', 'MRN-025');

SELECT * FROM Audit_Log;

-- Test the record deletion trigger
DELETE FROM Patient WHERE Patient_ID = 25;

SELECT * FROM Audit_Log;

-- Test the record update trigger by first inserting the record back into the Patient table and updating it
INSERT INTO Patient (Patient_ID, Physician_ID, Name, SSN, Date_Of_Birth, Home_Address, Insurance, Balance, Preferred_Pharmacy_Address, Medical_Record_Number)
VALUES (25, 24, 'Pedro Palacios', '111000025', '1986-07-14', '909 Zucchini St, San Antonio, TX', 'Cigna', 0.00, '888 Drugstore Ln', 'MRN-025');
UPDATE Patient SET Date_Of_Birth = '2005-11-10' WHERE Patient_ID = 25;

SELECT * FROM Audit_Log;

-- Call the get_patient_medications stored procedure to retrieve the medications for the specified patient ID
CALL get_patient_medications(23);

-- Determine if a Staff member is eligible to work if their health screening and background check requirements are completed
SELECT eligible_to_work(101) AS "Work Eligibility";

SELECT * FROM Patient;
SELECT * FROM Patient_Medications;
Select * FROM Staff;

