DECLARE      
 cntr number;
 vNewLine  VARCHAR2(250);
 
BEGIN
  cntr := 0;
  WHILE cntr <= 13  LOOP
    vNewLine := '';
    cntr:= cntr +1;
       FOR Lcntr IN 1.. ABS(7-cntr) LOOP
            vNewLine := CONCAT(vNewLine, ' ');
       END LOOP;
       IF cntr <= 7 THEN 
           FOR Lcntr IN  REVERSE 1.. 2*MOD(cntr,14)-1 LOOP
                vNewLine := CONCAT(vNewLine, '*');
           END LOOP;
       ELSE 
           FOR Lcntr IN  REVERSE 1.. 2*(14-cntr)-1  LOOP
                vNewLine := CONCAT(vNewLine, '*');
           END LOOP;
       END IF;
       dbms_output.put_line(vNewLine);
  END LOOP;
END;  
 
