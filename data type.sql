/* --------------- %TYPE (scholar data type) ---------- */
-- ?? ??? ?? ??? ?????? ??? ??? ??? ???? ?? ??.
-- ?????? ???? ?? ??? ?? ??? ???? %TYPE?? ?? ??.
-- %TYPE ??? ???? ?? ? ?? ??
-- DB column definition? ??? ?? ??? ??? ??? ? ??.
-- DB column definition? ?? ??? ?? PL/SQL? ?? ??? ??.
CREATE OR REPLACE PROCEDURE Emp_Info
( p_empno IN emp.empno%TYPE )
IS
-- %TYPE ???? ?? ?? 
v_empno emp.empno%TYPE; 
v_ename emp.ename%TYPE;
v_sal   emp.sal%TYPE;

BEGIN

DBMS_OUTPUT.ENABLE;

-- %TYPE ???? ?? ?? 
SELECT empno, ename, sal
INTO v_empno, v_ename, v_sal  
FROM emp
WHERE empno = p_empno ;

-- ??? ?? 
DBMS_OUTPUT.PUT_LINE( ' no : ' || v_empno ); 
DBMS_OUTPUT.PUT_LINE( ' name : ' || v_ename );
DBMS_OUTPUT.PUT_LINE( ' salary : ' || v_sal );

END;

-- execute
-- DBMS_OUTPUT ???? ??? ?? ????
SET SERVEROUTPUT ON;
EXECUTE Emp_Info(7369); 

/* ------------------------- ?? ??? ?? -------------------------- */
-- 1. %ROWTYPE: ?? ??? ????? ?? ??? ???? ??? ??? ??
-- PL/SQL???? ???? ?? ??? ??? ???.
-- %ROWTYPE ?? ?? ?? ?????? ??? ????.
-- ??? ???? ??? ??? ??? ?? ??? ?? ? ? ??.
-- ?????? ???? ?? DATATYPE? ?? ?? ? ?? ??.
-- ???? ??? ??? DATATYPE? ?? ? ?? ????? ???? ??? ??.
CREATE OR REPLACE PROCEDURE RowType_Test
( p_empno IN emp.empno%TYPE )
IS
    -- %ROWTYPE ?? ??, 
    -- emp???? ??? ??? ??? ? ??. 
    v_emp   emp%ROWTYPE ;
BEGIN
    DBMS_OUTPUT.ENABLE;

    -- %ROWTYPE ?? ?? 
    SELECT empno, ename, hiredate
    INTO v_emp.empno, v_emp.ename, v_emp.hiredate
    FROM emp
    WHERE empno = p_empno;

   DBMS_OUTPUT.PUT_LINE( 'no : ' || v_emp.empno );
   DBMS_OUTPUT.PUT_LINE( 'name : ' || v_emp.ename );
   DBMS_OUTPUT.PUT_LINE( 'hire date : ' || v_emp.hiredate );

END;
SET SERVEROUTPUT ON ;  
EXECUTE RowType_Test(7900);

-- 2. PL/SQL ??? ???
-- ??? SQL??? ????? ???. PL/SQL??? ???? ??? ??? ????? ???? ???? ?????.
-- ???? ??? ??? ??? ? ROW? ?? ???? ???? ?? ?? ?? ??
-- BINARY_INTEGER ??? ??? ??? ??? ????.
-- ??? ???? ? ?? ?? ???? ?? ??.
CREATE OR REPLACE PROCEDURE Table_Test
     (v_deptno IN emp.deptno%TYPE)

    IS

     -- ? ???? ??? ???? ?? 
     TYPE empno_table IS TABLE OF emp.empno%TYPE
     INDEX BY BINARY_INTEGER;

     TYPE ename_table IS TABLE OF emp.ename%TYPE
     INDEX BY BINARY_INTEGER;

     TYPE sal_table IS TABLE OF emp.sal%TYPE
     INDEX BY BINARY_INTEGER;

     -- ??????? ??? ???? ?? 
     empno_tab  empno_table ;
     ename_tab  ename_table ;
     sal_tab    sal_table;

     i BINARY_INTEGER := 0;

   BEGIN

     DBMS_OUTPUT.ENABLE;

     FOR emp_list IN(SELECT empno, ename, sal 
                     FROM emp WHERE deptno = v_deptno) LOOP

      /* emp_list? ?????? BINARY_INTEGER? ??? 1? ????. 
         emp_list?? ?? ??? ???? */

            i := i + 1;

           -- ??? ??? ??? ??? ???
            empno_tab(i) := emp_list.empno ;     
            ename_tab(i) := emp_list.ename ;
            sal_tab(i)   := emp_list.sal ;

      END LOOP;

      -- 1?? i?? FOR ?? ?? 
      FOR cnt IN 1..i LOOP

         -- TABLE??? ?? ?? ??? 
         DBMS_OUTPUT.PUT_LINE( 'no: ' || empno_tab(cnt) );
         DBMS_OUTPUT.PUT_LINE( 'name : ' || ename_tab(cnt) );
         DBMS_OUTPUT.PUT_LINE( 'salary : ' || sal_tab(cnt));

      END LOOP;

  END; 
  SET SERVEROUTPUT ON ;
  EXECUTE Table_Test(10);

-- 3. PL/SQL???
-- ???? ??? ??? ?? ???? ????.
-- ???, RECORD, ?? PL/SQL TABLE datatype? ?? ??? ??? ?? ??.
-- ??? ???? ?? ??? ??? ? ??? ? ??.
-- PL/SQL ???? ??? ?? ??? ??? ??? ? ??, ??? ???? ????.
CREATE OR REPLACE PROCEDURE Record_Test
      ( p_empno IN emp.empno%TYPE )

   IS
     -- ??? ???? ???? ???? ?? 
     TYPE emp_record IS RECORD
     (v_empno    NUMBER,
      v_ename    VARCHAR2(30),
      v_hiredate  DATE );

     emp_rec   emp_record ;
     
   BEGIN
     DBMS_OUTPUT.ENABLE;

     -- ???? ?? 
     SELECT empno, ename, hiredate
     INTO emp_rec.v_empno, emp_rec.v_ename, emp_rec.v_hiredate
     FROM emp
     WHERE empno = p_empno;

     DBMS_OUTPUT.PUT_LINE( 'no : ' || emp_rec.v_empno );
     DBMS_OUTPUT.PUT_LINE( 'name : ' || emp_rec.v_ename );
     DBMS_OUTPUT.PUT_LINE( 'hire date : ' || emp_rec.v_hiredate);
   END;
   
SET SERVEROUTPUT ON ;  
EXECUTE Record_Test(7369);

-- 4. PL/SQL Table of Record
-- PL/SQL TABLE?? ??? ???? ?????? %ROWTYPE?? ???? ??.
-- PL/SQL TABLE? RECORD? ?? ??? ??.

CREATE OR REPLACE PROCEDURE Table_Test
  IS
  
    i BINARY_INTEGER := 0;
 
    -- PL/SQL Table of Record? ??
    TYPE dept_table_type IS TABLE OF dept%ROWTYPE
    INDEX BY BINARY_INTEGER;
 
    dept_table dept_table_type;
 
  BEGIN
  
    FOR dept_list IN (SELECT * FROM dept) LOOP
 
      i:= i+1;
  
      -- TABLE OF RECORD? ??? ??
      dept_table(i).deptno := dept_list.deptno ;     
      dept_table(i).dname := dept_list.dname ;
      dept_table(i).loc   := dept_list.loc ;
 
    END LOOP;
 
    FOR cnt IN 1..i LOOP
 
       -- ??? ??
       DBMS_OUTPUT.PUT_LINE( ' dept no : ' || dept_table(cnt).deptno || 
                             'dept name : ' ||  dept_table(cnt).dname || 
                               'dept loc : ' || dept_table(cnt).loc );
 
    END LOOP;
 
 END;
 
 SET SERVEROUTPUT ON ;
 
 EXECUTE Table_test;