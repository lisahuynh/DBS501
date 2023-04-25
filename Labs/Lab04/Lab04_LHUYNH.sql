{\rtf1\ansi\ansicpg1252\cocoartf2639
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 /*Q1: Create a PL/SQL block that selects the maximum department ID in the departments table\
and stores it in the v_max_deptno variable. Display the maximum department ID.\
a. Declare a variable, v_max_deptno, of type NUMBER in the declarative section.\
b. Start the executable section with the BEGIN keyword and include a SELECT statement to\
retrieve the maximum department_id from the departments table.\
c. Display v_max_deptno and end the executable block.*/\
\
declare\
v_max_deptno hr_departments.department_id%type;\
begin\
select max(department_id) into v_max_deptno from hr_departments;\
dbms_output.put_line('The maximum department_id is: ' || v_max_deptno);\
end;\
\
/*Q2: Modify the PL/SQL block you created in Q1 to insert a new department in the departments\
table.\
a. Declare two varaibles: v_dept_name of type departments.department_name, v_dept_id of type \
NUMBER. Assign "Education" to v_dept_name in the declarative section.\
b. You have already retrieved the current maximum department ID from the departments table. \
Add 10 to it and assign the result to v_dept_id.\
c. Include an INSERT statement to insert data into the departments_name, department_id, and\
location_id columns of the departments table. Use values in v_dept_name and v_dept_id for \
department_name and department_id, respectively and use NULL for location_id.\
d. Use the SQL attrinute SQL%ROWCOUNT to display the number of rows that are affected.*/\
\
declare\
v_max_deptno hr_departments.department_id%type;\
v_dept_name hr_departments.department_name%type:= 'Education';\
v_dept_id hr_departments.department_id%type;\
begin\
select max(department_id) into v_max_deptno from hr_departments;\
v_dept_id := v_max_deptno + 10;\
insert into hr_departments (department_id, department_name)\
values (v_dept_id, v_dept_name);\
select max(department_id) into v_max_deptno from hr_departments;\
dbms_output.put_line('The maximum department_id is: ' || v_max_deptno);\
end;\
\
select * from hr_departments\
where department_id = (select max(department_id)\
                        from hr_departments);\
\
/*Q3: \
c. Declare the v_basic_percent and v_pf_percent variables and initialize them to 45 and 12,\
respectively. Also, declare two variables: v+_fname of type VARCHAR2 and size 15, and v_emp_sal\
of type NUMBER and size 10.\
d. Include the following SQL statement in executable section:\
SELECT first_name, salary\
INTO v_fname, v_emp_sal FROM employees\
WHERE employee_id = 110;\
e. Change the line that prints "Hello WOrld" to print "Hello" and the first name. You can comment\
the lines that display the dates and print the bind variables, if you want to.\
f. Calculate the contribution of the employee toward provident fund (PF). PF is 12% of the basic\
salary and basic salary is 45% of the salary. Use the local vairables for the calculation. Try and\
use only one expression to calculate the PF. Print the employee's salary and his contribution toward\
PF. */\
\
declare\
v_basic_percent number := 45;\
v_pf_percent number := 12;\
v_fname varchar2(15);\
v_emp_sal number(10);\
begin\
select first_name, salary \
into v_fname, v_emp_sal from hr_employees\
where employee_id = 110;\
dbms_output.put_line('Hello ' || v_fname);\
dbms_output.put_line('YOUR SALARY IS: ' || v_emp_sal);\
dbms_output.put_line('YOUR CONTRIUBUTION TOWARDS PF: ' || (v_emp_sal*45/100)*12/100);\
end;\
}