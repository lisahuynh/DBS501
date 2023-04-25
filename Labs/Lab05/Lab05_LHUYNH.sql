/*Q1: Evaluate the preceding PL/SQL block and determine the data type and value of each of
the following variables according to the rule of scoping.
a. The value of v_weight at position 1 is:
b. The value of v_new_locn at position 1 is:
c. The value of v_weight at position 2 is:
d. The value of v_message at position 2 is:
e. The value of v_new_locn at position 2 is:

PL/SQL BLock:
DECLARE
    v_weight    NUMBER(3)   := 600;
    v_message   VARCHAR2(255)   := 'Product 10012';
BEGIN
    DECLARE
        v_weight    NUMBER(3)   := 1;
        v_message   VARCHAR2(255)   := 'Product 11001';
        v_new_locn  VARCHAR2(50)    := 'Europe';
    BEGIN
        v_weight    := v_weight + 1;
        v_new_locn  := 'Western ' || v_new_locn;
    --1
    END;
  v_weight  := v_weight + 1;
  v_message := v_message || ' is in stock';
  v_new_locn    := 'Western ' || v_new_locn;
  --2
END;
/

a) 2
b) Western Europe
c) 601
d) Product 11012 is in stock
e) global variable doesn’t exist
*/

/*Q2: 
DECLARE
    v_customer  VARCHAR2(50)    := 'Womansport';
    v_credit_rating VARCHAR2(50)    := 'EXCELLENT';
BEGIN
    DECLARE
        v_customer  NUMBER(7)   := 201;
        v_name  VARCHAR2(25)    := 'Unisports';
    BEGIN
        v_credit_rating := 'GOOD';
        ...
    END;
...
END:
/
In the preceding PL/SQL block, determine the values and data types for each of the following
cases.
a. The value of v_customer in the nested block is:
b. The value of v_name in the nested block is:
c. The value of v_credit_rating in the nested block is:
d. The value of v_customer in the main block is:
e. The value of v_name in the main block is:
f. The value of v_credit_rating in the main block is:

a) 201
b) Unisports
c) GOOD
d) Womansport
e) variable is not declared
f) GOOD*/


/*Q3: Run this Create Table as SELECT command to create replica version of employees table

CREATE TABLE emp
AS
SELECT * FROM employees;

Then add one more column to this new table. New column name is stars (VARCHAR2  - 50 digit) . Run below command
ALTER TABLE emp ADD stars VARCHAR2(50);
SELECT emp table to see stars columns as empty.

Write PL/SQL anonyms block to fill newly added columns for each employee_id entered by end user from screen (use &emp_id  to test one particular employee_id)
*/
DECLARE
    v_empno    emp.employee_id%TYPE := 176;
    v_asterisk emp.stars%TYPE := NULL;
    sal        emp.salary%TYPE;
BEGIN
    SELECT
        round(salary / 1000)
    INTO sal
    FROM
        emp
    WHERE
        employee_id = v_empno;

    FOR i IN 1..sal LOOP
        v_asterisk := v_asterisk || '*';
        UPDATE emp
        SET
            stars = v_asterisk
        WHERE
            employee_id = v_empno;

    END LOOP;

END;

/*Q4: Develop a PL/SQL block that would go through all the employees from EMPLOYEES table who work in department_id= 90   (there is suppose to be 3 employee who work in Department 90)
 
IN BEGIN END END SECTION;

Execute 3 separate of SELECT  statement one after the other. Each SELECT will pull first_name , salary of each employee and store them in local variables.

SELECT LOAD INTO v_firstname1, v_salary1  WHERE employee_id=100
Then second 
SELECT first_name, salary INTO v_firstname2, v_salary2     ….. WHERE employee_id=101
Then third 
SELECT,  SELECT first_name, salary INTO v_firstname3, v_salary3     ….. WHERE employee_id=102

You must now have 6 local variables. DECLARE all of them accordingly in DECLARE section and use them in BEGIN and END.

Then add another SELECT statement in BEGIN-END to find company average salary

SELECT avg(salary) INTO v_avgsal FROM EMPLOYEES;
!!! Do not forget to create v_avgsal local variable in DECLARE section*/

DECLARE
    v_firstname1 hr_employees.first_name%TYPE;
    v_firstname2 hr_employees.first_name%TYPE;
    v_firstname3 hr_employees.first_name%TYPE;
    v_salary1    hr_employees.salary%TYPE;
    v_salary2    hr_employees.salary%TYPE;
    v_salary3    hr_employees.salary%TYPE;
    v_avgsal     hr_employees.salary%TYPE;
BEGIN
    SELECT
        first_name,
        salary
    INTO
        v_firstname1,
        v_salary1
    FROM
        hr_employees
    WHERE
        employee_id = 100;

    SELECT
        first_name,
        salary
    INTO
        v_firstname2,
        v_salary2
    FROM
        hr_employees
    WHERE
        employee_id = 101;

    SELECT
        first_name,
        salary
    INTO
        v_firstname3,
        v_salary3
    FROM
        hr_employees
    WHERE
        employee_id = 102;

    SELECT
        AVG(salary)
    INTO v_avgsal
    FROM
        hr_employees;

    IF v_salary1 > v_avgsal THEN
        dbms_output.put_line('Employee '
                             || v_firstname1
                             || ' salary '
                             || v_salary1
                             || ' is more than average salary');
    ELSE
        dbms_output.put_line('Employee '
                             || v_firstname1
                             || ' salary '
                             || 'is less than average salary');
    END IF;

    IF v_salary2 > v_avgsal THEN
        dbms_output.put_line('Employee '
                             || v_firstname2
                             || ' salary '
                             || v_salary2
                             || ' is more than average salary');
    ELSE
        dbms_output.put_line('Employee '
                             || v_firstname2
                             || ' salary '
                             || 'is less than average salary');
    END IF;

    IF v_salary3 > v_avgsal THEN
        dbms_output.put_line('Employee '
                             || v_firstname3
                             || ' salary '
                             || v_salary3
                             || ' is more than average salary');
    ELSE
        dbms_output.put_line('Employee '
                             || v_firstname3
                             || ' salary '
                             || 'is less than average salary');
    END IF;

END;

/*Q5: Investigate below code and explain how CONTINUE would impact the DBMS OUTPUT printing options. 
Go with each i iterations from 1 to 10 and also go with internal child FOR LOOP  j from 1
to 10
DECLARE 
 v_total NUMBER := 0;
BEGIN
 <<BeforeTopLoop>>
 FOR i IN 1..10 LOOP
   v_total := v_total + 1;
   dbms_output.put_line 
     ('Total is: ' || v_total);
   FOR j IN 1..10 LOOP
     CONTINUE BeforeTopLoop WHEN i + j > 5;
     v_total := v_total + 1;
   END LOOP;
 END LOOP;
END two_loop;

Based on the above code, the impact the CONTINUE statement would have on DBMS_OUTPUT 
printing would cause the inner loop to skip certain values of ‘i’ and ‘j’ but the outer 
loop will still execute DBMS_OUTPUT printing for each iteration.

*/
