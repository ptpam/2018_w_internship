/*
* Write a PL/SQL program that prints out all even numbers between 1 and 20
*/

BEGIN 
    FOR Lcntr IN 0..20
    LOOP
        IF  MOD(Lcntr,2) = 0 THEN
            dbms_output.put_line (Lcntr);
        END IF;
    END LOOP;
END;

/*
* Write a PL/SQL program that prints out all first and last names from HR.EMPLOYEES table.
*/

DECLARE
   CURSOR employees_in_10_cur
   IS
      SELECT *
        FROM HR.EMPLOYEES
        ORDER BY LAST_NAME;
BEGIN
   FOR employee_rec IN employees_in_10_cur
   LOOP
      DBMS_OUTPUT.PUT_LINE ('Firts Name - Last Name = '
         || employee_rec.first_name|| ' ' ||
         employee_rec.last_name);
   END LOOP;
END;

/*
* Write an SQL query that selects first name of the employee with highest employee id. 
* (Please use HR.EMPLOYEES table)
*/

SELECT FIRST_NAME FROM (
    SELECT * FROM HR.EMPLOYEES 
    ORDER BY EMPLOYEE_ID DESC) 
WHERE ROWNUM = 1;

/*
* Create a report that displays all employees, 
* and indicate with the words Yes or No whether they receive a commission. 
*/

SELECT LAST_NAME, SALARY, 
    CASE
        WHEN COMMISSION_PCT IS NULL THEN 'No'
                                    ELSE 'Yes'
    END AS COMMISSION                              
FROM HR.EMPLOYEES;   

/*
* Create a report that displays total salary of each deparment. 
* We want two columns on report; department name and total salary. 
*/

SELECT dept.DEPARTMENT_NAME, SUM(empl.SALARY)
FROM HR.EMPLOYEES empl
JOIN HR.DEPARTMENTS dept on empl.DEPARTMENT_ID = dept.DEPARTMENT_ID 
GROUP BY empl.DEPARTMENT_ID, dept.DEPARTMENT_NAME
ORDER BY empl.DEPARTMENT_ID;

/*
* Create a report that displays department id, first name, 
* salary and rank of employee’s salary in own department. 
*/

SELECT department_id, first_name, salary,ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary) AS "Rank"
FROM HR.EMPLOYEES 
ORDER BY department_id;  

/*
* Write a PL/SQL program that prints out string in xml format.
*    Input String : “a4b4c2d9d9c2e6e6b4s2o1o1s2a4w2r8r8k3g5g5k3w2”
*/

CREATE OR REPLACE TYPE CHARS_TABLE IS TABLE OF CHAR(2);
/
CREATE OR REPLACE TYPE INTEGERS_TABLE IS TABLE OF INTEGER;
/
DECLARE
  word VARCHAR2(50) := 'a4b4c2d9d9c2e6e6b4s2o1o1s2a4w2r8r8k2g5g5k2w2';
  num  PLS_INTEGER := LENGTH( word ) / 2;
  name_array  CHARS_TABLE    := CHARS_TABLE();
  depth_array INTEGERS_TABLE := INTEGERS_TABLE();
  open_array  INTEGERS_TABLE := INTEGERS_TABLE();
BEGIN
  name_array.EXTEND( num );
  depth_array.EXTEND( num );
  open_array.EXTEND( num );

  name_array(1)  := SUBSTR( word, LENGTH(word)-1, 2 );
  depth_array(1) := 1;
  open_array(1)  := 1;

  FOR i IN 2 .. num LOOP
    name_array(i) := SUBSTR( word, 2*i - 1, 2 );
    open_array(i) := 1;
    FOR j IN 1 .. i-1 LOOP
      IF name_array(j) = name_array(i) THEN
        open_array(i) := -open_array(i);
      END IF;
    END LOOP;
    depth_array(i) := depth_array(i-1) + open_array(i);
  END LOOP;

  FOR i IN 1 .. num LOOP
    FOR j IN 2 .. depth_array(i) + CASE open_array(i) WHEN 1 THEN 0 ELSE 1 END LOOP
      DBMS_OUTPUT.PUT( '  ' );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE( name_array(i) );
  END LOOP;
END;

