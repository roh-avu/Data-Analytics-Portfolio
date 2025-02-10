/*  Assignment7.sql
	Rohan Avuthu
	CS 31A, Winter 2023 */
/* uses megastore database and drops tables if they already exist */
USE megastore;

/* Display the product ID, product description, and price of the least expensive product in the database */
SELECT prod_id, prod_desc, prod_list_price
FROM products
WHERE prod_list_price = (SELECT MIN(prod_list_price) FROM products p); -- question 1, 2 rows

/* uses the IN operator to find the customer ID, first name, and last name of each customer for which as order was created on 10/01/2013.  */
SELECT cust_id, first_name, last_name
FROM customers
WHERE cust_id IN (SELECT cust_id FROM orders WHERE ord_date = '2013-10-01'); -- question 2, 2 rows

/* Repeat query 2, but this time, use the EXISTS operator in your answer. */ 
SELECT cust_id , first_name, last_name
FROM customers c
WHERE  EXISTS (SELECT cust_id FROM orders o WHERE c.cust_id = o.cust_id AND ord_date = '2013-10-01'); -- question 3, 2 rows

/* Display the order ID and order date for each order created for the customer William Morris */
SELECT ord_id, ord_date
FROM orders
WHERE cust_id IN (SELECT cust_id FROM customers WHERE first_name = 'William' AND last_name = 'Morris'); -- question 4, 6 rows

/* Display the product ID, product description, product price, and category for each product that has a unit price greater than the unit price of every product in category ID PET */
SELECT prod_id, prod_desc, catg_id, prod_list_price
FROM products p
WHERE p.prod_list_price > ANY (SELECT MAX(prod_list_price) FROM products WHERE catg_id = 'PET'); -- question 5, 1 row

/* Display all those employees who have a salary greater than that of an employee whose last name is Davies and are in the same department as an employee whose last name is Bell.

 */
SELECT emp_id, last_name, first_name, manager_id emp_mng, dept_id, hire_date, salary, job_id
FROM employees
WHERE salary > (
  SELECT salary
  FROM employees
  WHERE last_name = 'Davies'
) AND dept_id IN (
  SELECT dept_id
  FROM employees
  WHERE last_name = 'Bell' -- question 6, 4 rows
);

/* Display the department ID and minimum salary of all employees, grouped by department ID. This minimum salary must be greater than the minimum salary of those employees whose department ID is not equal to 50.  */
SELECT dept_id, MIN(salary) AS 'Min minimum'
FROM employees
GROUP BY dept_id
HAVING MIN(salary) > (
  SELECT MIN(salary)
  FROM employees
  WHERE dept_id != 50 
); -- question 7, 7 rows

/* SQL statement that finds the last names of all employees whose salaries are the same as the minimum salary for any department. */
SELECT last_name
FROM employees
WHERE salary = (
  SELECT MIN(salary)
  FROM departments
  WHERE departments.dept_id = employees.dept_id
); -- question 8, 39 rows

/* Write a pair-wise subquery listing the last name, first name, department ID, and manager ID for all employees that have the same department ID and manager ID as employee with ID 107. Exclude employee 107 from the result set. */
SELECT last_name, first_name, dept_id, manager_id
FROM employees
WHERE dept_id = (
    SELECT dept_id
    FROM employees
    WHERE emp_id = 107
) AND manager_id = (
    SELECT manager_id
    FROM employees
    WHERE emp_id = 107
) AND emp_id != 107; -- question 9, 3 rows

/* Write a non-pair-wise subquery listing the last name, first name, department ID, and manager ID for all employees that have the same department ID and manager ID as employee 107. */
SELECT last_name, first_name, dept_id, manager_id
FROM employees
WHERE (dept_id, manager_id) IN (
    SELECT dept_id, manager_id
    FROM employees
    WHERE emp_id = 107
) AND emp_id != 107; -- question 10, 3 rows

/* SQL statement that lists the highest earners for each department. Include the last name, department ID, and the salary for each employee.  */
SELECT e.last_name, e.dept_id, e.salary
FROM employees e
WHERE e.salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE dept_id = e.dept_id
); -- question 11, 9 rows

/* Display all customers who bought product 1050 AND product 1060.  */
SELECT c.cust_id, last_name
FROM customers c
JOIN orders o ON c.cust_id = o.cust_id
JOIN order_details od ON od.ord_id = o.ord_id AND od.prod_id IN (1050, 1060); -- question 12, 14 rows

/* These would be products in the PRODUCTS table that do not appear on any order. */
SELECT catg_id catg, prod_id, prod_desc, prod_list_price price
FROM products p
WHERE NOT EXISTS (SELECT prod_id FROM order_details od WHERE p.prod_id = od.prod_id); -- question 13, 15 rows


















