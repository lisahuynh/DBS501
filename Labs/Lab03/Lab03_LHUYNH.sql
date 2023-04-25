--Q1: List the properties that are handled by staff who work in the branch at  \'9116 Argyll Street\'92
--Hint : Sub query. Three tables are involving.  FROM SH_PropertyForRent  to DH_Staff to DH_Branch 

select p.propertyno, p.street, p.city, p.postcode, p.staffno, p.branchno
from dh_branch b, dh_propertyforrent p, dh_staff s
where b.branchno = p.branchno
and b.branchno = s.branchno
and b.branchno = (select branchno 
                    from dh_branch
                    where street = '16 Argyll Street');

--Q2: Find all Managers who work at a London branch \'85 City = \'91London\'92
--Hint: Subquery  From DH_Staff table DH_Branch 

select s.fname, s.lname, s.position, s.branchno, b.city
from dh_staff s, dh_branch b
where b.branchno = s.branchno
and s.position = 'Manager'
and b.branchno in (select branchno
                    from dh_branch
                    where city = 'London');

--Q3: Determine which customers placed orders for the least expensive book (in terms of regular retail price) carried by JustLee Books.

select c.firstname, c.lastname, oi.isbn, b.title, b.retail
from jl_orders o, jl_orderitems oi, jl_books b, jl_customers c
where b.isbn = oi.isbn
and c.customer# = o.customer#
and o.order# = oi.order#
and b.retail = (select min(retail)
                from jl_books);
 
--Q4: Find out which other books were published by the same publisher of BODYBUILD IN 10 MINUTES A DAY book.

select b.isbn, b.title, ba.authorid
from jl_books b, jl_bookauthor ba, jl_author a
where b.isbn = ba.isbn
and ba.authorid = a.authorid
and ba.authorid in (select ba.authorid
                from jl_books b, jl_bookauthor ba
                where b.isbn = ba.isbn
                and title = 'BODYBUILD IN 10 MINUTES A DAY')
order by b.isbn;

--Q5: Find out employees\'92 ID who has never been changed his/her job since the beginning.   (Find out whose record never gone to JOB_HISTORY table and stayed only in EMPLOYEE Table)
--Hint: Use MINUS  set operator

select employee_id, first_name, last_name
from hr_employees
where employee_id in (select employee_id
                    from hr_employees
                    minus select distinct(employee_id)
                    from hr_job_history);
