DROP TABLE IDENTITY_TEST_TABLE;
CREATE TABLE IDENTITY_TEST_TABLE
(
  ID NUMBER GENERATED AS IDENTITY , NAME2 varchar(30) 
);
create table t1 ( x1 int generated as identity, y1 int);


create table 
   customer
  (cust_id number 
      generated as identity , 
   cust_name varchar2(20));

declare
   s2 number;
 begin
   INSERT INTO IDENTITY_TEST_TABLE (name) VALUES ('atilla') returning ID into s2;
   dbms_output.put_line(s2);
 end;