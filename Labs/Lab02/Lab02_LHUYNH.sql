--Q1: List the names of all clients who have viewed a property along with any comment supplied.

select c.fname || ' ' || c.lname Name, p.street || ', ' || p.city || ', ' || p.postcode Address, nvl(v.comments,'No Comments') Comments
from dh_client c, dh_viewing v, dh_propertyforrent p
where c.clientno = v.clientno
and p.propertyno = v.propertyno;

--Q2: For each branch office, list the numbers and names of staff who manage properties, including the city in which the branch is located and the properties that the staff manage.

select s.fname || ' ' || s.lname Staff_Name, s.telephone Staff_Phone, s.mobile Staff_Mobile, b.city Branch_City, p.street || ', ' || p.city || ', ' || p.postcode Listings
from dh_staff s, dh_propertyforrent p, dh_branch b
where s.staffno = p.staffno
and b.branchno = p.branchno
order by s.staffno; 

--Q3: Human resources management team needs to find the name and hire_date of all employees who were hired before their managers along with their manager\'92s names and hire dates.
--Hint: Self Join

select e.last_name, e.hire_date, m.last_name, m.hire_date
from hr_employees e, hr_employees m
where e.manager_id = m.employee_id
and e.hire_date < m.hire_date;

--Q4: Get all the employees (details are id, first_name,salary, job_id ,department number , city and state info) for those  who has %REP%   in their job_id
--Hint: Join   \'85 also use WHERE LIKE  

select e.employee_id, e.first_name, e.salary, e.job_id, d.department_name, l.city, l.state_province
from hr_employees e, hr_departments d, hr_locations l
where e.department_id = d.department_id
and d.location_id = l.location_id
and e.job_id like '%REP%';
