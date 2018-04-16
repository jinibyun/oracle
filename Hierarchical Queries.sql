/* Hierarchical SQL query */
SELECT * FROM emp;

-- TOP DOWN 
SELECT LEVEL, empno, ename, mgr
  FROM emp
 START WITH job = 'PRESIDENT' -- parent column (or sub query)
CONNECT BY PRIOR  empno = mgr; -- making relatinship between child and parent

-- BOTTOM UP
SELECT LEVEL, LPAD(' ', 4*(LEVEL-1)) || ename ename, empno, mgr, job 
  FROM emp
 START WITH ename='SMITH' 
CONNECT BY PRIOR mgr = empno;

-- NOTE
-- CONNECT BY PRIOR CHILD COLUMN = PARENT COLUMN : FROM PARENT TO CHILD (Top Down)
-- CONNECT BY PRIOR PARENT COLUMN = CHILD COLUMN : FROM CHILD TO PARENT (Bottom Up)

SELECT LEVEL, LPAD(' ', 4*(LEVEL-1)) || ename ename, empno, mgr, job 
  FROM emp
 START WITH job='PRESIDENT'
CONNECT BY PRIOR empno=mgr; 

-- use with group by
SELECT LEVEL, AVG(sal) total, COUNT(empno) cnt
  FROM emp
 START WITH job='PRESIDENT'
CONNECT BY PRIOR empno=mgr      
 GROUP BY LEVEL
 ORDER BY LEVEL;
 
-- PRIOR in select clause
SELECT LEVEL, LPAD(' ', 4*(LEVEL-1)) || ename ename, 
       PRIOR ename mgrname, -- It indicates "PARENT COLUMN". PRIOR can also be used in SELECT clause
       empno, mgr, job 
  FROM emp
 START WITH job='PRESIDENT'
CONNECT BY PRIOR empno=mgr; 
 

-- CONNECT_BY_ROOT
SELECT LPAD(' ', 4 * (LEVEL-1)) || ename ename, empno,
CONNECT_BY_ROOT  empno "Root empno", -- TOP LEVEL ROW
level
  FROM emp
 START WITH job='PRESIDENT'
CONNECT BY PRIOR empno=mgr;
 
-- CONNECT_BY_ISLEAF
SELECT LPAD(' ', 4*(LEVEL-1)) || ename ename, empno,
       CONNECT_BY_ISLEAF "leaf", -- lowese level: 1 , otherwise 0
level
  FROM emp
 START WITH job='PRESIDENT'
CONNECT BY NOCYCLE PRIOR empno=mgr;

-- SYS_CONNECT_BY_PATH
SELECT LPAD(' ', 4*(LEVEL-1)) || ename ename, empno,
       SYS_CONNECT_BY_PATH(ename, '/') "PATH"
  FROM emp
 START WITH job='PRESIDENT'
CONNECT BY PRIOR empno=mgr;

SELECT LEVEL, SUBSTR(SYS_CONNECT_BY_PATH(ename, ','), 2) path
  FROM emp
 WHERE CONNECT_BY_ISLEAF = 1
 START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

-- ORDER SIBLINGS BY
SELECT LPAD(' ', 4*(LEVEL-1)) || ename ename, 
       ename ename2, empno, level
  FROM emp
 START WITH job='PRESIDENT'
CONNECT BY NOCYCLE PRIOR empno=mgr
 ORDER SIBLINGS BY ename2;
 
 -- compare above
 SELECT LPAD(' ', 4*(LEVEL-1)) || ename ename, 
       ename ename2, empno, level
  FROM emp
 START WITH job='PRESIDENT'
CONNECT BY NOCYCLE PRIOR empno=mgr
 ORDER BY ename2;
 
 -- Apply with above
 -- 1
 SELECT empno
     , LEVEL lv
     , LPAD(' ', (LEVEL-1)*2, ' ') || ename AS ename
     , sal
     , (SELECT SUM(sal)
          FROM emp
         START WITH empno = a.empno
         CONNECT BY PRIOR empno = mgr
        ) sum_sal
  FROM emp a
 START WITH mgr IS NULL
 CONNECT BY PRIOR empno = mgr
; 

-- 2: create sample data
SELECT LEVEL FROM DUAL CONNECT BY LEVEL <= 10;
-- create
CREATE TABLE emp_sample AS
SELECT 
       LEVEL empno,       
       -- 2. JOB: 100,000 data (10 groups of jobs)
       'SALESMAN_'||CHR(65 + MOD(LEVEL , 10)) job,
       -- 3. HIREDATE(금일+9일까지) 
       SYSDATE +  MOD(LEVEL , 10) hiredate,
       -- 4. DEPTNO (0, 10, 20, 30, 40)
       MOD(LEVEL ,5)*10 deptno
FROM   DUAL
CONNECT BY LEVEL <= 100000;
 
-- confirmation
SELECT * FROM emp_sample WHERE ROWNUM < 10;
SELECT COUNT(*) FROM emp_sample;

--3.
WITH test AS
(
SELECT 'A' code FROM dual
UNION ALL SELECT 'B' FROM dual
UNION ALL SELECT 'C' FROM dual
)
SELECT SUBSTR(SYS_CONNECT_BY_PATH(code, '-'), 2) code
  FROM test
 CONNECT BY PRIOR code < code
 ORDER BY LEVEL, code
;


WITH test AS
(
SELECT 'A' code FROM dual
UNION ALL SELECT 'B' FROM dual
UNION ALL SELECT 'C' FROM dual
)
SELECT SUBSTR(SYS_CONNECT_BY_PATH(code, '-'), 2) code
  FROM test
 CONNECT BY NOCYCLE PRIOR code != code
 ORDER BY LEVEL, code
;
 
 
