-- Analysis Function
SELECT deptno
     , SUM(sal) s_sal
  FROM emp
 GROUP BY deptno;
 
 
