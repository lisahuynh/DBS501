/*Q1: 1.	Write a trigger to update the customer balance when an invoice is deleted from LGINVOICE table. Name the trigger trg_updatecustbalance

Hint: In Trigger body, update LGCUSTOMER  for (WHERE) cust_code =  : old.cust_code 
Cust_balance must be equal to cust_balance-  old.inv_total
*/

create or replace trigger trg_updatecustbalance
    after delete on lginvoice
    for each row
begin
    update lgcustomer
    set cust_balance = cust_balance - :old.inv_total
    where cust_code = :old.cust_code;
end;

/*Q2: 2.	Create a trigger named trg_line_prod that will automatically update the product quantity on hand (P_QOH ) in PRODUCT TABLE  for each product sold after a new LINE row is added(inserted)  to LGLINE table. 

Hint: (just high level coding. Do not quote on me )
In Trigger body, update LGPRODUCT for (WHERE)  Prod_SKU = :NEW.Prod_SKU;
 And calculate PROD_QOH = PROD_QOH – new quantity
*/

create or replace trigger trg_line_prod
    after insert on lgline
    for each row
begin 
    update lgproduct 
    set prod_qoh = prod_qoh - :new.line_qty
    where prod_sku = :new.prod_sku;
end;

/*Q3: Please build this procedure and insert a new record with this procedure
Step1b:
CREATE OR REPLACE PROCEDURE new_job
( p_jobid IN jobs.job_id%TYPE, p_title IN  jobs.job_title%TYPE, v_minsal IN jobs.min_salary%TYPE)
IS 
v_maxsal jobs.max_salary%TYPE := 2 * v_minsal; 
BEGIN 
  INSERT INTO jobs(job_id, job_title, min_salary, max_salary) VALUES (p_jobid, p_title, v_minsal, v_maxsal); 

DBMS_OUTPUT.PUT_LINE ('New row added to JOBS table:'); DBMS_OUTPUT.PUT_LINE (p_jobid || ' ' || p_title ||' '|| v_minsal || ' ' || v_maxsal); 

Step1b:   to execute procedure to insert new record.
Please replace single quote ‘ ‘ from Word to your SQL Developer 
EXECUTE new_job (‘SY_ANAL’, ‘System Analyst’,6000)
This will create a new JOB_ID in JOBS table. So you can use this for Task 2
*/

create or replace PROCEDURE new_job
( p_jobid IN hr_jobs.job_id%TYPE, p_title IN  hr_jobs.job_title%TYPE, v_minsal IN hr_jobs.min_salary%TYPE)
IS 
v_maxsal hr_jobs.max_salary%TYPE := 2 * v_minsal; 
BEGIN 
  INSERT INTO hr_jobs(job_id, job_title, min_salary, max_salary) VALUES (p_jobid, p_title, v_minsal, v_maxsal); 
    DBMS_OUTPUT.PUT_LINE ('New row added to JOBS table:'); DBMS_OUTPUT.PUT_LINE (p_jobid || ' ' || p_title ||' '|| v_minsal || ' ' || v_maxsal); 
END new_job;

/*Q4: In this exercise, create a program to add a new row to the JOB_HISTORY table, for an
existing employee.
a. Create a stored procedure called ADD_JOB_HIST to add a new row into the JOB_HISTORY
table for an employee who is changing his job to the new job ID ('SY_ANAL') that you created.
The procedure should have two parameters, one for the employee ID who is changing the job,
and the second for the new job ID. Read the employee ID from the EMPLOYEES table and insert
it into the JOB_HISTORY table. Make the hire date of this employee as start date and today's
date as end date for this row in the JOB_HISTORY table.
Change the hire_date of this employee in the EMPLOYEES table to today's date. Update the
job ID of this employee to the job ID passed as parameter (use the 'SY_ANAL' job ID) and
salary equal to the minimum salary for the job ID + 500.
b. Disable all triggers on the EMPLOYEES, JOBS, and JOB_HISTORY tables before invoking
the procedure.
c. Execute the procedure with employee ID 106 and job ID 'SY_ANAL' as parameters.*/

create or replace procedure add_job_hist
    (p_empid hr_employees.employee_id%type,
    p_jobid hr_jobs.job_id%type) as
    v_min_salary hr_jobs.min_salary%type;
    v_employee_count number(1);
begin
    select count(*) into v_employee_count from hr_employees where employee_id = p_empid;
    if v_employee_count = 0 then
        raise_application_error(-20001, 'Invalid employee id.');
    end if;

    select min_salary into v_min_salary from hr_jobs where job_id = p_jobid;

    insert into hr_job_history(employee_id, start_date, end_date, job_id, department_id)
    values(p_empid, (select hire_date from hr_employees where employee_id = p_empid), SYSDATE, p_jobid, 
    (select department_id from hr_employees where employee_id = p_empid));

    update hr_employees
    set hire_date = sysdate,
        job_id = p_jobid,
        salary = v_min_salary + 500
    where employee_id = p_empid;
end add_job_hist;
