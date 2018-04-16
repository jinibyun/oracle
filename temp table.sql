DECLARE                          
     v_exit_cnt         NUMBER(1);                                          
     V_TBL_NAME         VARCHAR2(150);          
     V_SQL              VARCHAR2(1024);  

    CURSOR C1_CUR IS                                
        SELECT TABLE_NAME
        FROM USER_TABLES
        WHERE TABLE_NAME='TMP_PRO'; -- temp table
                 
BEGIN

    OPEN C1_CUR;
    FETCH C1_CUR INTO V_TBL_NAME;
    
    --if there is temp table named 'TMP_PRO', delete it
    IF C1_CUR%FOUND THEN
        V_SQL := 'DROP TABLE TMP_PRO';
        EXECUTE IMMEDIATE V_SQL;
    END IF;
   
    --create temp table
    V_SQL := 'CREATE  GLOBAL TEMPORARY TABLE TMP_PRO ('
        || '    COL1    CHAR(10), COL2    VARCHAR2(20), COL3    NUMBER(10)'
        || '  ) ON  COMMIT  DELETE ROWS';
    EXECUTE IMMEDIATE V_SQL;
    
    -- insert into temp table
    V_SQL :=  'INSERT INTO TMP_PRO'
            ||'     SELECT 1,2,3 FROM DUAL '
            ||'     UNION ALL '
            ||'     SELECT 4,5,6 FROM DUAL ';
    EXECUTE IMMEDIATE V_SQL;
    
    V_SQL := ' SELECT * FROM TMP_PRO ';
    EXECUTE IMMEDIATE V_SQL;
    
    CLOSE C1_CUR;
   
    
--COMMIT;   

    V_SQL := 'DROP TABLE TMP_PRO';
    EXECUTE IMMEDIATE V_SQL;


--EXCEPTION                                                                               
--    WHEN     OTHERS THEN                                                           
--            dbms_output.put_line(SQLERRM);                    
--            ROLLBACK;                                                           
END;
/

