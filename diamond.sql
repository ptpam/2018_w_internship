DECLARE      
 cntr number;
 vNewLine  VARCHAR2(250);
 
BEGIN
    cntr := 0;
  WHILE cntr <= 13  LOOP
    vNewLine := '';
    cntr:= cntr +1;
    IF cntr < 7 THEN
       FOR Lcntr IN 1.. 7-cntr LOOP
            vNewLine := CONCAT(vNewLine, ' ');
       END LOOP;
       FOR Lcntr IN 1.. 2*cntr-1 LOOP
            vNewLine := CONCAT(vNewLine, '*');
       END LOOP;
       dbms_output.put_line(vNewLine);
    ELSIF cntr > 7 THEN
       FOR Lcntr IN 1.. cntr-7 LOOP
            vNewLine := CONCAT(vNewLine, ' ');
       END LOOP;
       FOR Lcntr IN 1.. 2*(14-cntr)-1 LOOP
            vNewLine := CONCAT(vNewLine, '*');
       END LOOP;
       dbms_output.put_line(vNewLine);
    ELSE
        FOR Lcntr IN 1.. 2*cntr-1 LOOP
            vNewLine := CONCAT(vNewLine, '*');
       END LOOP;
       dbms_output.put_line(vNewLine);
    END IF;
  END LOOP;
END;  
