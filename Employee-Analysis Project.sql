/* This project is a about a small company payroll data.
Each table contains an Employee, Pay and Branch Table which are coonected through joins
The Table contains weekly pay caluclation and total pay for the month of each employees */

-- CREATING EMPLOYEE TABLE
CREATE TABLE EMPLOYEE (
Emp_id INTEGER PRIMARY KEY,
First_Name VARCHAR(20), 
Last_Name VARCHAR(20),
City VARCHAR(20),
State VARCHAR(2),
Branch_id INTEGER,
Pay_id INTEGER,
/* Had to Create the Branch and Pay table since those are the Parent table, 
but i could have used the ALTER KEYWORD TO ASSIGN both foreign keys later on */
FOREIGN KEY(Branch_id) REFERENCES branch(Branch_id) ON DELETE SET NULL,
FOREIGN KEY(Pay_id) REFERENCES pay(Pay_id) ON DELETE SET NULL
);

-- CREATING PAY TABLE
CREATE TABLE PAY (
Pay_id INTEGER PRIMARY KEY,
Rate DECIMAL(5, 2),
First_week_Hours INTEGER,
Second_week_Hours INTEGER,
Third_week_Hours INTEGER,
Fourth_week_Hours INTEGER,
First_week_Pay DECIMAL(6,2),
Second_week_Pay DECIMAL(6,2),
Third_week_Pay DECIMAL(6,2),
Fourth_week_Pay DECIMAL(6,2),
Total_pay_January DECIMAL(7, 2)
);

-- CREATING THE BRANCH TABLE
CREATE TABLE branch(
Branch_id INTEGER PRIMARY KEY,
Name VARCHAR(20),
Location VARCHAR(20)
);

SELECT  * FROM my_portfolio.employee;
SELECT* FROM my_portfolio.branch;
SELECT* FROM my_portfolio.pay;

-- INSERTING DATA INTO EMPLOYEE
INSERT INTO employee VALUES
(100, 'Mike', 'Shaw', 'Danville', 'IL', 2, 201),
(101, 'Kate', 'Teeter', 'Dayton', 'OH', 4, 202),
(103, 'Andrew', 'Jones', 'Boston', 'MA', 3, 203);

INSERT INTO my_portfolio.employee VALUES
(104, 'Michel', 'Stoke', 'Chicago', 'IL', 5, 204),
(105, 'Ashley', 'Page', 'Yellowstone', 'MT', 3, 205),
(106, 'Ken', 'Hrolin', 'Atlanata', 'GA', 2, 206),
(107, 'Alexis', 'Sanchez', 'Avon', 'IN', 4, 207),
(108, 'Ivan', 'Magomedov', 'Wichita', 'KS', 4, 208),
(109, 'Lionel', 'Pager', 'Lawrenceville', 'GA', 2, 209),
(110, 'Ashley', 'Lawrence', 'Indianapolis', 'IN', 3, 210);

-- INSERTING INTO PAY TABLE
INSERT INTO my_portfolio.pay(pay.Pay_id, pay.Rate, pay.First_week_Hours,
 pay.Second_week_Hours,
 pay.Third_week_Hours, pay.Fourth_week_Hours) 
 VALUES
(204, 19.00, 40, 20, 30, 35),
(205, 37.00, 40, 30, 40, 40),
(206, 15.89, 35, 23, 40, 31),
(207,  60.00, 40, 40, 40, 40),
(208, 40.00, 40, 40, 25, 38),
(209, 37.54, 35, 39, 40, 40),
(210, 100.00, 40, 35, 32, 47);


INSERT INTO branch VALUES
(2, 'College', 'Illinois'),
(3, 'Bishop', 'Louisiana'),
(4, 'Elfing', 'Kansas'),
(5, 'Mishop', 'Georgia');

-- TESTING OUT JOINS 
SELECT employee.First_Name, employee.Last_Name, pay.First_week_Hours, pay.Second_week_Hours, branch.Location, branch.Branch_id
FROM my_portfolio.employee
JOIN my_portfolio.pay
ON employee.Pay_id = pay.Pay_id
JOIN my_portfolio.branch
ON employee.Branch_id = branch.Branch_id;

-- Checking the employees pay rate and their branches
SELECT employee.First_Name, employee.Last_Name, pay.Rate, branch.Branch_id
FROM my_portfolio.employee
JOIN my_portfolio.pay ON employee.Pay_id = pay.Pay_id
JOIN my_portfolio.branch ON employee.Branch_id = branch.Branch_id;

-- Pay calculation (Rate * First week Hours)
UPDATE my_portfolio.pay
SET pay.First_week_Pay = (Rate * First_week_Hours);

SELECT my_portfolio.pay.Rate * my_portfolio.pay.First_week_Hours
FROM my_portfolio.pay;

-- selecting all data from all tables
SELECT * FROM my_portfolio.employee
JOIN my_portfolio.pay ON employee.Pay_id = pay.Pay_id
JOIN my_portfolio.branch ON employee.Branch_id = branch.Branch_id;

-- FORMULA FOR First to First week way  is  Rate * First_week_Hours, etc
-- PERFORMING CALCULATION FOR THE FIRST WEEK PAY 

SELECT * FROM my_portfolio.pay;
-- WEEK ONE PAY
UPDATE my_portfolio.pay
SET my_portfolio.pay.First_week_Pay = (pay.Rate * pay.First_week_Hours);

-- SECOND WEEK PAY
UPDATE my_portfolio.pay
SET pay.Second_week_Pay = (pay.Rate * pay.Second_week_Hours);

-- THIRD WEEK PAY
UPDATE my_portfolio.pay
SET pay.Third_week_Pay = (pay.Rate * pay.Third_week_Hours);

-- FOURTH WEEK PAY
UPDATE my_portfolio.pay
SET pay.Fourth_week_Pay = (pay.Rate * pay.Fourth_week_Hours);

-- TOTAL PAY FOR THE MONTH OF JANUARY
SELECT (First_week_Pay + Second_week_Pay + Third_week_Pay + Fourth_week_Pay) AS 'Total Pay For Jan'
FROM my_portfolio.pay;

UPDATE my_portfolio.pay
SET pay.Total_pay_January = (First_week_Pay + Second_week_Pay + Third_week_Pay + Fourth_week_Pay);

-- GETS US ALL TABLE IN ASCENDING ORDER FROM THE RATE COLUMN
SELECT * 
FROM my_portfolio.employee
JOIN my_portfolio.pay ON employee.Pay_id = pay.Pay_id
JOIN my_portfolio.branch ON employee.Branch_id = branch.Branch_id
ORDER BY Rate; -- Mike Shaw earns the lowest while Ashley Lawrence earns the highest per hour

-- Fixng an Error in the table. Replacing Last_Name from stoke to Stokes
UPDATE my_portfolio.employee
SET employee.Last_Name = 'Stokes'
WHERE employee.Emp_id = 104;

-- Finding Employees who earned over $1000 in Week One
SELECT First_Name, Last_Name, First_week_Pay
FROM my_portfolio.employee
JOIN my_portfolio.pay 
ON employee.Pay_id = pay.Pay_id
WHERE First_week_Pay > 1000;

-- Highest paid employee in January
SELECT MAX(pay.Total_pay_January)
 FROM my_portfolio.pay; -- gets us 15100.00 USD 
 
 -- We find the Pay_id of the MAX paid employee and use it as a sub-query to get their First and Last name.
SELECT employee.First_Name, employee.Last_Name, Pay_id
FROM my_portfolio.employee
WHERE Pay_id IN (
SELECT pay.Pay_id
FROM my_portfolio.pay
WHERE Total_pay_January = 15100.00);  /* Gets us the PayId 210 
which is passed back into the main query as an Argument */ 
-- Remenber the Pay_id is linked as foreign key in the employee table and as a PK in the Pay table

-- ANOTHER WAY TO FIND HIGHEST EMPLOYEE IN JANUARY USING JOINS 
-- select the max value first
SELECT max(pay.Total_pay_January)
FROM pay; -- Gives us 15100.00 USD

-- WE USE JOIN AND THE CONDITIONAL STATEMENT OF WHERE TO FILTER THE RESULT 
SELECT employee.First_Name, employee.Last_Name, pay.Total_pay_January
FROM my_portfolio.employee
JOIN my_portfolio.pay
ON employee.Pay_id = pay.Pay_id
WHERE Total_pay_January = 15100.00;

-- Which branch makes the most money;
SELECT * FROM my_portfolio.pay;
SELECT * FROM my_portfolio.branch;
SELECT * FROM my_portfolio.employee;

/*  The employee table have both the Pay_id and Branch_id columns as the foreign key.
Both columns are primary keys in another table */
/* The point is that the employee.Branch_id and the pay.Total_pa_January are composite 
keys used to uniquely identify each row */

SELECT  my_portfolio.employee.Branch_id, sum(my_portfolio.pay.Total_pay_January) AS 'Highest Paid Branch'
FROM my_portfolio.employee
JOIN my_portfolio.pay
ON my_portfolio.employee.Pay_id = my_portfolio.pay.Pay_id
GROUP BY Branch_id
ORDER BY 2 DESC; /* Highest Paid branch is 3 (Bishop, Louisiana,  with a total of 23900.00)
Least Paid branch is 5 (Mishop, Georgia,  with a total of 2565.00)
 */

-- ANOTHER WAY TO FIND HIGHEST PAID BRANCH
SELECT SUM(my_portfolio.pay.Total_pay_January) AS 'Branch Total' , my_portfolio.branch.Branch_id
FROM my_portfolio.employee
JOIN my_portfolio.pay ON my_portfolio.employee.Pay_id = my_portfolio.pay.Pay_id
JOIN my_portfolio.branch ON my_portfolio.employee.Branch_id = my_portfolio.branch.Branch_id
GROUP BY my_portfolio.branch.Branch_id;

-- THIS QUERY JOINS ALL THE TABLES TOGETHER 
SELECT *
FROM my_portfolio.employee
JOIN my_portfolio.pay
ON my_portfolio.employee.Pay_id = my_portfolio.pay.Pay_id
JOIN my_portfolio.branch
ON my_portfolio.employee.Branch_id = my_portfolio.branch.Branch_id;

