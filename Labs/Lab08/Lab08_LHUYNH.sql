/*Q1: Stored Procedure which does two operations (Insert and Update)

CREATE TABLE ADDRESS_POSTAL 
(
Postal_code    varchar2(6) PRIMARY KEY,
City               varchar2(40),
Province      varchar2(3)
)

Write a procedure to have TWO main  section in same procedure.. 

It will take input 4 parameters as postal code, city,  province and operation code  and inserts the values into the ZIPCODE table or update record. 
Here are the operations that you need to perform


If operation is ‘I’  then it means INSERT , If operation is ‘U’ then it means UPDATE
If it is ‘I’ then 
There should be a check to see if the postal code s already in the table. 
If it is, an exception will be raised and an error message will be displayed stating “ this postal code is already exists in the system”
Otherwise you just insert the record.
Write an anonymous block that uses the procedure and inserts your zip code

If the operation code is ‘U’ then it does Update the city name for that particular Postal Code.
For instance if the parameters are  ‘M5A 2J2’   ‘Milton’  ‘ON’ , ‘U’

Change the city info Toronto to Milton for Postal Code :  ‘M5A 2J2’   

Test case for Insert operations:
Test Case #1: Call Procedure with ‘M5G 2G4’  , ‘Niagrara’ , ‘ON’   and get message on screen shot

Test Case #2 : Call Procedure with M5J 3A1   a postal code for Scarborough  ON 

Test Case for Update operations

Test Case #3:   parameters  are  ‘M5A 2J2’   ‘Milton’  ‘ON’ , ‘U’
 update   postal code of ‘M5A 2J2’   city to Milton
*/

create or replace procedure insert_update_address
    (v_postal_code address_postal.postal_code%type,
    v_city address_postal.city%type,
    v_province address_postal.province%type,
    v_operation varchar)
as
    v_count number;
begin
    if (v_operation = 'I' or v_operation = 'i') then
        select count(*) into v_count from address_postal where postal_code = v_postal_code;
        if (v_counnt = 1) then
            raise_application_error(-20001, 'This postal code already exists in the system');
        end if;
        insert into address_postal(postal_code, city, province) values (v_postal_code, v_city, v_province);
        dbms_output.put_line('New address has been added');
    elsif (v_operation = 'U' or v_operation = 'u') then
        update address_postal 
        set city = v_city
        where postal_code = v_postal_code;
        if (sql%rowcount = 0) then
            raise_application_error(-20002, 'No address found');
        else
            dbms_output.put_line('Address has been updated');
        end if;
    else 
        dbms_output.put_line('Invalid operation');
    end if;
commit;
end;

/*Q2: Create a procedure called DEL_JOB to delete a job from the JOBS table.
a. Create a procedure called DEL_JOB to delete a job. Include the necessary
exception handling code if no job is deleted.
b. Compile the code; invoke the procedure using the job ID IT_DBA. Query the JOBS
table and view the results.
c. Test the exception handling section of the procedure by trying to delete a job
that does not exist. Use the IT_WEB as the job ID. */

create or replace procedure del_job
(v_job_id hr_jobs.job_id%type)
is
v_count number;
begin
    select count(*) into v_count from hr_jobs where job_id = v_job_id;
    if (v_count = 1) then 
        delete from hr_jobs where job_id = v_job_id;
        dbms_output.put_line(v_job_id || ' has been deleted.');
    else 
        raise_application_error(-20203, 'No jobs deleted.');
    end if;
commit;
end;

/*Q3: Create a procedure called GET_EMPLOYEE to query the employees table, retrieving
the salary and job ID for an employee when provided with the employee ID.
a. Create a procedure that returns a value from the SALARY and JOB_ID columns for a 
specified employee ID. Compile the code and remove syntax errors, if any.
b. Execute the procedure using host variables for the two OUT parameters -- one for the
salary and the other for the job ID. Display the salary and job ID for employee ID 120.*/

create or replace procedure get_employee
(v_emp_id in hr_employees.employee_id%type,
v_salary out hr_employees.salary%type,
v_job_id out hr_employees.job_id%type) is
begin
    select salary, job_id into v_salary, v_job_id from hr_employees where employee_id = v_emp_id;
end;

declare
    v_job_id hr_employees.job_id%type;
    v_salary hr_employees.salary%type;
begin
    get_employee(107, v_salary, v_job_id);
    dbms_output.put_line('v_salary');
    dbms_output.put_line('----');
    dbms_output.put_line(v_salary);
    dbms_output.put_line('v_job');
    dbms_output.put_line('----');
    dbms_output.put_line(v_job_id);
end;
