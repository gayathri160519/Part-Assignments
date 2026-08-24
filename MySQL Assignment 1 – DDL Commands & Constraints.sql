-- MySQL Assignment 1 - DDL Commands, Constraints --

-- Tasks:  DDL Commands  1. Database and Table Creation (CREATE) --

CREATE database employee;
use employee;

-- Table 1 --

CREATE table Departments(
department_id int PRIMARY KEY,
department_name varchar(100) NOT NULL
); 

INSERT INTO Departments (deparment_id, department_name) VALUES
(101,"Accounts"), (102, "Finance"), (103,"Commerce"), (104,"IT"), (105,"Civil");

SELECT * FROM Departments;

-- Table 2 --

CREATE TABLE Location(
location_id int PRIMARY KEY,
location_name varchar(100) NOT NULL
);

INSERT INTO Location (location_id, location_name) values
(1001, "Chennai"), (1002, "Madurai"), (1003, "bangalore"), (1004, "Hyderabad"), (1005, "Kolkata");

SELECT * FROM Location;

-- Table 3 (used foreign key) --

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(50) NOT NULL,
    Gender ENUM('Male', 'Female'),
    Hire_Date DATE,
    Designation VARCHAR(100) NOT NULL,
    Salary decimal(10,2),
    department_id INT,
    location_id INT,
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
)   AUTO_INCREMENT = 501;

INSERT INTO Employees (employee_name, Gender, Hire_Date, Designation, Salary, department_id, location_id)
VALUES 
('Harry', 'Male', '2022-05-10', 'HR Manager', 60000,101,1001),
('Sharma', 'Male', '2023-01-15', 'Financial Analyst', 55000,102,1002),
('Priya', 'Female', '2021-11-20', 'Software Engineer', 70000,103,1003),
('Meena', 'Female', '2024-03-05', 'Data Analyst', 65000,104,1004),
('Ronald', 'Male', '2025-04-04', 'Auditor', 55000,105,1005);

SELECT * from Employees;

-- checked how foreign key reference works --

SELECT employee_id, employee_name, department_id, location_id
FROM Employees;

-- 2.  Table Alteration (ALTER) --
-- Add a new column named "email" to the Employees table to store employee email addresses --
 
ALTER TABLE Employees
ADD email VARCHAR(100);

-- Modify the data type of the "designation" column in the Employees table to support a wider range of values --

ALTER TABLE Employees
MODIFY designation VARCHAR(255) NOT NULL;

-- To check above 2 alter queries --
SELECT * FROM EMPLOYEES;

ALTER TABLE Employees ADD age INT;

-- inserted values in age Column --
INSERT INTO Employees (employee_name, Gender, Hire_Date, Designation, Salary, department_id, location_id, Age)
VALUES 
('Harry', 'Male', '2022-05-10', 'HR Manager', 60000,101,1001, 25),
('Sharma', 'Male', '2023-01-15', 'Financial Analyst', 55000,102,1002, 30),
('Priya', 'Female', '2021-11-20', 'Software Engineer', 70000,103,1003, 26),
('Meena', 'Female', '2024-03-05', 'Data Analyst', 65000,104,1004, 28),
('Ronald', 'Male', '2025-04-04', 'Auditor', 55000,105,1005, 30);

-- Drop the “age” column from the Employees table --
ALTER TABLE Employees
DROP COLUMN age;
-- To check --
SHOW COLUMNS FROM Employees;

-- Rename the “hire_date” column to “date_of_joining” --
ALTER TABLE Employees
CHANGE hire_date date_of_joining DATE;

-- To Check --
DESCRIBE Employees;

-- 3. Table Renaming (RENAME)--
-- Rename the "Departments" table to "Departments_Info" --

RENAME TABLE departments TO Departments_Info;

-- To check --
SHOW TABLES;

-- Rename the "Location" table to "Locations" --

RENAME TABLE location TO Locations;

-- To Check --
SHOW TABLES;

-- 4. Table Truncation (TRUNCATE) --
TRUNCATE TABLE Employees;

-- 5. Database & Table Dropping (DROP) --
-- Drop the Employees table and then the “employee” database --
DROP TABLE Employees;
DROP DATABASE Employee;

-- To check --
SHOW DATABASES;
SHOW TABLES FROM Employee;

-- Tasks: Constraints - 1. Database Recreation --
-- 1. Database Recreation --

CREATE DATABASE employee;
USE employee;

-- 2. Departments Table --
CREATE TABLE Department (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE                       -- UNIQUE - Prevents duplicate department records --
);

INSERT INTO Department (department_name)
VALUES ('Account'), ('Finance'), ('IT'), ('Sales'), ('Marketing');

-- 3. Locations Table--

CREATE TABLE Location (
    location_id INT PRIMARY KEY AUTO_INCREMENT, -- PRIMARY KEY → ensures each location has a unique identifier -- AUTO_INCREMENT → automatically generates sequential IDs (1, 2, 3, …) --
    location_name VARCHAR(100) NOT NULL UNIQUE,  --  UNIQUE - Prevents duplicate location names -- NOT NULL → prevents empty location names --
);

INSERT INTO Location (location_name)
VALUES ('Chennai'), ('Vellore'), ('Madurai'), ('Trichy'), ('Coimbatore');

-- 4. Employees Table --

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,    -- PRIMARY KEY (employee_id) → guarantees uniqueness -- AUTO_INCREMENT → automatically generates sequential IDs (1, 2, 3, …) -- two employees never share the same identifier --
    employee_name VARCHAR(50) NOT NULL,            -- NOT NULL Constraint on employee_name → ensures the name must always be provided --
    Gender ENUM('Male', 'Female') NOT NULL,        -- ENUM is to restrict the gender field as 'M' or 'F' values are allowed -- 
    Hire_Date DATE,
    Designation VARCHAR(100) NOT NULL,
    Salary INT CHECK (Salary >0),                  -- This is a Constraint to Prevent invalid data (like negative salaries or zero) --
    department_id INT,
    location_id INT,
    email VARCHAR(100) UNIQUE NOT NULL,                                -- Prevents duplicate accounts or records for the same email --
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
)   AUTO_INCREMENT = 501;

INSERT INTO Employees (employee_name, Gender, Hire_Date, Designation, Salary, department_id, location_id, email)
VALUES
('Anitha', 'Female', '2022-04-04', 'HR Manager', 65000, 1, 1, 'anitha.john@company.com'),
('Babu', 'Male', '2025-05-05', 'Financial Analyst', 70000, 2, 2, 'babu.sm@company.com'),
('Chandru', 'Male', '2021-03-02', 'Software Engineer', 85000, 3, 3, 'chandru.kumar@company.com'),
('Divya Bharathi', 'Female', '2024-04-07', 'Sales Executive', 55000, 4, 4, 'divya.ba@company.com'),
('Eswar', 'Male', '2023-08-07', 'Marketing Specialist', 60000, 5, 5, 'eswar.ht@company.com');

ALTER TABLE Employees           -- Used alter to add age Column --
ADD age INT CHECK (age >= 18);  -- CHECK (age >= 18) constraint to check employee under 18 cannot be inserted --

UPDATE Employees SET age = 29 WHERE employee_id = 511; -- Used update for age Column --
UPDATE Employees SET age = 32 WHERE employee_id = 512;
UPDATE Employees SET age = 25 WHERE employee_id = 513;
UPDATE Employees SET age = 30 WHERE employee_id = 514;
UPDATE Employees SET age = 27 WHERE employee_id = 515;

SELECT employee_id, employee_name, age FROM Employees; -- To Check age Column -- 

-- assign the current date to the "hire_date" field if not specified --

INSERT INTO Employees (employee_name, Gender, Designation, Salary, Age, department_id, location_id, email)
VALUES ('Karthik', 'Male', 'Data Analyst', 55000, 28, 6, 6, 'karthik.ds@company.com');

-- Inserted one Record without Hire_date --

-- Then used update to set hire_date as current date --

UPDATE Employees SET Hire_Date = CURDATE()  WHERE employee_id = 532;

-- Then used select to check Karthik's hire date has current date --

SELECT employee_id, employee_name, Hire_Date FROM Employees WHERE employee_name = 'Karthik';














































