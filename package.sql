/* ------------------- Package -------------------------- */
-- 1. package declare
CREATE OR REPLACE PACKAGE pack_emp_info AS
    PROCEDURE all_emp_info;   -- all employees

    PROCEDURE all_sal_info;   -- all employees's salary (avg)

    PROCEDURE dept_emp_info ( -- some dept's employees
        v_deptno IN NUMBER
    );

    PROCEDURE dept_sal_info ( -- soem dept's salary (avg)
        v_deptno IN NUMBER
    );

END pack_emp_info;
/

-- 2. package body
CREATE OR REPLACE PACKAGE BODY pack_emp_info AS

     -- 1. get all employees
     PROCEDURE all_emp_info
     IS
         CURSOR emp_cursor IS
         SELECT empno, ename, to_char(hiredate, 'RRRR/MM/DD') hiredate
         FROM emp
         ORDER BY hiredate;
     BEGIN

         FOR aa IN emp_cursor 
         LOOP
             DBMS_OUTPUT.PUT_LINE('no : ' || aa.empno);
             DBMS_OUTPUT.PUT_LINE('name : ' || aa.ename);
             DBMS_OUTPUT.PUT_LINE('hire date : ' || aa.hiredate);
         END LOOP;

         EXCEPTION
           WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE(SQLERRM||' error occurred to ger all emp info ');

     END all_emp_info;


     -- 2. all employees's salary
     PROCEDURE all_sal_info
     IS
         CURSOR emp_cursor IS
         SELECT round(avg(sal),3) avg_sal, max(sal) max_sal, min(sal) min_sal
         FROM emp;
     BEGIN

         FOR  aa  IN emp_cursor LOOP
 
             DBMS_OUTPUT.PUT_LINE('all average salary : ' || aa.avg_sal);
             DBMS_OUTPUT.PUT_LINE('max salary : ' || aa.max_sal);
             DBMS_OUTPUT.PUT_LINE('min salary : ' || aa.min_sal);
         
         END LOOP;


         EXCEPTION
            WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM||'error getting all salary average ');
     END all_sal_info;
     
     --3. some dept's employee
     PROCEDURE dept_emp_info (v_deptno IN  NUMBER)
     IS
         CURSOR emp_cursor IS
         SELECT empno, ename, to_char(hiredate, 'RRRR/MM/DD') hiredate
         FROM emp
         WHERE deptno = v_deptno
         ORDER BY hiredate;
     BEGIN

         FOR  aa  IN emp_cursor 
         LOOP
             DBMS_OUTPUT.PUT_LINE('no : ' || aa.empno);
             DBMS_OUTPUT.PUT_LINE('name : ' || aa.ename);
             DBMS_OUTPUT.PUT_LINE('hire date : ' || aa.hiredate);

         END LOOP;

        EXCEPTION
            WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM||'error getting some employee information ');

     END dept_emp_info;


     --4. some dept's average salary
     PROCEDURE dept_sal_info (v_deptno IN  NUMBER)
     IS
    
         CURSOR emp_cursor IS
         SELECT round(avg(sal),3) avg_sal, max(sal) max_sal, min(sal) min_sal
         FROM emp 
         WHERE deptno = v_deptno;
             
     BEGIN

         FOR  aa  IN emp_cursor 
         LOOP 
             DBMS_OUTPUT.PUT_LINE('average salary : ' || aa.avg_sal);
             DBMS_OUTPUT.PUT_LINE('max salary : ' || aa.max_sal);
             DBMS_OUTPUT.PUT_LINE('min salary : ' || aa.min_sal);
         
         END LOOP;

         EXCEPTION
             WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM||'error getting some dept salary ');

     END dept_sal_info;        
    
  END pack_emp_info;
  /
  
SET SERVEROUTPUT ON ; 

EXEC pack_emp_info.all_emp_info;

EXEC pack_emp_info.all_sal_info;

EXEC pack_emp_info.dept_emp_info(10);

EXEC pack_emp_info.dept_sal_info(10); 