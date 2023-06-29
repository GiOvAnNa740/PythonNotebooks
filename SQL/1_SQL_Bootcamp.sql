--Main Queries and Statements--

/*The Caps, semicolumn and parenthesis are not mandatory, they just improve readability */

---------------------------------------------------------

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

-- SELECT COUNT
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