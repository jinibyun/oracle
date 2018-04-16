-- numeric function
SELECT ABS(-1.234) FROM DUAL;

SELECT CEIL(10.1234) FROM DUAL;
SELECT CEIL(-10.1234) FROM DUAL;

SELECT FLOOR(10.1234) "FLOOR" FROM DUAL; -- opposite of CEIL()
SELECT FLOOR(-10.1234) "FLOOR" FROM DUAL;

SELECT MOD(9, 4) "MOD" FROM DUAL ;

SELECT ROUND(192.153, 1) "ROUND" FROM DUAL;
SELECT ROUND(192.153, -1) "ROUND" FROM DUAL;

SELECT TRUNC(7.5597, 2) "TRUNC" FROM DUAL;
SELECT TRUNC(789.5597, -2) "TRUNC" FROM DUAL;
SELECT TRUNC(SYSDATE) FROM DUAL;

-- string function
SELECT CONCAT('www.', 'oracleclub')||'.com' name FROM DUAL;

SELECT INITCAP('oracleclub') name FROM DUAL
 UNION ALL
SELECT UPPER('oracleclub') name FROM DUAL
 UNION ALL
SELECT LOWER('oracleclub') name FROM DUAL;

SELECT LPAD('oracleclub', 12, '*') name FROM DUAL
 UNION ALL
SELECT RPAD('oracleclub', 12, '*') name FROM DUAL;

SELECT SUBSTR('oracleclub', 3) name FROM DUAL;
SELECT SUBSTR('oracleclub', 3, 4) name FROM DUAL;

SELECT SUBSTR('oracleclub', -3, 2) name FROM DUAL;

SELECT LENGTH('oracleclub') len FROM DUAL
 UNION ALL
SELECT LENGTHB('oracleclub') len FROM DUAL;

SELECT REPLACE('oracleclub','oracle','db') name FROM DUAL;

SELECT REPLACE('OracleClub','oracle','DB') name  FROM DUAL
 UNION ALL
SELECT REPLACE('OracleClub','Oracle','DB') name  FROM DUAL;

SELECT INSTR('CORPORATE FLOOR','OK') idx FROM DUAL;
SELECT INSTR('CORPORATE FLOOR','OR') idx FROM DUAL;
SELECT INSTR('CORPORATE FLOOR','OR', 3) idx FROM DUAL;

SELECT TRIM('o' FROM 'oracleclub') name FROM DUAL
UNION ALL
SELECT TRIM(' oracleclub ') name FROM DUAL;

SELECT LTRIM('oracleclub','oracle') name FROM DUAL
UNION ALL
SELECT REPLACE(LTRIM(' oracleclub '),' ','*') name FROM DUAL;

SELECT RTRIM('oracleclub','club') name FROM DUAL
UNION ALL
SELECT REPLACE(RTRIM(' oracleclub '),' ','*') name FROM DUAL;

-- date function
-- SYSDTE
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') "NOW" FROM DUAL ;
 
SELECT TO_CHAR(SYSDATE-1,'RRRR-MM-DD HH24:MI:SS') "YESTERDAY" FROM DUAL ;
 
SELECT TO_CHAR(SYSDATE-1/24,'RRRR-MM-DD HH24:MI:SS') "Hour Before" FROM DUAL ;
 
SELECT TO_CHAR(SYSDATE-1/24/60,'RRRR-MM-DD HH24:MI:SS') "1 minute before" FROM DUAL ;

SELECT TO_CHAR(SYSTIMESTAMP,'RRRR-MM-DD HH24:MI:SS.FF3')  FROM DUAL ;
 
SELECT TO_CHAR(SYSTIMESTAMP,'RRRR-MM-DD HH24:MI:SS.FF9')  FROM DUAL ;

SELECT TO_CHAR(ADD_MONTHS(SYSDATE,3),'RRRR-MM-DD')  "date" FROM DUAL; 
SELECT TO_CHAR(ADD_MONTHS(SYSTIMESTAMP,3),'RRRR-MM-DD')  "date" FROM DUAL;

SELECT MONTHS_BETWEEN(TO_DATE('2010-06-05','RRRR-MM-DD'), TO_DATE('2010-05-01','RRRR-MM-DD'))  "month"  FROM DUAL;
                      
SELECT TO_DATE('2010-06-05','RRRR-MM-DD') - TO_DATE('2010-05-01','RRRR-MM-DD')  "Day"  FROM DUAL;

SELECT SYSDATE today, LAST_DAY(SYSDATE) lastday FROM DUAL;
SELECT NEXT_DAY(SYSDATE, 4) "Next Wednesday" FROM DUAL;

-- CONVERSION FUNCTION
SELECT TO_CHAR(12345678,'999,999,999') comma FROM DUAL;
SELECT TO_CHAR(123.45678,'999,999,999.99') period FROM DUAL; 
SELECT TO_CHAR(12345678,'$999,999,999') dollar  FROM DUAL;
SELECT TO_CHAR(12345678,'L999,999,999') local  FROM DUAL; -- L: local currency
SELECT TO_CHAR(123,'09999') zero FROM DUAL;
SELECT TO_CHAR(123,'XXXX') hexadecimal  FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') "sysdate" FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'DDD') "Day of year" FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'IW') "Week of year" FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MONTH') "Name of month" FROM DUAL;

SELECT TO_DATE('2011-01-01','RRRR-MM-DD') FROM DUAL;
SELECT TO_DATE('2011-01-01','YYYY-MM-DD') FROM DUAL;
SELECT TO_DATE('2011-01-01','YYYY-MM-DD') FROM DUAL;

SELECT TO_NUMBER('01210616') FROM DUAL; 

-- DECODE
SELECT deptno, DECODE(deptno, 10 , 'ACCOUNTING' ,
                              20 , 'RESEARCH' ,
                              30 , 'SALES', 'OPERATIONS') name
  FROM dept;
 --
 SELECT deptno, DECODE(deptno, 10 , SUM(sal),
                              20 , MAX(sal),
                              30 , MIN(sal)) sal
  FROM emp
 GROUP BY deptno; 
 --
 SELECT deptno, NVL(SUM(DECODE(deptno, 10, sal)),0) deptno10, 
               NVL(SUM(DECODE(deptno, 20, sal)),0) deptno20,
               NVL(SUM(DECODE(deptno, 30, sal)),0) deptno30,
               NVL(SUM(DECODE(deptno, 40, sal)),0) deptno40
  FROM emp
 GROUP BY deptno; 
 --
 SELECT d.deptno, NVL(SUM(e.sal),0) sal
  FROM emp e, dept d
 WHERE e.deptno(+) = d.deptno
 GROUP BY d.deptno; 
--
SELECT MAX(NVL(SUM(DECODE(deptno, 10, sal)),0)) deptno10, 
       MAX(NVL(SUM(DECODE(deptno, 20, sal)),0)) deptno20,
       MAX(NVL(SUM(DECODE(deptno, 30, sal)),0)) deptno30,
       MAX(NVL(SUM(DECODE(deptno, 40, sal)),0)) deptno40
  FROM emp
 GROUP BY deptno; 
 --
 -- above functions changed with case when then syntax
 SELECT deptno, 
       CASE deptno
         WHEN 10 THEN 'ACCOUNTING'
         WHEN 20 THEN 'RESEARCH'
         WHEN 30 THEN 'SALES'
         ELSE 'OPERATIONS'
       END as "Dept Name"
  FROM dept;
 
--
SELECT ename ,
       CASE
          WHEN sal < 1000  THEN sal+(sal*0.8)
          WHEN sal BETWEEN 1000 AND 2000 THEN sal+(sal*0.5)
          WHEN sal BETWEEN 2001 AND 3000 THEN sal+(sal*0.3)
          ELSE sal+(sal*0.1)
       END sal
  FROM emp; 
 
 
 -- NVL
 SELECT empno, NVL(mgr, 0) mgr -- mssql ISNULL
  FROM emp  
 WHERE deptno = 10;
 
 -- NVL2: NVL + DECODE
 SELECT empno, NVL2(mgr, 1, 0) mgr
 FROM emp  
 WHERE deptno = 10;
 
 -- NULLIF : CASE WHEN expr1 = expr2 THEN NULL ELSE expr1 END
 -- COALESCE: similar to NVL
 SELECT COALESCE(comm,1), comm FROM emp;
 
 
 
 