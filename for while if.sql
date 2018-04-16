
select * from emp
/* --------------- for loop ------------------------ */
SET SERVEROUTPUT ON;

DECLARE
    TYPE ename_table IS
        TABLE OF emp.ename%TYPE INDEX BY BINARY_INTEGER;
    TYPE sal_table IS
        TABLE OF emp.sal%TYPE INDEX BY BINARY_INTEGER;
    ename_tab   ename_table;
    sal_tab     sal_table;
    i           BINARY_INTEGER := 0;
BEGIN
    dbms_output.enable;
    FOR emp_list IN (
        SELECT
            ename,
            sal
        FROM
            emp
        WHERE
            deptno = 10
    ) LOOP
        i := i + 1;
        ename_tab(i) := emp_list.ename;
        sal_tab(i) := emp_list.sal;
    END LOOP;

    FOR cnt IN 1..i LOOP
        dbms_output.put_line('name : '
        || ename_tab(cnt) );
        dbms_output.put_line('salary : '
        || sal_tab(cnt) );
    END LOOP;

END;
/ 



/* --------------- loop ------------------------ */

SET SERVEROUTPUT ON;

DECLARE
    v_cnt   NUMBER := 100;
BEGIN
    dbms_output.enable;
    LOOP
        INSERT INTO emp (
            empno,
            ename,
            hiredate
        ) VALUES (
            v_cnt,
            'test'
            || TO_CHAR(v_cnt),
            SYSDATE
        );

        v_cnt := v_cnt + 1;
        EXIT WHEN v_cnt > 110;
    END LOOP;

    dbms_output.put_line('successful');
    dbms_output.put_line(v_cnt - 100
    || ' rows are inserted');
END;
/

/* --------------- while loop ------------------------ */
-- NOTE: sequence should be created at first

CREATE SEQUENCE emp_seq START WITH 1000 INCREMENT BY 1;

SET SERVEROUTPUT ON;

DECLARE
    v_cnt   NUMBER := 100;
BEGIN
    dbms_output.enable;
    WHILE v_cnt < 110 LOOP
        INSERT INTO emp (
            empno,
            ename,
            hiredate
        ) VALUES (
            emp_seq.NEXTVAL,
            'test',
            SYSDATE
        );

        v_cnt := v_cnt + 1;
        EXIT WHEN v_cnt > 110;
    END LOOP;

    dbms_output.put_line('successful');
    dbms_output.put_line(v_cnt - 100
    || ' rows are inserted');
END;


/* --------------- if ------------------------ */
CREATE OR REPLACE PROCEDURE dept_search (
    p_empno   IN emp.empno%TYPE
) IS
    v_deptno   emp.deptno%TYPE;
BEGIN
    dbms_output.enable;
    SELECT
        deptno
    INTO
        v_deptno
    FROM
        emp
    WHERE
        empno = p_empno;

    IF
        v_deptno = 10
    THEN
        dbms_output.put_line(' He is employee of account dept. ');
    ELSIF v_deptno = 20 THEN
        dbms_output.put_line(' He is employee of research dept. ');
    ELSIF v_deptno = 20 THEN
        dbms_output.put_line(' He is employee of sales dept. ');
    ELSIF v_deptno = 20 THEN
        dbms_output.put_line(' He is employee of operation dept. ');
    ELSE
        dbms_output.put_line(' No department has been found ');
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line(' exception ');
END;
/

SET SERVEROUTPUT ON;
EXECUTE dept_search(7369);