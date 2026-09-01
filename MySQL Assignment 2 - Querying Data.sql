USE employee;
-- Clause & Operators --
-- 1. DISTINCT VALUES -- 

SELECT DISTINCT Salary FROM Employees; -- DISTINCT ensures that duplicate salary values are eliminated --

-- 2. ALIAS (AS) --

-- Provide aliases for the "age" and "salary" columns as "Employee_Age" and "Employee_Salary", respectively --
-- The below query selects two columns from the Employees table: age and salary. It renames them using aliases: age → Employee_Age, salary → Employee_Salary --

SELECT age AS Employee_Age, salary AS Employee_Salary FROM Employees;

-- 3. WHERE CLAUSE & OPERATORS --
-- Retrieve employees with a salary greater than ₹50000 and hired before  2016-01-01 --

INSERT INTO Employees (employee_name, Hire_Date, designation, salary, email)          -- This table has no one before (2016-01-01) this date --
VALUES ('Yuvaraj', '2015-03-02', 'Data Scientist', 72000, 'yuvaraj.Y@company.com');   -- so i inserted one record --

SELECT employee_name, salary, hire_date FROM Employees    -- It displays the employee before 2016-01-01 and salary > 50,000 --  
WHERE salary > 50000 AND hire_date < '2016-01-01';

-- Find the employee whose designation is missing and fill it with "Data Scientist" --

ALTER TABLE Employees                     -- This table does not have null values --
MODIFY designation VARCHAR(50) NULL;      -- So I used alter to insert records without providing a designation, and it will store NULL --
                                              
                                                         
INSERT INTO Employees (employee_name, Gender, Hire_Date, salary, email, Age)        -- Then I inserted a Null Value Record --
VALUES ('Rehana', 'Female', '2023-03-02', 82000, 'Rehana.Rakesh@company.com', 23); 

UPDATE Employees                  -- This query used to Find the employee whose designation is missing and filled it with "Data Scientist" --                                     
SET designation = 'Data Scientist'
WHERE (designation IS NULL OR designation = '')
AND employee_id > 0;

SELECT employee_name, designation       -- To check or to display the employee name with Data Scientist rows --
FROM Employees
WHERE designation = 'Data Scientist';

-- Sorting and Grouping Data --
-- 1. ORDER BY --

SELECT * FROM employees ORDER BY department_id ASC, salary DESC; -- Find employees sorted by department ID in ascending order and salary in descending order --

-- 2. LIMIT:  Display the first 5 employees hired in the year 2018 --

INSERT INTO Employees (employee_name, hire_date, department_id, salary, email) -- I Inserted 2018 Records --
VALUES
('John Smith', '2018-01-05', 1, 50000, 'john.smith@example.com'),
('Priya Kumar', '2018-02-12', 2, 52000, 'priya.kumar@example.com'),
('David Lee', '2018-03-20', 3, 51000, 'david.lee@example.com'),
('Anita Sharma', '2018-04-15', 4, 53000, 'anita.sharma@example.com'),
('Carlos Gomez', '2018-05-10', 1, 55000, 'carlos.gomez@example.com');

SELECT employee_name, hire_date            -- It Displays the first 5 employees hired in the year 2018 --
FROM Employees
WHERE YEAR(hire_date) = 2018
ORDER BY hire_date ASC
LIMIT 5;

-- 3. AGGREGATE FUNCTIONS --

-- Calculate the sum of all salaries in the Finance department --

SELECT SUM(salary) AS total_salary      -- This displays sum of all salaries in Finance Department --
FROM Employees
WHERE department_id = (
    SELECT department_id
    FROM Department
    WHERE department_name = 'Finance'
);

-- Find the minimum age among all employees. --

SELECT MIN(age) AS min_age FROM Employees;

-- 4. GROUP BY --

--  List the maximum salary for each location --

SELECT location_id, MAX(salary) AS max_salary   -- It lists the Max salary for each loaction --
FROM Employees
GROUP BY location_id;

-- Calculate the average salary for each designation containing the word 'Analyst' --

SELECT designation, AVG(salary) AS avg_salary   -- It calculates the average salary for each designation containing the word 'Analyst' --
FROM Employees
WHERE designation LIKE '%Analyst%'
GROUP BY designation;

-- 5. HAVING: --

-- Find departments with less than 3 employees --

SELECT d.department_name, COUNT(e.employee_id) AS employee_count   -- LEFT JOIN → ensures departments are included even if they have zero employees --
FROM Department d                                                  -- COUNT(e.employee_id) → counts how many employees belong to each department --
LEFT JOIN Employees e                                              -- GROUP BY d.department_name → groups results by department --
       ON d.department_id = e.department_id                        -- HAVING COUNT(...) < 3 → filters only those departments with fewer than 3 employees --
GROUP BY d.department_name
HAVING COUNT(e.employee_id) < 3;

--  Find locations with female employees whose average age is below 30 --

INSERT INTO Employees (employee_name, age, gender, hire_date, department_id, salary, email)
VALUES
('Geetha', 29, 'Female', '2019-08-12', 3, 68000, 'geetha.as@example.com'),
('Shobana', 28, 'Female', '2020-05-18', 4, 22000, 'shobana.ws@example.com');

SELECT l.location_name, AVG(e.age) AS avg_age             -- WHERE e.Gender = 'F' → filters only female employees --
FROM Employees e                                          -- AVG(e.age) → calculates the average age of female employees in each location --
JOIN Location l ON e.location_id = l.location_id          -- GROUP BY l.location_name → groups results by location --
WHERE e.Gender = 'F'                                      -- HAVING AVG(e.age) < 30 → keeps only those locations where the average age is below 30 --
GROUP BY l.location_name
HAVING AVG(e.age) < 30;

-- Joins: --
-- 1. INNER JOIN: List employee names, their designations, and department names where employees are assigned to a department --

SELECT e.employee_name,       -- INNER JOIN → Only returns rows where there’s a match between Employees.department_id and Department.department_id --
       e.designation,         -- e.employee_name, e.designation → Pulls the employee’s details --
       d.department_name      -- d.department_name → Brings in the department name from the Department table --
FROM Employees e
INNER JOIN Department d
        ON e.department_id = d.department_id;
        
-- 2. LEFT JOIN: List all departments along with the total number of employees in each department, including departments with no employees -- 

SELECT d.department_name,                        -- LEFT JOIN → Ensures every department is included, even if no employees are assigned --
       COUNT(e.employee_id) AS total_employees   -- COUNT(e.employee_id) → Counts how many employees belong to each department. For departments with no employees, the count will be 0 --
FROM Department d                                -- GROUP BY d.department_name → Groups results by department so you get one row per department -- 
LEFT JOIN Employees e
       ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 3. RIGHT JOIN: Display all locations along with the names of employees assigned to each location. If no employees are assigned to a location, display NULL for employee name --

SELECT l.location_name,                        -- RIGHT JOIN → Ensures that all locations are included in the result set, even if no employees are linked to them --
e.employee_name                         -- e.employee_name → Displays the employee’s name if assigned; otherwise, it will show NULL --
FROM Employees e                               
RIGHT JOIN Location l
       ON e.location_id = l.location_id;

-- 4. CROSS JOIN - Show all possible combinations of departments and locations --

SELECT d.department_name,           -- CROSS JOIN → Produces the Cartesian product of the two tables --
       l.location_name              -- Every department will be paired with every location, regardless of whether they are actually related --
FROM Department d                   -- If you have N departments and M locations, the result will contain N X M rows --
CROSS JOIN Location l;

-- 5. SELF JOIN: Show pairs of employees working in the same department, excluding self-pairs --

SELECT e1.employee_name AS employee_1,   -- JOIN Employees e2 ON e1.department_id = e2.department_id → joins the table to itself, matching employees in the same department --
       e2.employee_name AS employee_2,   -- AND e1.employee_id <> e2.employee_id → ensures you don’t get self-pairs (an employee matched with themselves) -- 
       e1.department_id                  -- ORDER BY → organizes the output neatly by department and employee names -- 
FROM Employees e1
JOIN Employees e2
     ON e1.department_id = e2.department_id
    AND e1.employee_id <> e2.employee_id
ORDER BY e1.department_id, e1.employee_name, e2.employee_name;

-- Windows function --

-- Write a window function query to rank employees by salary using rank() --

SELECT employee_id,                       -- RANK() → Assigns a rank to each employee based on salary --
       employee_name,                     -- ORDER BY salary DESC → Highest salary gets rank 1, next highest gets rank 2, and so on --  
       salary,                            -- If two employees share the same salary, they get the same rank, and the next rank will be skipped (e.g., salaries 5000, 4000, 4000 → ranks 1, 2, 2, then next is 4) --
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM Employees;

-- Write a window function query to rank employees by salary within each department using DENSE_RANK() --

SELECT employee_id,                       -- PARTITION BY department_id → Resets the ranking for each department, so employees are ranked only against others in the same department --
       employee_name,                     -- ORDER BY salary DESC → Highest salary in each department gets rank 1, next distinct salary gets rank 2, and so on --
       department_id,                     -- DENSE_RANK() → Ensures no gaps in ranking. If two employees share the same salary, they get the same rank, and the next rank continues sequentially --  
       salary,
       DENSE_RANK() OVER (
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS dept_salary_rank
FROM Employees;

-- Write a window function query, Running total salary by department --

SELECT employee_id,                      -- SUM(salary) OVER (...) → Creates a running total using the window function -- 
       employee_name,                    -- PARTITION BY department_id → Resets the running total for each department --
       department_id,                    -- ORDER BY employee_id → Ensures the cumulative sum is calculated in employee order (you could also order by hire_date or salary depending on your need) -- 
       salary,                           -- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW → Defines the window frame: start from the first row in the partition and keep adding up to the current row -- 
       SUM(salary) OVER (
           PARTITION BY department_id
           ORDER BY employee_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total_salary
FROM Employees;

-- I used ai support to write query for joins & windows function --





















 



