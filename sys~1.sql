DECLARE
 vInHandle UTL_FILE.FILE_TYPE;
 vNewLine  VARCHAR2(250);
 str_create_table  VARCHAR2(1024);
 table_name VARCHAR2(30);
 column_no number(2);
 column_name VARCHAR2(30);
 column_length VARCHAR2(30);
 column_type VARCHAR2(30);
 cntr number;
 cntr_table number;
 TYPE table_array IS TABLE OF VARCHAR2 (250);
 t_array table_array:=  table_array(); 
BEGIN
  str_create_table := 'CREATE TABLE ';
  cntr:=0;
  cntr_table := 0;
  vInHandle := UTL_FILE.FOPEN('MELIKE','invoice_230917.txt','R');
  LOOP
    BEGIN
      cntr:= cntr+1;
      UTL_FILE.GET_LINE(vInHandle, vNewLine);
      dbms_output.put_line(vNewLine);
      IF cntr = 2 THEN
        table_name := vNewLine;
        str_create_table := CONCAT(str_create_table, table_name);
        str_create_table := CONCAT(str_create_table, ' ( ');
      ELSIF cntr = 3 THEN
        column_no := vNewLine;
      ELSIF cntr > 3  AND cntr <= 3 + column_no THEN
        cntr_table := cntr_table + 1;
        column_name:= REGEXP_SUBSTR (vNewLine, '(\S*)(\s*)', 1, 1);
        column_length:= REGEXP_SUBSTR (vNewLine, '(\S*)(\s*)', 1, 2);
        column_type:= REGEXP_SUBSTR (vNewLine, '(\S*)(\s*)', 1, 3);
        t_array.EXTEND;
        t_array(t_array.LAST) := column_name|| ' ' || column_type ||' ('||column_length|| ')' ; 
        --dbms_output.put_line(t_array(cntr_table));
      END IF; 
    EXCEPTION
      WHEN OTHERS THEN
        EXIT;
    END;
  END LOOP;
  UTL_FILE.FCLOSE(vInHandle);
  FOR Lcntr IN 1..column_no
  LOOP
  --dbms_output.put_line(Lcntr);
    IF Lcntr <> column_no THEN
      --dbms_output.put_line('IF');
      str_create_table := CONCAT(str_create_table, t_array(Lcntr));
      str_create_table := CONCAT(str_create_table, ', ');
    ELSE 
      --dbms_output.put_line('ELSE ' || str_create_table);
      str_create_table := CONCAT(str_create_table, t_array(Lcntr));
    END IF;
  END LOOP;
  str_create_table := CONCAT(str_create_table, ');');
  --dbms_output.put_line(str_create_table);
  EXECUTE IMMEDIATE str_create_table;
END FOPEN;
/

CREATE OR REPLACE DIRECTORY MELIKE AS 'C:\';
/

GRANT READ ON DIRECTORY MELIKE TO SYS;
/
