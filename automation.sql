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

-- 


-- A record to test the triggers:
INSERT INTO Patient (Patient_ID, Physician_ID, Name, SSN, Date_Of_Birth, Home_Address, Insurance, Balance, Preferred_Pharmacy_Address, Medical_Record_Number)
VALUES (25, 24, 'Pedro Palacios', '111000025', '1986-07-14', '909 Zucchini St, San Antonio, TX', 'Cigna', 0.00, '888 Drugstore Ln', 'MRN-025');

DELETE FROM Patient WHERE Patient_ID = 25;

SELECT * FROM Patient;
SELECT * FROM Audit_Log;
