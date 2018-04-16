select * from emp;

/* ---------------- create stored proc -------------- */
create or replace PROCEDURE update_sal 
 /* IN  Parameter */
 (v_empno    IN    NUMBER) 
 IS 

 BEGIN 

   UPDATE EMP 
   SET sal = sal  * 1.1 
   WHERE empno = v_empno; 

   COMMIT; 

 END update_sal;

/* ---------------- exec stored proc -------------- */
EXECUTE update_sal(7369);

/* ---------------- create function -------------- */
create or replace FUNCTION FC_update_sal
     (v_empno         IN    NUMBER)
      -- must return datatype
      RETURN  NUMBER
    IS
    
    -- %type ??? ??(??? ??? ?? ??)
    v_sal  emp.sal%type;
    BEGIN
        UPDATE emp
        SET sal  = sal  * 1.1
        WHERE empno  = v_empno;

        COMMIT;

        SELECT sal
        INTO v_sal
        FROM emp
        WHERE empno = v_empno;

        -- must
        RETURN v_sal;
   END; 
/* ---------------- exec function -------------- */
var salary NUMBER; 
EXECUTE :salary := FC_update_sal(7900); 
print salary

