-- IN operator

-- ANY operator
SELECT ENAME, SAL
  FROM EMP
 WHERE DEPTNO != 20
   AND SAL > ANY (SELECT SAL FROM EMP WHERE JOB = 'SALESMAN');

-- ALL operator

SELECT ENAME, SAL
  FROM EMP
 WHERE DEPTNO != 20
   AND SAL > ALL (SELECT SAL FROM EMP WHERE JOB = 'SALESMAN');

-- EXIST operator
SELECT DISTINCT D.DEPTNO, D.DNAME
  FROM DEPT D, EMP E
 WHERE D.DEPTNO = E.DEPTNO;

-- same, but much better performance
-- cannot be executed independantly.
SELECT D.DEPTNO, D.DNAME
  FROM DEPT D
 WHERE EXISTS -- true or false 
 (SELECT 1 FROM EMP E WHERE E.DEPTNO = D.DEPTNO);

-- multi column subquery
SELECT EMPNO, SAL, DEPTNO
  FROM EMP
 WHERE (SAL, DEPTNO) IN (SELECT SAL, DEPTNO
                           FROM EMP
                          WHERE DEPTNO = 30
                            AND COMM IS NOT NULL);
-- same as above
SELECT EMPNO, SAL, DEPTNO
  FROM EMP
 WHERE SAL IN (SELECT SAL
                 FROM EMP
                WHERE DEPTNO = 30
                  AND COMM IS NOT NULL)
AND DEPTNO IN (
    SELECT DEPTNO
      FROM EMP
     WHERE DEPTNO = 30
       AND COMM IS NOT NULL);
       
/* FROM sub-query */
SELECT B.EMPNO, B.ENAME, B.JOB, B.SAL, B.DEPTNO
  FROM (SELECT EMPNO
          FROM EMP
         WHERE SAL > (SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 20)) A,
       EMP B
 WHERE A.EMPNO = B.EMPNO
   AND B.MGR IS NOT NULL
   AND B.DEPTNO != 20;
   
-- scalar sub query
-- same as join
SELECT ename,
       (SELECT dname FROM dept d WHERE d.deptno = e.deptno) deptno
FROM emp e
WHERE job ='MANAGER';
