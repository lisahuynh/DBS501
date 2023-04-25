--Q1: What is the average salary in this organization (employees table)?

select to_char(avg(salary),'$9,999.99') average
from hr_employees;

--Q2: Display job ID for jobs with average salary more than 10000

select job_id, avg(salary)
from hr_employees
where salary > 10000
group by job_id;

--Q3: Display job ID, number of employees, sum of salary, and difference between highest salary and lowest salary of the employees of the job.

select job_id, count(*), sum(salary), max(salary) - min(salary) salary_difference
from hr_employees
group by job_id;

--Q4: What is the SQL command to list the total sales by customer and by product, with subtotals by customer and a grand total for all product sales? 
--Hint:
--GROUP BY	ROLLUP (column1, column2);

select cus_code, p_code, sum(sale_units * sale_price) subtotals
from dwdaysalesfact
group by rollup(p_code, cus_code);

--Q5: Using the answer to Problem 10 as your base, what command would you need to generate the same output but with subtotals in all columns? (Hint: Use the CUBE command).
--Hint:
-- GROUP BY	CUBE (Column1, Column 2);

select cus_code, p_code, sum(sale_units * sale_price) subtotals
from dwdaysalesfact
group by cube(cus_code, p_code)
order by cus_code;
