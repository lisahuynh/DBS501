/*Q1: 1-	Please work on CJ_XXXX (City Jail system) tables for these questions
Develop a Function which accept Officer_ID information and return Keyword Active or Inactive..

Function will perform additional checks.
 If Officer ID is not in the system Function will return ‘Not existing Officer’
If Officer ID is exists in the system and If Officer Status  is A in CJ_OFFICERS table and also if Officer BADGE number’s last digit is in between 0-5 then Function must return ACTIVE-ONDESK   keyword
Otherwise if  status is Active but Officer BADGE’s last digit is grater than 5 then Function must return ACTIVE-ONDUTY.
, if Officer Status is I then for sure Function must return INACTIVE keyword.
All other (Everything else ) situations Function must return UNKNOWN-STATUS

Perform several test for your function and capture all screen shots.
For  Officer_ID   111112  	 you must return   ACTIVE-ONDESK
                              111117 (inserted my own record)             you must return  ACTIVE-ONDUTY
For Officer_ID    5555555                                   ‘Not existing Officer’
                            111116                                         INACTIVE
*/

create or replace function officer_lookup
   (p_officer_id cj_officers.officer_id%type) 
   return varchar is
   v_status varchar(20);
begin
    select status into v_status from cj_officers where officer_id = p_officer_id;
    if (v_status = 'A' AND substr(p_officer_id,6,1) between 0 AND 5) then
        v_status := 'ACTIVE-ONDESK';
    elsif (v_status = 'A' AND substr(p_officer_id,6,1) > 5) then
        v_status := 'ACTIVE-ONDUTY';
    elsif (v_status = 'I') then
        v_status := 'INACTIVE';
    else 
        v_status := 'UNKNOWN-STATUS';
    end if;
    exception
        when no_data_found then
            v_status := 'NOT EXISTING OFFICER';
    return v_status;
end officer_lookup;

/*Q2: 2-	Develop a function FN_ Remaining_Fine_Amount)  to calculate Remaining Fine amount . This function must accept Crime_id and Crime_code as input parameter and return number value.
If Pay_Due_Date is in 2009 then calculation must be such 
Remaining_Fine_Amount := ( Fine_Amount+Court_Fee-Amount_Paid)  
For that particular Crime_code=xxxx AND Crime_code=yyyy  combination …  
  P.S: Amount_paid  column is NULL for some records and if you do not convert Null values in above calculation , then entire calculation will be wrong. Use NVL(Amount_Paid,0) foruma for that part.

Hint:   Use this below formala and technique and return result at the enf of Funtion 

Remaining_Fine_Amount := ( Fine_Amount+Court_Fee-NVL(Amount_Paid, xxx) )   
             WHERE Crime_code=parameter1 AND Crime_code=parameter2   
RETURN Remaining_Fine_Amount;
*/

create or replace function FN_Remaining_Fine_Amount
    (p_crimeid cj_crime_charges.crime_id%type,
    p_crimecode cj_crime_charges.crime_code%type)
    return number is
    v_remaining_amt cj_crime_charges.fine_amount%type := 0;
    v_fine_amt cj_crime_charges.fine_amount%type;
    v_court_fee cj_crime_charges.court_fee%type;
    v_amt_paid cj_crime_charges.amount_paid%type;
begin
    select fine_amount, court_fee, amount_paid into v_fine_amt, v_court_fee, v_amt_paid 
    from cj_crime_charges
    where crime_id = p_crimeid
    and crime_code = p_crimecode;
    v_remaining_amt := ((v_fine_amt + v_court_fee) - nvl(v_amt_paid,0));
    return v_remaining_amt;
end FN_Remaining_Fine_Amount;

/*Q3: 3-	Use DH_XXXX Dream Home Real Estate company database for this question
Develop a Function to return email service Provider for a given Private owner.  This function will receive one parameter as Input (OwnerNo) . Once OwnerNo is provided, Function will search on DH_PRIVATEOWNER  table and extract email service provider.. 
For instance let’s imagine owner CO66 is given as input… Return will be character as. Result will be gmail
Hint: Please use SUBSTR function to extract gmail portion from   bw@gmail.com   value for CO66. DO NOT return gmail as hard coded literal fixed value.  SUBSTR will find the position of @ symbol with the help of INSTR and add 1 (+1) to start from 1 digit after @’s position and extract all the way to end.
*/

create or replace function fn_email_service_provider
    (p_ownerno dh_privateowner.ownerno%type)
    return varchar is
    v_email_provider dh_privateowner.email%type;
begin
    select email into v_email_provider from dh_privateowner where ownerno = p_ownerno;
    v_email_provider := SUBSTR(v_email_provider, INSTR(v_email_provider, '@') + 1, 
    INSTR(v_email_provider, '.') - INSTR(v_email_provider, '@') - 1);
    return v_email_provider;
end fn_email_service_provider;
