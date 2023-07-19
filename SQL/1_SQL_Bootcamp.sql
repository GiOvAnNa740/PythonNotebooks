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
