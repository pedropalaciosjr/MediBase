USE clinic;

# The User wants to know the total amount of time the hospital has spent on Appointments in the month of October
SELECT SUM(Duration) AS Total_Appointment_Time_October
FROM Appointment
WHERE Date LIKE "2023-10-%";

# The User wants to know the identifying information of the patient with the highest unpaid balance 
SELECT Patient_ID, Name, SSN, Date_Of_Birth, Home_Address, Insurance, Balance, Medical_Record_Number
FROM Patient
WHERE Balance = (SELECT MAX(Balance) FROM Patient);

# The User wants to know the emergency contacy for Jerry Gergich who colapsed in the middle of his shift and was admitted
SELECT Staff.Name, Staff_Emergency_Numbers.Emergency_Phone_Number
FROM Staff_Emergency_Numbers
INNER JOIN Staff
on Staff_Emergency_Numbers.Staff_ID = Staff.Staff_ID
WHERE Staff.NAME LIKE "Jerry Gergich%";

# The User wants to know the relevant information of all patients perscribed a medication that has been recalled
SELECT Name, Home_Address, Preferred_Pharmacy_Address, Date, CONCAT(Physician_Notes, " ", Non_Physician_Notes) AS Notes, Medication_Prescribed
FROM Medical_Record
INNER JOIN MedicalRecord_Medications_Prescribed
on Medical_Record.Record_ID = MedicalRecord_Medications_Prescribed.Record_ID
INNER JOIN Patient
on Medical_Record.Medical_Record_Number = Patient.Medical_Record_Number
WHERE Medication_Prescribed = "Nitroglycerin";

# The User wants to know the statistics of which insurance companies the hospital patients are using
SELECT DISTINCT Insurance, COUNT(Patient_ID) AS Number_of_Patients
FROM Patient
GROUP BY Insurance
ORDER BY Number_of_Patients DESC;

# The User wants to know all Patients who received an X-Ray and why to ensure it is only being used when necessary
SELECT Name, Date, Physician_Notes, Procedure_Name
FROM Medical_Record
INNER JOIN Medical_Record_Procedures
on Medical_Record.Record_ID = Medical_Record_Procedures.Record_ID
INNER JOIN Patient
on Medical_Record.Medical_Record_Number = Patient.Medical_Record_Number
WHERE Medical_Record_Procedures.Procedure_Name LIKE "%X-Ray";

# The User needs to temporarily replace Pam Beesly who is going on leave and is trying to determine what Pam's job is
SELECT Position
FROM Receptionist
WHERE Staff_ID = (SELECT Staff_ID FROM Staff WHERE Name = "Pam Beesly");
