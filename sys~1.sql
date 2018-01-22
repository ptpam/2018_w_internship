CREATE OR REPLACE DIRECTORY MY_N_DIR AS 'C:';
GRANT READ ON DIRECTORY N_DIR TO SYS;

DECLARE
 vInHandle UTL_FILE.FILE_TYPE;
 vNewLine  VARCHAR2(250);
 str_create_table  VARCHAR2(1024);  -- store the sql command as a string
 table_name VARCHAR2(30);           -- name of the table
 column_no number;                  -- # of the columns in the table
 element_no number;                 -- # of elements will be inserted
 column_name VARCHAR2(30);          -- name of the each column
 column_length VARCHAR2(30);        -- length of the specified type
 column_type VARCHAR2(30);          -- type of the specified column
 sql_stmt    VARCHAR2(200);         -- sql statement for insert an element into the table
 temp_sql_stmt VARCHAR2(200);
 tmp_no number;
 cntr number;
 cntr_table number;
 TYPE table_array IS TABLE OF VARCHAR2(250);    
 t_array table_array:=  table_array();      -- keeps each column info as in the order of name /type(length)
 t_array_type table_array:= table_array();  -- keeps type info for each column 
BEGIN
  str_create_table := 'CREATE TABLE ';
  sql_stmt := 'INSERT INTO ';
  cntr:=0;
  cntr_table := 0;
  vInHandle := utl_file.fopen('MY_N_DIR', 'invoice_230917.txt', 'R');   -- file readed for table info
   LOOP     -- reads the file until eof
    BEGIN
      cntr:= cntr+1;
      UTL_FILE.GET_LINE(vInHandle, vNewLine);
      dbms_output.put_line(vNewLine);
      IF cntr = 2 THEN              -- indicates the table name for specified file format
        table_name := vNewLine;
        str_create_table := CONCAT(str_create_table, table_name);
        str_create_table := CONCAT(str_create_table, ' ( ');
        sql_stmt := CONCAT(sql_stmt, CONCAT(table_name, ' VALUES ('));
      ELSIF cntr = 3 THEN           -- indicates the # of the columns in the table for specified file format
        column_no := vNewLine;
        FOR Lcntr2 IN 1..(column_no-1) LOOP
          sql_stmt := CONCAT(sql_stmt, CONCAT(':',CONCAT(Lcntr2,',')));
        END LOOP;
        sql_stmt:= CONCAT(sql_stmt, CONCAT(':', CONCAT(column_no, ') USING ')));
      ELSIF cntr > 3  AND cntr <= 3 + column_no THEN    -- reads column info as name / type(length)
        cntr_table := cntr_table + 1;
        column_name:= REGEXP_SUBSTR (vNewLine, '(\S*)(\s*)', 1, 1);
        column_length:= REGEXP_SUBSTR (vNewLine, '(\S*)(\s*)', 1, 2);
        column_type:= REGEXP_SUBSTR (vNewLine, '(\S*)(\s*)', 1, 3);
        t_array.EXTEND;
        t_array(t_array.LAST) := column_name|| ' ' || column_type ||' ('||column_length|| ')' ; 
        t_array_type.EXTEND;
        t_array_type(t_array_type.LAST) := column_type;
      ELSIF cntr = 4 + column_no THEN
        FOR Lcntr IN 1..column_no     -- loop for "CREATE TABLE" SQL format
        LOOP
          IF Lcntr <> column_no THEN
            str_create_table := CONCAT(str_create_table, t_array(Lcntr));
            str_create_table := CONCAT(str_create_table, ', ');
          ELSE 
            str_create_table := CONCAT(str_create_table, t_array(Lcntr));
          END IF;
        END LOOP;
        str_create_table := CONCAT(str_create_table, ')');
        --EXECUTE IMMEDIATE str_create_table;   -- execution for creating the table
        element_no := vNewLine;
        temp_sql_stmt := sql_stmt; 
      ELSIF cntr > 4 + column_no AND cntr <= 4 + column_no + element_no THEN
        sql_stmt := temp_sql_stmt;
        FOR Lcntr3 IN 1..column_no    -- loop for "INSERT TABLE" SQL format
        LOOP
          tmp_no := REGEXP_SUBSTR (vNewLine, '(\S*)(\s*)', 1, 2*Lcntr3);
          IF Lcntr3 <> column_no THEN
            IF SUBSTR(t_array_type(Lcntr3), 1, 8) = 'VARCHAR2' THEN
                sql_stmt := CONCAT (sql_stmt, '''');
                sql_stmt := CONCAT(sql_stmt, SUBSTR(REGEXP_SUBSTR (vNewLine, '(\S*)(\s*)', 1, 2*Lcntr3+1),1,tmp_no));
                sql_stmt := CONCAT (sql_stmt, '''');
            ELSE
                sql_stmt := CONCAT(sql_stmt, SUBSTR(REGEXP_SUBSTR (vNewLine, '(\S*)(\s*)', 1, 2*Lcntr3+1),1,tmp_no));
            END IF;
            sql_stmt := CONCAT(sql_stmt, ', ');
          ELSE 
            IF SUBSTR(t_array_type(Lcntr3), 1, 8) = 'VARCHAR2' THEN
                sql_stmt := CONCAT (sql_stmt, '''');
                sql_stmt := CONCAT(sql_stmt, SUBSTR(REGEXP_SUBSTR (vNewLine, '(\S*)(\s*)', 1, 2*Lcntr3+1),1,tmp_no));
                sql_stmt := CONCAT (sql_stmt, '''');
            ELSE
                sql_stmt := CONCAT(sql_stmt, SUBSTR(REGEXP_SUBSTR (vNewLine, '(\S*)(\s*)', 1, 2*Lcntr3+1),1,tmp_no));
            END IF;
          END IF;
        END LOOP;
        dbms_output.put_line(sql_stmt);
        EXECUTE IMMEDIATE sql_stmt;
        --dbms_output.put_line('exec is successful');
      END IF; 
    EXCEPTION
      WHEN OTHERS THEN
        EXIT;
    END;
  END LOOP;
  UTL_FILE.FCLOSE(vInHandle);
END fopen;

