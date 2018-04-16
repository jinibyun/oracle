declare 
    v_prev_date Date;
    v_Attribute_Set_Id NUMBER := 0;
begin
    
        FOR att IN 
        (
            SELECT attr.attribute_cd, min(attr.eff_dtm) as min_eff_dtm, max(exp_dtm) max_exp_dtm, count(*) as cnt FROM
                (
                    select distinct * 
                    from portfolio_attributes t1 inner join portfolio_attribute_history t2
                    on t1.attribute_set_id = t2.atrribute_set_id 
                    where t1.attribute_cd NOT IN
                    (
                        WITH 
                            AH AS(
                                select t1.attribute_cd , min(t2.eff_dtm) as eff_dtm, max(t2.exp_dtm) as  exp_dtm
                                from portfolio_attributes t1 inner join portfolio_attribute_history t2
                                on t1.attribute_set_id = t2.atrribute_set_id
                                group by t1.attribute_cd),
                            P AS(
                                select eff_dtm, exp_dtm from portfolio
                            ),
                            Z AS (
                                select AH.attribute_cd
                                from AH inner join P
                                on AH.eff_dtm = P.eff_dtm and AH.exp_dtm = P.exp_dtm
                            )
                            SELECT * FROM Z
                    )
                    order by t1.attribute_cd, t2.eff_dtm 
                ) attr
                group by attr.attribute_cd
        ) LOOP
                                       
              -- 1. compare portfolio start date and each start date
              If portfolioStartDate < att.min_eff_dtm then
                  -- insert multiple
                  For attrsetId IN (select t2.atrribute_set_id, t1.value
                                      from portfolio_attributes t1 inner join portfolio_attribute_history t2
                                      on t1.atrribute_set_id = t2.atrribute_set_id 
                                      where t1.attribute_cd = att.attribute_cd
                                      and t2.eff_dtm < att.min_eff_dtm)
                  Loop
                                  
                        INSERT INTO portfolio_attributes(Atrribute_Set_Id, Attribute_Cd, Value)
                        VALUES(attrsetId.Atrribute_Set_Id, att.attribute_cd, attrsetId.Value);
                                        
                        COMMIT;
                  End Loop;
              end if;
                      
              -- 2. compare portfolio end date and each end date
              If portfolioEndDate > att.min_exp_dtm then
                  -- insert multiple
                  For attrsetId IN (select t2.atrribute_set_id, t1.value
                                      from portfolio_attributes t1 inner join portfolio_attribute_history t2
                                      on t1.atrribute_set_id = t2.atrribute_set_id 
                                      where t1.attribute_cd = att.attribute_cd
                                      and t2.exp_dtm > att.max_exp_dtm)
                  Loop
                                  
                        INSERT INTO portfolio_attributes(Atrribute_Set_Id, Attribute_Cd, Value)
                        VALUES(attrsetId.Atrribute_Set_Id, att.attribute_cd, attrsetId.Value);
                                        
                        COMMIT;
                  End Loop;
                  
              end if;
              
              --3. Between date
              IF att.Cnt > 1 then
                  FOR  eachAtt IN (select distinct  *
                                  from portfolio_attributes t1 inner join portfolio_attribute_history t2
                                  on t1.atrribute_set_id = t2.atrribute_set_id 
                                  where t1.attribute_cd = att.attribute_cd order by t2.eff_dtm
                              )
                  LOOP
                            if v_prev_date is null then
                               v_prev_date := eachAtt.exp_dtm;
                               CONTINUE;
                            end if;  
                            
                            SELECT t2.Attribute_Set_Id 
                            INTO v_Attribute_Set_Id
                            FROM portfolio_attributes t1 INNER JOIN portfolio_attribute_history t2 
                            ON t1.atrribute_set_id = t2.atrribute_set_id
                            WHERE t1.attribute_cd = eachAtt.attribute_cd 
                            AND t1.eff_dtm = v_prev_date AND t1.exp_dtm = eachAtt.eff_DTM;
                            
                            if v_Attribute_Set_Id = 0 then
                                -- INSERT single                                
                                SELECT t2.Attribute_Set_Id
                                INTO v_Attribute_Set_Id
                                FROM portfolio_attributes t1 INNER JOIN portfolio_attribute_history t2 
                                ON t1.atrribute_set_id = t2.atrribute_set_id
                                WHERE t1.eff_dtm = v_prev_date AND t1.exp_dtm = eachAtt.eff_DTM;
                                
                                INSERT INTO portfolio_attributes(Atrribute_Set_Id, Attribute_Cd, Value)
                                VALUES(v_Attribute_Set_Id, eachAtt.attribute_cd, eachAtt.Value);
                                
                                COMMIT;
                            End if;
                  END LOOP;
              END IF;
          
        END LOOP;                
end;
