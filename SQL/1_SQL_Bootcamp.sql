--Main Queries and Statements--

/*The Caps, semicolumn and parenthesis are not mandatory, they just improve readability */

-------------------SELECT-------------------------------

--SELECT--
/*SELECT column FROM table */

SELECT * FROM film; -- * For selecting ALL
SELECT first_name FROM actor;
SELECT first_name, last_name FROM actor;
SELECT first_name, last_name, email FROM customer;

--SELECT DISTINCT
/*For selecting Unique values */
/*SELECT DISTINCT column FROM table */

SELECT DISTINCT (last_name) FROM customer;
SELECT DISTINCT (rating) FROM film;

--SELECT COUNT
/*Returns the number of input rows that match the condition on the query,
the COUNT itself will basically only return the total number of rows for a table,
it is much more useful when combined with other comands */
/*SELECT COUNT column FROM table */

SELECT COUNT (*) FROM payment;
SELECT COUNT (DISTINCT (rating)) FROM film;

--SELECT WHERE
/*Here Comparison and Logical operators are applied */
/*SELECT column FROM table WHERE conditions */

SELECT * FROM customer WHERE first_name = 'Jared';
SELECT * FROM film WHERE rental_rate > 4;
SELECT * FROM film WHERE rental_rate > 4 AND replacement_cost >= 19.99 AND rating = 'R';
SELECT * FROM film WHERE rental_rate > 4 AND rating != 'R';
SELECT email FROM customer WHERE first_name='Nancy' AND last_name='Thomas';
SELECT description FROM film WHERE title='Outlaw Hanky';
SELECT phone FROM address WHERE address='259 Ipoh Drive';

--ORDER BY
/*Used to sort rows, can optionally be set ascending or descending*/
/*SELECT column FROM table ORDER BY column ASC/DESC */

SELECT store_id, first_name, last_name FROM customer ORDER BY store_id;
SELECT store_id, first_name, last_name FROM customer ORDER BY store_id DESC, first_name ASC;
SELECT first_name, last_name FROM customer ORDER BY store_id ASC, first_name ASC; --You may sort by columns that are not selected

--LIMIT
/*Allows us to limit the number of rows returned for a query*/
/*SELECT column FROM table LIMIT */
SELECT * FROM payment ORDER BY payment_date LIMIT 10;
SELECT DISTINCT * FROM category ORDER BY category_id LIMIT 10;
SELECT title, length FROM film ORDER BY length ASC LIMIT 5;
SELECT COUNT (title) FROM film WHERE length<=50;

--BETWEEN | NOT BETWEEN
/*Used to match a value against a range of values*/
/*SELECT column FROM table BETWEEN low AND high */
SELECT * FROM payment WHERE amount BETWEEN 8 AND 9;
SELECT * FROM payment WHERE amount NOT BETWEEN 8 AND 9;
SELECT * FROM payment WHERE payment_date BETWEEN '2007-02-01' AND '2007-02-15';

--IN | NOT IN
/*Used to create a condition that checks if a value is included in a list of multiple options */
/*SELECT column FROM table WHERE column IN (condition) */
SELECT * FROM payment WHERE amount IN (0.99,1.98,1.99) ORDER BY amount DESC;
SELECT COUNT (*) FROM payment WHERE amount NOT IN (0.99,1.98,1.99);

--LIKE (case sentitive) | ILIKE (case insensitive)
/*Used to make direct comparisons against patterns on string data
Percent % -> Matches any sequence of characters
Underscore _ -> Matches any single character, represents a space to be filled
*/
/*SELECT column FROM table WHERE table LIKE 'pattern' */
SELECT * FROM film WHERE title LIKE 'Mission Impossible _';
SELECT * FROM customer WHERE first_name ILIKE 'j%';
SELECT COUNT (*) FROM customer WHERE first_name LIKE 'J%' OR first_name LIKE 'K%';
SELECT * FROM customer WHERE first_name LIKE '_her%';
SELECT * FROM customer WHERE first_name LIKE 'A%' AND last_name NOT LIKE 'B%' ORDER BY last_name;

---------------------------------------------------------
--General Challenge--
SELECT COUNT (amount) FROM payment WHERE amount > 5.00;
SELECT COUNT (*) FROM actor WHERE first_name LIKE 'P%';
SELECT COUNT (DISTINCT(district)) FROM address;
SELECT DISTINCT district FROM address ORDER BY district;
SELECT COUNT (*) FROM film WHERE rating='R' AND replacement_cost BETWEEN 5 AND 15;
SELECT COUNT (*) FROM film WHERE title ILIKE '%Truman%';
SELECT COUNT (*) FROM film WHERE title LIKE '%Truman%';

--=====================================================--  

--Aggregate Functions
/*Most common aggregate functions:
AVG()
COUNT()
ROUND()
MAX()
MIN()
SUM()
 */
SELECT MIN(replacement_cost) FROM film;
SELECT MAX(replacement_cost),MIN(film_id) FROM film;
SELECT ROUND(AVG(replacement_cost),2) FROM film;
SELECT SUM(replacement_cost) FROM film;

--GROUP BY
/*Used to aggregate data per some category and apply functions 
Can be used only with SELECT or HAVING*/
/*SELECT column, AGG(data_col) FROM table | WHERE condition GROUP BY category_col *
AGG being any aggregate function*/
SELECT customer_id FROM payment GROUP BY customer_id ORDER BY customer_id; --This one is essencially the same as selecting all distinc customer ids
SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id ORDER BY sum DESC;
SELECT customer_id, COUNT(amount) FROM payment GROUP BY customer_id ORDER BY COUNT DESC;
SELECT customer_id, staff_id, SUM(amount) FROM payment GROUP BY staff_id,customer_id ORDER BY customer_id; -- Multiple combinations
SELECT DATE(payment_date) FROM payment; --DATE converts the cell information for Date
SELECT DATE(payment_date), SUM(amount) FROM payment GROUP BY DATE ORDER BY SUM;
--Challenges
SELECT staff_id, COUNT(payment_id) FROM payment WHERE staff_id IN (1,2) GROUP BY staff_id ORDER BY count DESC;
SELECT rating, ROUND(AVG(replacement_cost),3) FROM film GROUP BY rating ORDER BY AVG(replacement_cost) DESC;
SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 5;

--HAVING
/*Used to filter after an aggregation has already taken place, since for this cases is not possible to use 'WHERE'*/
/*SELECT column, SUM(column) FROM table WHERE column GROUP BY column HAVING SUM(sales) */
SELECT customer_id, SUM(amount) FROM payment WHERE customer_id NOT IN (184,87,477) GROUP BY customer_id HAVING SUM(amount) > 100;
SELECT store_id, COUNT(*) FROM customer GROUP BY store_id HAVING COUNT(*)>300;
--Challenges
SELECT customer_id, COUNT(payment_id) FROM payment GROUP BY customer_id HAVING COUNT(payment_id)>=40 ORDER BY COUNT(payment_id) DESC;
SELECT customer_id, SUM(amount) FROM payment WHERE staff_id=2 GROUP BY customer_id HAVING SUM(amount)>100 ORDER BY SUM(amount) DESC;

--================= Assessment Test 1 =================--
--1
SELECT customer_id FROM payment WHERE staff_id=2 GROUP BY customer_id HAVING SUM(amount)>110 ORDER BY SUM(amount) DESC;
--2
SELECT COUNT(title) FROM film WHERE title LIKE 'J%';
--3
SELECT first_name,last_name FROM customer WHERE first_name LIKE 'E%' AND address_id<500 ORDER BY customer_id DESC LIMIT 1;

--=====================================================-- 


----------------------JOIN------------------------------
/*
Join types:
-INNER
-OUTER
-FULL
-UNIONS
*/

--AS statement/clause
/*Allows us to create an 'alias' for a column or result
This statement is executed at the very end of a query meaning that we cannot use it insede a WHERE operator*/
/*SELECT column AS new_name FROM table*/
SELECT amount AS rental_price FROM payment;
SELECT SUM(amount) AS net_revenue FROM payment;
SELECT COUNT(amount) AS num_transactions FROM payment;
SELECT customer_id, SUM(amount) AS total_spent FROM payment GROUP BY customer_id;
SELECT customer_id, SUM(amount) AS total_spent FROM payment GROUP BY customer_id HAVING SUM(amount)>100; --You need to reffer to the original name and not the Alias

--INNER JOIN
/*Combine multiple tables together, the result will be the set of records that match in BOTH tables
If you declare junst JOIN it will be */
/*SELECT * FROM tableA INNER JOIN tableB ON tableA.col_match=TableB.col_match */
SELECT * FROM payment INNER JOIN customer ON payment.customer_id=customer.customer_id;
SELECT payment.customer_id,payment_id,first_name FROM payment INNER JOIN customer ON payment.customer_id=customer.customer_id ORDER BY first_name; -- when a column is exclusive to one table it need to be specified

-- FULL OUTER JOIN
/*Allows us to specify how to deal with values only present in one of the tables being joined
Joins every row from every table*/
/*SELECT * FROM tableA FULL OUTER JOIN tableB ON tableA.col_match=TableB.col_match*/ --this will include null values
/*SELECT * FROM tableA FULL OUTER JOIN tableB ON tableA.col_match=TableB.col_match WHERE tableA.id IS null OR tableB.id IS null*/
SELECT * FROM customer FULL OUTER JOIN payment ON customer.customer_id = payment.customer_id;
SELECT * FROM customer FULL OUTER JOIN payment ON customer.customer_id = payment.customer_id WHERE customer.customer_id IS null OR payment.payment_id IS null; --Verifies null values
SELECT COUNT(DISTINCT payment.customer_id) FROM payment FULL OUTER JOIN customer ON customer.customer_id = payment.customer_id;

--LEFT OUTER JOIN|LEFT JOIN
/*Results in a set or records that are in the LEFT table, if there is no match in the right table, the result is null
On this, the order of the tables matter*/
/*SELECT * FROM tableA LEFT OUTER JOIN tableB ON tableA.col_match=TableB.col_match*/
SELECT film.film_id,inventory_id,title FROM film LEFT OUTER JOIN inventory ON inventory.film_id = film.film_id;
SELECT film.film_id,inventory_id,title FROM film LEFT JOIN inventory ON inventory.film_id = film.film_id WHERE inventory.film_id IS null;
--RIGHT OUTER JOIN|RIGHT JOIN
/*Results in a set or records that are in the RIGHT table, if there is no match in the left table, the result is null
On , the order of the tables matter*/
/*SELECT * FROM tableA RIGHT OUTER JOIN tableB ON tableA.col_match=TableB.col_match*/
SELECT film.film_id,inventory_id,title FROM film RIGHT OUTER JOIN inventory ON inventory.film_id = film.film_id;
SELECT film.film_id,inventory_id,title FROM film RIGHT JOIN inventory ON inventory.film_id = film.film_id WHERE inventory.film_id IS null;

--UNION
/*Used to combine the result-set of two or more SELECT statements
It concatenates 2 results together*/
/*SELECT column_name(s) FROM table1 UNION SELECT column_name(s) FROM table2*/
SELECT district,email FROM address INNER JOIN customer ON address.address_id = customer.address_id WHERE district='California';
SELECT title,first_name,last_name FROM film_actor INNER JOIN actor ON film_actor.actor_id=actor.actor_id INNER JOIN film ON film_actor.film_id=film.film_id WHERE first_name='Nick' AND last_name='Wahlberg';

--=====================================================-- 


-----------------Advanced SQL commands-------------------

--Timestamps and Extractions

--SHOW ALL
/*Shows all available settings and information of your current workspace*/ 
SHOW ALL
SHOW TIMEZONE
SELECT NOW() --Current date-time
SELECT CURRENT_DATE
SELECT EXTRACT(YEAR FROM payment_date) FROM payment;

--EXTRACT()
/*Allows you to extract or obtain a sub-component of a date value */ 
SELECT EXTRACT(YEAR FROM payment_date) AS year FROM payment;
SELECT EXTRACT(QUARTER FROM payment_date) AS quarter FROM payment;

--AGE()
/*Calculates and returns the current age given a timastamp */
SELECT AGE(payment_date) FROM payment;

--TO_CHAR()
/*General function to convert data types to text. Usefull for timestamp formatting 
There are online tables available showing all text formating that can be used*/
SELECT TO_CHAR(payment_date,'MONTH-YYYY') FROM payment;
SELECT TO_CHAR(payment_date,'DAY,MONTH,YYYY') FROM payment
SELECT TO_CHAR(payment_date,'MONTH/YYYY') FROM payment;

---------------------------------------------------------
--General Challenge--
SELECT DISTINCT TO_CHAR(payment_date,'MONTH') FROM payment;
SELECT COUNT(*) FROM payment WHERE EXTRACT(dow FROM payment_date)=1;

--=====================================================--  

--Mathematical Operators
/*There are online tables available showing all operators that can be used*/
SELECT ROUND(rental_rate/replacement_cost,3)*100 FROM film;
SELECT 0.1 * replacement_cost AS deposit FROM film;

--String Functions and Operators
SELECT first_name || ' ' || last_name AS full_name FROM customer; --> || is for concatenating
SELECT first_name || ' ' || UPPER(last_name) AS full_name FROM customer;
/*LEFT allows you to select the number of characters from the string counting from the left*/
SELECT LOWER(LEFT(first_name,1)) || LOWER(last_name) || '@gmail.com' AS email FROM customer; 

--SubQuery
/*The SubQuery is performed first since it is inside the parenthesys*/
SELECT title,rental_rate FROM film WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);
SELECT film_id, title FROM film WHERE film_id IN (SELECT inventory.film_id FROM rental INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id 
WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30') ORDER BY title;
SELECT first_name,last_name FROM customer AS c WHERE EXISTS(SELECT * FROM payment AS p WHERE p.customer_id=c.customer_id AND amount>11);

--Self-join
/*Can be viewed as a join of two copies of the same table
It is necessary to use an alias for the table, otherwise the table names would be ambiguous*/
/*SELECT tableA.col, tableB.col FROM table AS tableA JOIN table AS tableB ON tableA.some_col = tableB.some_col*/
SELECT f1.title, f2.title, f1.length FROM film AS f1 INNER JOIN film AS f2 ON f1.film_id != f2.film_id AND f1.length=f2.length; -- Joining different movies that have the same length

--================= Assessment Test 1 =================--
--1
SELECT * FROM cd.facilities;
--2
SELECT name,membercost FROM cd.facilities;
--3
SELECT * FROM cd.facilities WHERE membercost!=0;
--4
SELECT * FROM cd.facilities WHERE membercost!=0 AND membercost< monthlymaintenance/50;
--5
SELECT * FROM cd.facilities WHERE name ILIKE '%tennis%';
--6
SELECT * FROM cd.facilities WHERE facid IN (1,5);
--7
SELECT memid,surname,firstname,joindate FROM cd.members WHERE joindate>='2012-09-01';
--8
SELECT DISTINCT surname FROM cd.members ORDER BY surname LIMIT 10;
--or
SELECT MAX(joindate) FROM cd.members;
--9
SELECT joindate FROM cd.members ORDER BY memid DESC LIMIT 1;
--10
SELECT COUNT(*) FROM cd.facilities WHERE guestcost>=10;
--11
SELECT facid,SUM(slots) AS Total_Slots FROM cd.bookings WHERE starttime>='2012-09-01' AND starttime<='2012-10-01' GROUP BY facid ORDER BY Total_Slots;
--12
SELECT facid,SUM(slots) AS total_slots FROM cd.bookings GROUP BY facid HAVING SUM(slots)>1000 ORDER BY facid;
--13
SELECT cd.bookings.starttime,cd.facilities.name FROM cd.bookings INNER JOIN cd.facilities ON cd.bookings.facid=cd.facilities.facid
WHERE cd.facilities.facid IN (0,1) AND cd.bookings.starttime>='2012-09-21' AND cd.bookings.starttime<'2012-09-22' ORDER BY cd.bookings.starttime;
--14
SELECT cd.bookings.starttime,cd.members.firstname,cd.members.surname FROM cd.bookings INNER JOIN cd.members ON cd.bookings.memid=cd.members.memid
WHERE firstname ILIKE 'David' AND surname ILIKE 'Farrell';
--=====================================================-- 


-------------Creating Databases and Tables---------------

--Data Types:
/*
-Boolean (True or False)
-Character (char, varchar, text)
-Numeric (integer, floating-point number)
-Temporal (date, time, timestamp, interval)

Not as commom data types:
-UUID
-Array
-JSON
-Hstore
-Special types
*/

--Primary Keys (PK)
/*Used To identify a row uniquely in a table.
Integer based and unique*/

--Foreign Keys
/*Field or group of field in a table that uniquely identifies a row in another table
A foreign key is defined in a table that references to the primary key of the other table
The table that contain the foreign key is called referencing/child table, whereas the source is referenced/parent table*/

/*Table keys will be listed under 'contraints' on each table*/

---------------------------------------------------------

--Constraints
/*
2 categories:
-Column constraints
-Table constraints

Types:
-NOT NULL
-UNIQUE
-PRIMARY Key
-FOREIGN Key
-CHECK
-EXCLUSION
-REFERENCES
*/

---------------------------------------------------------

--CREATE
/*CREATE TABLE table_name(
    column_name TYPE column_constraint,
    column_name TYPE column_constraint,
    table_constraint table_constraint
) INHERITS existing_table_name;*/

CREATE TABLE account(
	user_id SERIAL PRIMARY KEY, --SERIAL should only be used on the primary key and do not need a value to be provided
	username VARCHAR(50) UNIQUE NOT NULL,
	password VARCHAR(50) NOT NULL,
	email VARCHAR(250) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
	last_login TIMESTAMP
);

CREATE TABLE job(
	job_id SERIAL PRIMARY KEY,
	job_name VARCHAR(200) UNIQUE NOT NULL
);

--REFERENCES
/*Used for referencing a Foreign Key on a Intermediate table*/

CREATE TABLE account_job(
	user_id INTEGER REFERENCES account(user_id),
	job_id INTEGER REFERENCES job(job_id),
	hire_date TIMESTAMP
);

--INSERT 
/*Allows you to add rows to a table*/
/*INSERT INTO table (column1, column2, ...)
  VALUES
    (value1, value2, ...),
    (value1, value2, ...),...;
    
OR when inserting from another table

INSERT INTO table (column1, column2, ...)
  SELECT column1, column2,...
  FROM another_table
  WHERE condition;
*/

INSERT INTO account(username,password,email,created_on)
VALUES
('Jose','password','jose@email.com',CURRENT_TIMESTAMP);

INSERT INTO job(job_name)
VALUES
('Astronaut');

INSERT INTO account_job(user_id,job_id,hire_date)
VALUES
(1,1,CURRENT_TIMESTAMP); --In case you try to insert ids that are not in the database, an error will occur

--UPDATE
/*Allows to modify existing rows*/
/*UPDATE table 
  SET column1 =value1,
    column2=value2,...
  WHERE 
    condition;*/

UPDATE account
SET last_login = CURRENT_TIMESTAMP
WHERE last_login IS NULL;

UPDATE account
SET last_login = CURRENT_TIMESTAMP; --If the WHERE statement is not provided, all rows will be overwrite to the new value

UPDATE account 
SET last_login = created_on; -- You may also update based on another column

--UPDATE join
/*UPDATE tableA
  SET original_col = tableB.new_col
  FROM tableB
  WHERE tabelA.id=tableB.id;*/

UPDATE account_job 
SET hire_date = account.created_on
FROM account
WHERE account_job.user_id = account.user_id;

UPDATE account
SET last_login = CURRENT_TIMESTAMP
RETURNING email, created_on, last_login; -- RETURNING will return the selected rows

--DELETE
/*DELETE FROM table 
  WHERE row_id = 1;
  
  OR

  DELETE FROM tableA
  USING tableB
  WHERE tableA.id=tableB.id;*/
  
DELETE FROM table --will delete all rows

DELETE FROM job
WHERE job_id=3;

DELETE FROM job
WHERE job_name='Cowboy';

--ALTER TABLE 
/*Allows you to change an existing table structure*/
/*ALTER TABLE table_name 
action;*/

ALTER TABLE information
RENAME TO new_info;

ALTER TABLE new_info
RENAME COLUMN person TO people;

ALTER TABLE new_info
ALTER COLUMN people DROP NOT NULL; -- You may use either DROP or SET to modify constraints

--DROP
/*Allows for the complete removal of a column on a table*/
/*ALTER TABLE table_name 
DROP COLUMN col_name,... ;

ALTER TABLE table_name 
DROP COLUMN col_name CASCADE; --CASCADE removes all dependencies

ALTER TABLE table_name 
DROP COLUMN IF EXISTS col_name; --Check for existance to avoid errors
*/

ALTER TABLE new_info
DROP COLUMN people;

ALTER TABLE new_info
DROP COLUMN IF EXISTS people;

--CHECK constraint
/*Allows you to create more customized constraints that adhere to a certain condition*/
/*CREATE TABLE table_name(
    column_name TYPE column_constraint,
    column_name TYPE CHECK (column_name>20) ->insert any condition to be checked
);*/

CREATE TABLE employees(
	emp_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	birthdate DATE CHECK (birthdate>'1900-01-01'),
	hire_date DATE CHECK (hire_date>birthdate),
	salary INTEGER CHECK(salary>0)
);


--================= Assessment Test 2 =================--

--Teachers Table
CREATE TABLE teachers(
	teacher_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	homeroom_number INTEGER,
	department VARCHAR(50),
	email VARCHAR(250) UNIQUE NOT NULL,
	phone VARCHAR(11) UNIQUE NOT NULL
);

--Students Table
CREATE TABLE students(
	student_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	homeroom_number INTEGER,
	email VARCHAR(250) UNIQUE,
	phone VARCHAR(11) UNIQUE NOT NULL,
	grad_year DATE NOT NULL CHECK (grad_year>'2022-12-12')
);

--Inserting the first student
INSERT INTO students(
    first_name,
    last_name,
    homeroom_number,
    phone,
    grad_year)
VALUES(
    'Mark',
    'Watney',
    5,
    '7775551234',
    '2035-12-12');

--Inserting the first teacher
INSERT INTO teachers(
    first_name,
    last_name,
    homeroom_number,
	department,
	email,
    phone)
VALUES(
    'Jonas',
    'Salk',
    5,
	'Biology',
    'jsalk@school.org',
    '8884441234');

--=====================================================-- 


---------Conditional Expressions and Procedures----------

--CASE
/*We can use the CASE statement to only execute SQL code when certain conditions are met*/
/*-General CASE:
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE some_other_condition
END

-CASE Expression:
CASE expression
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ELSE some_other_result
END*/

SELECT customer_id,
CASE
	WHEN (customer_id<=100) THEN 'Premium'
	WHEN (customer_id BETWEEN 100 AND 200) THEN 'Plus'
	ELSE 'Regular'
END 
AS customer_class
FROM customer;

SELECT customer_id,
CASE customer_id --the expression is the best option when you're checking for a single value each time
	WHEN 2 THEN 'Winner'
	WHEN 5 THEN 'Second Place'
	ELSE 'Loser'
END
AS raffle_results
FROM customer;

SELECT 
SUM(CASE rental_rate
	WHEN 0.99 THEN 1
	ELSE 0
END)
AS bargains,
SUM(CASE rental_rate
	WHEN 2.99 THEN 1
	ELSE 0
END) 
AS regular,
SUM(CASE rental_rate
	WHEN 4.99 THEN 1
	ELSE 0
END) 
AS expensive
FROM film;

--=====================================================--  
--General Challenge--

SELECT 
SUM(CASE rating
	WHEN 'R' THEN 1
	ELSE 0
END)
AS r,
SUM(CASE rating
	WHEN 'PG' THEN 1
	ELSE 0
END)
AS pg,
SUM(CASE rating
	WHEN 'PG-13' THEN 1
	ELSE 0
END)
AS pg13
FROM film;
--------------------------------------------------------- 

--COALESCE
/*Accepts an unlimited number of arguments and returns the first argument that is not null if any
It is usefull when querying a table that contains null values*/
/*SELECT COALESCE (arg_1,arg_2,...arg_n)*/

SELECT item,(price - COALESCE(discount,0) --when it finds a null values, it will be replaced by zero in order to perform the operation, but no change will be made on the actual table
AS final FROM products);

--CAST
/*Lets you convert from one data type to another (when possible)*/
/*SELECT CAST ('5' AS INTEGER)
OR
SELECT CAST '5'::INTEGER; -> For PosgreSQL*/

SELECT CAST ('5' AS INTEGER) AS new_result;
SELECT CAST '10'::INTEGER;

--NULLIF
/*Takes 2 inputs and returns NULL if both are equal*/
/*NULLIF (arg1,arg2)*/

SELECT(
    SUM(CASE WHEN department='A' THEN 1 ELSE 0 END)/ --If department='B' is zero this would return an error without the NULLIF
    NULLIF(SUM(CASE WHEN department='B' THEN 1 ELSE 0 END),0) --it will retrieve the values from the first argument and compare to the second argument, returning null if they match
) AS departments_ratio 
FROM depts

--VIEW
/*A View is a database object made out of a stored Query
Used as a virtual table, so it does not store data physically
Usefull for long queries that will be used regularly
Viwes can also be dropped and altered as normal tables
*/

CREATE VIEW customer_info AS
SELECT first_name,last_name,address FROM customer
INNER JOIN address 
ON customer.address_id=address.address_id;

SELECT * FROM customer_info --> Selecting from the created view

CREATE OR REPLACE VIEW customer_info AS --> Can be used to rewrite a view
SELECT first_name,last_name,address FROM customer
INNER JOIN address 
ON customer.address_id=address.address_id;

