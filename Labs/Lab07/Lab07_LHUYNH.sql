/*Q1: Write a PL/SQL block to print information about a given country.
a. Declare a PL/SQL record based on the structure of the countries table.
b. Declare a variable v_countryid. Assign CA to v_countryid
c. In the declarative section, use the %ROWTYPE attribute and declare the
v_country_record variable of type countries.
d. In the executable section, get all the information from the countries table
by using countryid. Display selected information about the country. */

DECLARE
    v_countryid hr_countries.country_id%TYPE := 'CA';
    v_country_record hr_countries%ROWTYPE;
BEGIN
    select * into v_country_record from hr_countries
    where country_id = v_countryid;
    dbms_output.put_line('Country Id: ' || v_country_record.country_id || ' Country Name: ' || 
    v_country_record.country_name || ' Region: ' || v_country_record.region_id);
END;

/*Q2: Cursor activity 

Let's create a new empty table called employee_promotion
           CREATE TABLE employee_promotion
        AS SELECT employee_id, first_name,last_name, sysdate as promition_date , hire_date,job_id, salary, department_id  FROM employees
        WHERE 1=2

your job is to fill this new built table with employee info and their promotion date.. Promotion date is defined based on their department and their current salary...
 Create a PL/SQL Block program to process every employee
 your cursor should include every columns (Fields ) from employees table and for all the employees record
 add CURSOR FOR LOOP section to fetch and process each record one by one
  Check each record and prepare INSERT statement accordingly
  


  IF employee department is either 60 or 100 or 50 and at the same time employee salary is in between 1000 and 8000 
  then  promotion date is set as today
  employee_id, first_name,last_name, sysdate as promition_date , hire_date,job_id, salary, department_id
               INSERT INTO employee_promotion VALUES (rec.employee_id ,rec.first_name,rec.last_name, promotion date  , rec.hire_date,rec.job_id, rec.salary, rec.department_id)
   IF employee department is either 60 or 100 or 50 and at the same time employee salary is grater than 8000 
   then promotion date is set 3 months later   ( you can use ADD_MONTHS (sysdate, 3)  function  )
             INSERT INTO employee_promotion VALUES (rec.employee_id ,rec.first_name,rec.last_name, promotion date  , rec.hire_date,rec.job_id, rec.salary, rec.department_id)
   IF employee department is either 40 or 80 or 20 and at the same time employee salary is in between 2000 and 6000 
  then  promotion date is 2 months later
                INSERT INTO employee_promotion VALUES (rec.employee_id ,rec.first_name,rec.last_name, promotion date  , rec.hire_date,rec.job_id, rec.salary, rec.department_id)
  IF employee department is either 40 or 80 or 20 and at the same time employee salary is grater than  6000 
  then  promotion date is 3 months later
  
  Everyone else's promotion date is 6 months later
  
  
 Complete and execute your PL/SQL block ..

And select employee_promotion  table to confirm all records are inserted.*/

DECLARE
    CURSOR c_emp_cursor IS
    SELECT * FROM hr_employees;
    v_emp_record c_emp_cursor%ROWTYPE;
    v_promotion_date DATE;
BEGIN
    OPEN c_emp_cursor;
    LOOP
        FETCH c_emp_cursor INTO v_emp_record;
        EXIT WHEN c_emp_cursor%NOTFOUND;
        
        IF v_emp_record.department_id IN (60, 100, 50) AND v_emp_record.salary BETWEEN 1000 AND 8000 THEN
            v_promotion_date := SYSDATE;
        ELSIF v_emp_record.department_id IN (60, 100, 50) AND v_emp_record.salary > 8000 THEN
            v_promotion_date := ADD_MONTHS(SYSDATE, 3);
        ELSIF v_emp_record.department_id IN (40, 80, 20) AND v_emp_record.salary BETWEEN 2000 AND 6000 THEN
            v_promotion_date := ADD_MONTHS(SYSDATE, 2);
        ELSIF v_emp_record.department_id IN (40, 80, 20) AND v_emp_record.salary > 6000 THEN
            v_promotion_date := ADD_MONTHS(SYSDATE, 3);
        ELSE
            v_promotion_date := ADD_MONTHS(SYSDATE, 6);
        END IF;

        INSERT INTO employee_promotion (
            employee_id,
            first_name,
            last_name,
            promition_date,
            hire_date,
            job_id,
            salary,
            department_id
        ) VALUES (
            v_emp_record.employee_id,
            v_emp_record.first_name,
            v_emp_record.last_name,
            v_promotion_date,
            v_emp_record.hire_date,
            v_emp_record.job_id,
            v_emp_record.salary,
            v_emp_record.department_id
        );
        
    END LOOP;
    CLOSE c_emp_cursor;
END;
