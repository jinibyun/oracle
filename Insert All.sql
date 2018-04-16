-- INSERT ALL: insert into "Multiple" table
-- 1. Unconditional INSERT ALL

CREATE TABLE emp_ename 
    AS
SELECT empno, ename, sal 
  FROM emp 
 WHERE 1=2;
 

CREATE TABLE emp_deptno 
    AS
SELECT empno, deptno, job 
  FROM emp 
 WHERE 1=2;
 
 
-- confirm
SELECT * FROM emp_ename;
SELECT * FROM emp_deptno;
 

INSERT ALL
  INTO emp_ename VALUES (empno, ename, sal)
  INTO emp_deptno (empno, deptno, job) 
  VALUES (empno, deptno, job)
SELECT empno, ename, sal, deptno, job
  FROM emp
 WHERE sal >= 2900;
 
-- confirm
SELECT * FROM emp_ename;
SELECT * FROM emp_deptno;
 
-- drop tables
DROP TABLE emp_ename;
DROP TABLE emp_deptno;




-- 2. Conditional INSERT ALL
CREATE TABLE emp_dept10 AS SELECT empno, ename, job, sal FROM emp WHERE 1=2;
CREATE TABLE emp_dept20 AS SELECT empno, ename, job, sal FROM emp WHERE 1=2;
CREATE TABLE emp_dept30 AS SELECT empno, ename, job, sal FROM emp WHERE 1=2;

-- confirm
SELECT * FROM emp_dept10;
SELECT * FROM emp_dept20;
SELECT * FROM emp_dept30;

INSERT ALL
 WHEN deptno=10 THEN
      INTO emp_dept10 
      VALUES(empno, ename, job, ROUND(sal*1.1))
 WHEN deptno=20 THEN
      INTO emp_dept20 
      VALUES(empno, ename, job, ROUND(sal*1.2))
 WHEN deptno=30 THEN
      INTO emp_dept30 
      VALUES(empno, ename, job, ROUND(sal*1.3))
SELECT deptno, empno, ename, job, sal
  FROM emp;
  
-- confirm
SELECT d.sal "salary raise", e.sal "original salary"
  FROM emp_dept10 d, emp e 
 WHERE d.empno = e.empno;
 
-- drop
DROP TABLE emp_dept10;
DROP TABLE emp_dept20;
DROP TABLE emp_dept30;
