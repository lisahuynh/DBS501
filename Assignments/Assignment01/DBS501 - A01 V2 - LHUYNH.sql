-- DBS501
-- Assignment #1 Version 2
-- February 27, 2023
-- Lisa Huynh

-- Q1: Create a visitor's application that prompts the user for the number of
-- visitors each day for the past 5 days and then displays the average number of
-- visitors per day (use & to accept new value)
-- Use PL/SQL Array (NUMBER type basic composite array type) and array has to have
-- 5 members only.
declare
    type my_array_type is table of number index by pls_integer;
    v_n_array my_array_type;
    v_avg number;
begin
    v_n_array(1) := &n1;
    v_n_array(2) := &n2;
    v_n_array(3) := &n3;
    v_n_array(4) := &n4;
    v_n_array(5) := &n5;
    v_avg := (v_n_array(1) + v_n_array(2) + v_n_array(3) + v_n_array(4) + v_n_array(5)) / 5;
    dbms_output.put_line('The average number of visitors is:    ' || v_avg);
end;

-- Q2: Create an odds/even program that prompts the user for a number. This number
-- will be top (cap) number. And your program will find out all the even and odd
-- numbers in between 1 to this max number.
declare
    maxNum number;
    counter number := 1;
begin
    maxNum := &max_number;
    if maxNum > 0 then
        while counter <= maxNum loop
            if mod(counter, 2) = 0 then
                dbms_output.put_line(counter || ' is an even number');
            else
                dbms_output.put_line(counter || ' is an odd number');
            end if;
            counter := counter + 1;
        end loop;
    else
        dbms_output.put_line('Sorry, I cannot calculate odd and even numbers for negative or zero numbers.');
    end if;
end;

-- Q3: a) Create (clone) another version of DEPARTMENTS table with Create table
-- as select command
create table new_departments as select* from hr_departments where 1=2;
select * from new_departments;
-- b) to f)
declare
v_max_deptno number;
cv_dept hr_departments%rowtype;
begin
select max(department_id) into v_max_deptno from hr_departments;
select * into cv_dept
from hr_departments
where department_id = v_max_deptno;
insert into new_departments values cv_dept;
end;

-- Q4: Create a metric distant conversion program. Ask the user three questions
-- and collect them with & substitution values
declare
 from_conv char(2);
 to_conv char(2);
 amount number;
 conv number;
begin
    from_conv := lower('&from');
    to_conv := lower('&to');
    amount := &amount;
    if from_conv = to_conv then
    dbms_output.put_line('same metric conversion is not possible');
    else
    case from_conv
        when 'km' then
            case to_conv
                when 'mt' then
                    conv := amount * 1000;
                when 'cm' then
                    conv := amount * 100000;
                when 'mm' then
                    conv := amount * 1000000;
            end case;
        when 'mt' then
            case to_conv
                when 'km' then
                    conv := amount * 0.001;
                when 'cm' then
                    conv := amount * 100;
                when 'mm' then
                    conv := amount * 1000;
            end case;
        when 'cm' then
            case to_conv
                when 'km' then
                    conv := amount * 0.00001;
                when 'mt' then
                    conv := amount * 0.01;
                when 'mm' then
                    conv := amount * 10;
            end case;
        when 'mm' then
            case to_conv
                when 'km' then
                    conv := amount * 0.000001;
                when 'mt' then
                    conv := amount * 0.001;
                when 'cm' then
                    conv := amount * 0.1;
            end case;
    end case;
    dbms_output.put_line(amount || from_conv || ' = ' || conv || to_conv);
    end if;
end;
