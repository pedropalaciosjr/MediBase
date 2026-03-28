CREATE DATABASE MediBase;

CREATE TABLE Patient (
	patient_ID INT PRIMARY KEY,
    patient_name VARCHAR(20),
    SSN INT UNIQUE,
    date_of_birth DATE,
    home_address VARCHAR(50),
    insurance_name VARCHAR(20),
    balance DECIMAL
)