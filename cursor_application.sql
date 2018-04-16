SELECT * from AttributeHistory;
SELECT * from ATTRIBUTES;


SELECT * FROM AttributeHistory t1
INNER JOIN ATTRIBUTES t2
ON t1.ATTRIBUTESETID = t2.ATTRIBUTESETID

-- Attribute History
INSERT INTO  AttributeHistory
SELECT 4, TO_DATE('2005-01-01','YYYY-MM-DD'), TO_DATE('3333-12-31','YYYY-MM-DD') FROM DUAL;
COMMIT;

-- Attribute
INSERT INTO ATTRIBUTES
SELECT 4, 'SOMENAME5', 'SOMEVALUE5' FROM DUAL;
COMMIT;

-- Confirm
SELECT  t2.ATTRIBUTENAME, min(STARTDATE) as STARTDATE, max(ENDDATE) as ENDDATE
FROM AttributeHistory t1
INNER JOIN Attributes t2
ON t1.AttributeSetId = t2.ATTRIBUTESETID
GROUP BY t2.ATTRIBUTENAME

declare 
    xxx varchar(20) := 'dsfdsf';
    v_attr_value varchar(100);

begin
    SELECT AttributeValue INTO v_attr_value FROM Attributes WHERE AttributeName = 'Manager Type' AND rownum = 1;
     dbms_output.put_line(v_attr_value);
end;
--------------------------------------------------
-- table crate statement
CREATE TABLE tmp_history
(
    STARTDATE date,
    ENDDATE date
)

DROP TABLE tmp_history;

SELECT * FROM tmp_history;
-----------------ACTUAL ADJUSTMENT WITH CURSOR --------------
DECLARE
    -- static cursor
    CURSOR cur_attribute_date IS 
        SELECT  t2.ATTRIBUTENAME, min(STARTDATE) as STARTDATE, max(ENDDATE) as ENDDATE
        FROM AttributeHistory t1
        INNER JOIN Attributes t2
        ON t1.AttributeSetId = t2.ATTRIBUTESETID
        GROUP BY t2.ATTRIBUTENAME;
    -- dynamice cursor
    cur_dynamic_attribute SYS_REFCURSOR;
    v_attr_value varchar(100);
    var_startDate date;
    var_endDate date;
    --var_previouseEndDate date := null;
    v_SQL varchar(1000);
    
BEGIN
    FOR cur_attribute_date_member IN cur_attribute_date 
    LOOP    
        if cur_attribute_date_member.STARTDATE > TO_DATE('1900-01-01','YYYY-MM-DD')  then
            -- history
            INSERT INTO tmp_history VALUES(TO_DATE('1900-01-01','YYYY-MM-DD'), cur_attribute_date_member.STARTDATE);
            
            -- attribute value for first existing attribute
            SELECT t2.AttributeValue into v_attr_value
            FROM AttributeHistory t1 INNER JOIN Attributes t2
            ON t1.AttributeSetId = t2.ATTRIBUTESETID
            WHERE t2.AttributeName = cur_attribute_date_member.ATTRIBUTENAME AND rownum = 1
            ORDER BY t1.STARTDATE ASC;
            
            -- Name and Value: cur_attribute_date_member.ATTRIBUTENAME , v_attr_value
            
        end if;
        If cur_attribute_date_member.ENDDATE < TO_DATE('3333-12-31','YYYY-MM-DD')  then
            -- history
            INSERT INTO tmp_history VALUES(cur_attribute_date_member.ENDDATE, TO_DATE('3333-12-31','YYYY-MM-DD'));
            
            -- attribute value for last existing attribute
            SELECT t2.AttributeValue into v_attr_value
            FROM AttributeHistory t1 INNER JOIN Attributes t2
            ON t1.AttributeSetId = t2.ATTRIBUTESETID
            WHERE t2.AttributeName = cur_attribute_date_member.ATTRIBUTENAME AND rownum = 1
            ORDER BY t1.STARTDATE DESC;
            
            -- Name and Value: cur_attribute_date_member.ATTRIBUTENAME , v_attr_value
            
        end if;
            
        -- dynamic cursor start    
        OPEN cur_dynamic_attribute 
        FOR ' SELECT  t1.STARTDATE, t1.ENDDATE ' ||
            ' FROM AttributeHistory t1 ' ||
            ' INNER JOIN Attributes t2 ' ||
            ' ON t1.AttributeSetId = t2.ATTRIBUTESETID WHERE t2.AttributeName = ''' || 
            cur_attribute_date_member.ATTRIBUTENAME || ''' ';
        LOOP
             FETCH cur_dynamic_attribute INTO var_startDate, var_endDate;
             EXIT WHEN cur_dynamic_attribute%NOTFOUND;
                dbms_output.put_line(cur_attribute_date_member.ATTRIBUTENAME || '--->>' || var_startDate || ':' || var_endDate);
                             
        END LOOP;
        CLOSE cur_dynamic_attribute;
        -- dynamic cursor end
        
    COMMIT;
    END LOOP;
    
END;
/

