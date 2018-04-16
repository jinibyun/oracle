/* ------------------ exception --------------- */
-- 1. pre-defined

CREATE OR REPLACE PROCEDURE preexception_test (
    v_deptno   IN emp.deptno%TYPE
) IS
    v_emp   emp%rowtype;
BEGIN
    dbms_output.enable;
    SELECT
        empno,
        ename,
        deptno
    INTO
        v_emp.empno,v_emp.ename,v_emp.deptno
    FROM
        emp
    WHERE
        deptno = v_deptno;

    dbms_output.put_line('no : ' || v_emp.empno);
    dbms_output.put_line('name : ' || v_emp.ename);
    dbms_output.put_line('dept no : ' || v_emp.deptno);
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Aldeady data exist');
        dbms_output.put_line('DUP_VAL_ON_INDEX error');
    WHEN too_many_rows THEN
        dbms_output.put_line('TOO_MANY_ROWS error');
    WHEN no_data_found THEN
        dbms_output.put_line('NO_DATA_FOUND error');
    WHEN OTHERS THEN
        dbms_output.put_line('other errors');
END;
/
SET SERVEROUTPUT ON ;  
EXECUTE PreException_Test(20);

/*
Resolution:

Following query will return multiple result set. It should be used 
*/
FOR  emp_list  IN
      (SELECT empno, ename, deptno
       FROM emp
       WHERE deptno = v_deptno)   LOOP

      DBMS_OUTPUT.PUT_LINE('no : ' || emp_list.empno);
      DBMS_OUTPUT.PUT_LINE('name : ' || emp_list.ename);
      DBMS_OUTPUT.PUT_LINE('dept no : ' || emp_list.deptno);

  END LOOP;