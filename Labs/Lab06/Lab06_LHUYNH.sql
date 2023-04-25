/*Q1: Handling Predefined Exceptions
 
The Just Lee Book order application page was modified so that an employee can enter a order number. If person enters a order number which has more than one records or  if  invalid order number is entered there should be EXCEPTION to handle these two situations. 
But If person enters valid order then it would display the info from JL_ORDERITEMS table.   

Exception handler  sections need to be added to the block that displays the message “Invalid Order Number” on screen. 
Or More than one record belong to this order number

Use an initialized variable named lv_order_num to provide a Order ID. 

This below code is given to you. Your job is to add exception handling (Proper predefined ones) and test three times with different order numbers….   First try with order#  1004 (for proper Order number which is returning 1 record),  then try 1009 ( for multiple records case)  , and then finally 1038 (for invalid order number)   
*/

DECLARE
  rec_order            jl_orderitems%ROWTYPE;
  lv_order_num     jl_orderitems.order#%TYPE  := &ordernum;
BEGIN
    SELECT *    INTO rec_order   FROM jl_orderitems       WHERE order# = lv_order_num;
    DBMS_OUTPUT.PUT_LINE(rec_order.order# || rec_order.isbn || rec_order.paideach);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('More than one record');
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid Order Number');
END;

/*Q2: Handling Exceptions with Undefined Errors
JL Book sell company wants to add a check constraint on the SHIPCOST column of the
ORDERS table. If a shopper’s shipcost is greater than 10 for an item,
JL BOOK wants to display the message “ShipCost can not be more than 10.Check amount” onscreen.  


This below code is given to you to start.

DECLARE
 
BEGIN
           insert into orders  values (1032,1005,SYSDATE,SYSDATE+3, '121 Eagle Str', 'SEATTLE','WA',98114,30);
 
END;


As you can see this is simply inserting a new order to table. But notice shipcost is 30 and it accept entry because there is no rule yet.
Now 
Run this ALTER TABLE, command to add check constraint to your table

ALTER TABLE orders
  ADD CONSTRAINT cost_ship_ck CHECK (shipcost < 10);

With this constraint no one can create an order entry with shipcost more than $10.
Try entering one entry with below sample code

DECLARE
 
BEGIN
           insert into orders  values (1033,105,SYSDATE,SYSDATE+3, '121 Eagle Str', 'SEATTLE','WA',98114,25);
 
END;

 Now add additional code to this block to trap the check constraint violation and display the message.
In the Exception handling section code should print message “ Ship cost is more than $10 , please reduce”

Note: Use new INSERT in your code to get error and exception message. For example
insert into orders  values (1033,1005,SYSDATE,SYSDATE+3, '121 Eagle Str', 'SEATTLE','WA',98114,30);



Hint: 
In Declare section use these

  anyname    EXCEPTION;
  PRAGMA EXCEPTION_INIT(anyname, -2290);
*/

DECLARE
  anyname    EXCEPTION;
  PRAGMA EXCEPTION_INIT(anyname, -2290);
BEGIN
  insert into jl_orders  values (1033,1005,SYSDATE,SYSDATE+3, '121 Eagle Str', 'SEATTLE','WA',98114,30);
EXCEPTION 
  WHEN OTHERS THEN
    IF SQLCODE = -2290 THEN
      DBMS_OUTPUT.PUT_LINE('Ship cost more than $10, please reduce');
      RAISE anyname;
    END IF;
END;


