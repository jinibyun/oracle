-- PL SQL Block Structure
/*
DECLARE
    -- optional
    -- Variables, cursors, user-defined exceptions
BEGIN
    -- Mandatory
    -- SQL Statement    

EXCEPTION
    -- optional
    -- Actions to perform when errors occur
END
/ PL SQL Block end

*/

-- Type of PL/SQL block
-- 1. Anonymous
-- 2. Procedure
-- 3. Function


----------------------------
-- SQL Block
SET SERVEROUTPUT ON ;

BEGIN
  DBMS_OUTPUT.put_line ('Hello World!');
END;

----------------------------
DECLARE
  l_message  
  VARCHAR2 (100) := 'Hello World!';
BEGIN
  DBMS_OUTPUT.put_line (l_message);
END;

----------------------------
DECLARE
  l_message  VARCHAR2 (100) := 'Hello World!';
  sss varchar2(50) := 'XXX';
BEGIN
  DBMS_OUTPUT.put_line (sss);
EXCEPTION
  WHEN OTHERS
  THEN
    DBMS_OUTPUT.put_line (SQLERRM);
END;

----------------------------
DECLARE
  l_message  
  VARCHAR2 (100) := 'Hello';
BEGIN
  DECLARE
    l_message2     VARCHAR2 (100) := 
      l_message || ' World!'; 
  BEGIN
    DBMS_OUTPUT.put_line (l_message2);
  END;
EXCEPTION
  WHEN OTHERS
  THEN
    DBMS_OUTPUT.put_line 
   (DBMS_UTILITY.format_error_stack);
END;
----------------------------
DECLARE
  e_name  emp.ENAME%TYPE;
BEGIN
  SELECT ENAME
    INTO e_name
    FROM EMP
   WHERE empno = 7369;

  DBMS_OUTPUT.put_line (e_name);
END; 

----------------------------
DECLARE
  l_ename
  Emp.ename%TYPE;
BEGIN
  DELETE FROM EMP
       WHERE Ename = 'test';

  DBMS_OUTPUT.put_line (SQL%ROWCOUNT); -- same as @@rowCount in mssql
END;

--------------------------
DECLARE
   l_message   VARCHAR2 (100) := 'Hello';
BEGIN
   IF SYSDATE > TO_DATE ('01-JAN-2011')
   THEN
      DECLARE
         l_message2   VARCHAR2 (100) := ' World!';
      BEGIN
         l_message2 := l_message || l_message2;
         DBMS_OUTPUT.put_line (l_message2);
      END;
   ELSE
      DBMS_OUTPUT.put_line (l_message);
   END IF;
END;

------------------------------
DECLARE
   l_message   VARCHAR2 (100) := 'Hello';
BEGIN
   DECLARE
      l_message2   VARCHAR2 (5);
   BEGIN
      l_message2 := 'World!';
      DBMS_OUTPUT.put_line (
         l_message || l_message2);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (
            DBMS_UTILITY.format_error_stack);
   END;
   DBMS_OUTPUT.put_line (l_message);
END;
