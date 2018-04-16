-- A. Implicit cursor
-- Definition: address of execution of all sql statement (DML) in oracle. every sql statement create implicit cursor. 
-- On executing SQL, open and close cursor is automatically done by oracle
/*
SQL%ROWCOUNT : affected row count
SQL%FOUND : True if affected row is more than one
SQL%NOTFOUND : TRUE if affected row is zero
SQL%ISOPEN : Alwasys FALSE, check just in case
*/
CREATE OR REPLACE PROCEDURE implicit_cursor (
    p_empno   IN emp.empno%TYPE
) IS
    v_sal          emp.sal%TYPE;
    v_update_row   NUMBER;
BEGIN
    SELECT
        sal
    INTO
        v_sal
    FROM
        emp
    WHERE
        empno = p_empno;

    IF
        SQL%found
    THEN
        dbms_output.put_line(' Data Found: '
        || v_sal);
    END IF;
    UPDATE emp
        SET
            sal = sal * 1.1
    WHERE
        empno = p_empno;

    v_update_row := SQL%rowcount;
    dbms_output.put_line('A number of employee whose salary is updated: '
    || v_update_row);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line(' No Data ');
END;
/

-- ececute procedure

EXECUTE implicit_cursor(7369);

-- B. Explicit Cursor
-- declared by programmer

CREATE OR REPLACE PROCEDURE expcursor_test (
    v_deptno   IN dept.deptno%TYPE
) IS

    CURSOR dept_avg IS SELECT
        b.dname,
        COUNT(a.empno) cnt,
        round(AVG(a.sal),3) salary
                       FROM
        emp a,
        dept b
                       WHERE
        a.deptno = b.deptno
        AND   b.deptno = v_deptno
                       GROUP BY
        b.dname;

       -- variables for variables from FETCH

    v_dname   dept.dname%TYPE;
    emp_cnt   NUMBER;
    sal_avg   NUMBER;
BEGIN
    OPEN dept_avg;
    FETCH dept_avg INTO v_dname,emp_cnt,sal_avg;
    dbms_output.put_line('dept name : '
    || v_dname);
    dbms_output.put_line('employee count : '
    || emp_cnt);
    dbms_output.put_line('average salary : '
    || sal_avg);
    CLOSE dept_avg;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm
        || 'Error occured ');
END;
/
   
-- execute procedure   

EXECUTE expcursor_test(30);    

-- B - 1. Explicit Cursor with for loop
-- OPEN, FETCH and CLOSE is automatically maintained. Therefore they do not have to be defined.

CREATE OR REPLACE PROCEDURE forcursor_test IS

    CURSOR dept_sum IS SELECT
        b.dname,
        COUNT(a.empno) cnt,
        SUM(a.sal) salary
                       FROM
        emp a,
        dept b
                       WHERE
        a.deptno = b.deptno
                       GROUP BY
        b.dname;

BEGIN

    -- cursor with for loop: OPEN, FETCH, CLOSE does not need to be with FOR LOOP
    FOR emp_list IN dept_sum LOOP
        dbms_output.put_line('dept name : '
        || emp_list.dname);
        dbms_output.put_line('employee count : '
        || emp_list.cnt);
        dbms_output.put_line('average salary : '
        || emp_list.salary);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm
        || 'Error occured ');
END;
/

EXECUTE forcursor_test;

-- Explicit Cursor Attribute
-- %ISOPEN
-- %NOTFOUND: if there is no fetched data, then true. By this value, know when to exit loop
-- %FOUND: if there is fetched data.
-- %ROWCOUNT: a number of records returned at the point

CREATE OR REPLACE PROCEDURE attrcursor_test IS

    v_empno   emp.empno%TYPE;
    v_ename   emp.ename%TYPE;
    v_sal     emp.sal%TYPE;
    CURSOR emp_list IS SELECT
        empno,
        ename,
        sal
                       FROM
        emp;

BEGIN
    OPEN emp_list;
    LOOP -- This is not for loop. Therefore OPEN, FETCH, CLOSE should be defined
        FETCH emp_list INTO v_empno,v_ename,v_sal;
        EXIT WHEN emp_list%notfound;
    END LOOP;

    dbms_output.put_line('Total Count: '
    || emp_list%rowcount);
    CLOSE emp_list;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERR MESSAGE : '
        || sqlerrm);
END;
/

EXECUTE attrcursor_test;

-- Explicit Cursor with parameter

CREATE OR REPLACE PROCEDURE paramcursor_test (
    param_deptno emp.deptno%TYPE
) IS
    v_ename   emp.ename%TYPE;
    -- cursor with parameter
    CURSOR emp_list (
        v_deptno emp.deptno%TYPE
    ) IS SELECT
        ename
         FROM
        emp
         WHERE
        deptno = v_deptno;
BEGIN

    -- passing parameter to cursor
    FOR emplst IN emp_list(param_deptno) 
    LOOP
        dbms_output.put_line('Name : ' || emplst.ename);
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERR MESSAGE : ' || sqlerrm);
END;
/
EXECUTE ParamCursor_Test(10);
