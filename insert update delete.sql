/* ------------------- INSERT ----------------- */
CREATE OR REPLACE PROCEDURE insert_test (
    v_empno    IN emp.empno%TYPE,
    v_ename    IN emp.ename%TYPE,
    v_deptno   IN emp.deptno%TYPE
)
    IS
BEGIN
    dbms_output.enable;
    INSERT INTO emp (
        empno,
        ename,
        hiredate,
        deptno
    ) VALUES (
        v_empno,
        v_ename,
        SYSDATE,
        v_deptno
    );

    COMMIT;
    dbms_output.put_line('emp no : '
    || v_empno);
    dbms_output.put_line('emp name : '
    || v_ename);
    dbms_output.put_line('dept no : '
    || v_deptno);
    dbms_output.put_line('successful ');
END;
/

SET SERVEROUTPUT ON;

EXECUTE insert_test(1000,'brave',20);
/* ------------------- UPDATE ----------------- */

CREATE OR REPLACE PROCEDURE update_test (
    v_empno   IN emp.empno%TYPE,
    v_rate    IN NUMBER
) IS
    v_emp   emp%rowtype;
BEGIN
    dbms_output.enable;
    UPDATE emp
        SET
            sal = sal + ( sal * ( v_rate / 100 ) )
    WHERE
        empno = v_empno;

    COMMIT;
    dbms_output.put_line('successful ');

        -- confirm
    SELECT
        empno,
        ename,
        sal
    INTO
        v_emp.empno,v_emp.ename,v_emp.sal
    FROM
        emp
    WHERE
        empno = v_empno;

    dbms_output.put_line(' **** confirmation **** ');
    dbms_output.put_line('no : '
    || v_emp.empno);
    dbms_output.put_line('name : '
    || v_emp.ename);
    dbms_output.put_line('salary : '
    || v_emp.sal);
END;
/

SET SERVEROUTPUT ON;

EXECUTE update_test(7900,-10);

/* ------------------- DELETE ----------------- */

CREATE OR REPLACE PROCEDURE delete_test (
    p_empno   IN emp.empno%TYPE
) IS

    TYPE del_record IS RECORD ( v_empno      emp.empno%TYPE,
    v_ename      emp.ename%TYPE,
    v_hiredate   emp.hiredate%TYPE );
    v_emp        del_record;
BEGIN
    dbms_output.enable;

         -- ??? ??? ??? ?? 
    SELECT
        empno,
        ename,
        hiredate
    INTO
        v_emp.v_empno,v_emp.v_ename,v_emp.v_hiredate
    FROM
        emp
    WHERE
        empno = p_empno;

    dbms_output.put_line('no : ' || v_emp.v_empno);
    dbms_output.put_line('name : ' || v_emp.v_ename);
    dbms_output.put_line('hire date : ' || v_emp.v_hiredate);

    DELETE FROM emp WHERE empno = p_empno;

    COMMIT;
    dbms_output.put_line('successful ');
END;
/ 

SET SERVEROUTPUT ON ;  
execute delete_test(7900);
