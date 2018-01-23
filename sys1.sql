/*
* Write an SQL query that selects employee’s id, employee’s first name 
* and employee’s department name for all employees. 
*/

SELECT employee_id, first_name ,department_name
  FROM hr.employees e
       JOIN hr.departments d ON d.department_id = e.department_id;
       
/*
* Create a report that displays the employee’s id and their manager’s id. 
*/       

SELECT e1.employee_id employee,
       e2.employee_id manager
  FROM hr.employees e1 JOIN hr.employees e2 ON e1.manager_id = e2.employee_id
  ORDER BY EMPLOYEE;

/*
* For example; first three character of PHONE_NUMBER column gives us a operator of employee. 
* Create a report that displays the operators and their total subscriber. 
* But we want two different displays with diffrent queries. 
*/

SELECT  substr(phone_number, 1, 3) operator, count(*) total
FROM HR.EMPLOYEES
group by substr(phone_number, 1, 3);

SELECT * FROM
(SELECT SUBSTR(phone_number, 1, 3) AS operatorr , COUNT(substr(phone_number,1 ,3)) AS total
FROM HR.EMPLOYEES  GROUP BY SUBSTR(phone_number,1 ,3))
PIVOT(
    SUM(total) FOR
    (operatorr) IN (515, 590, 603, q'[011]', 650)
);

/*
* Create a table (table name like HR.EMP) from HR.EMPLOYEES table. 
* Insert a new row to HR.EMP table and update this employee’s phone number and salary. 
* Delete your new row and display the HR.EMP table. 
* Finally drop your table HR.EMP
*/

CREATE TABLE EMP_TABLE
(
  EMPLOYEE_ID     NUMBER(6),
  FIRST_NAME      VARCHAR2(20 BYTE),
  LAST_NAME       VARCHAR2(25 BYTE) CONSTRAINT EMP_LAST_NAME_NN NOT NULL,
  EMAIL           VARCHAR2(25 BYTE) CONSTRAINT EMP_EMAIL_NN NOT NULL,
  PHONE_NUMBER    VARCHAR2(20 BYTE),
  HIRE_DATE       DATE CONSTRAINT EMP_HIRE_DATE_NN NOT NULL,
  JOB_ID          VARCHAR2(10 BYTE) CONSTRAINT EMP_JOB_NN NOT NULL,
  SALARY          NUMBER(8,2),
  COMMISSION_PCT  NUMBER(2,2),
  MANAGER_ID      NUMBER(6),
  DEPARTMENT_ID   NUMBER(4)
);

SET DEFINE OFF;
Insert INTO EMP_TABLE
   (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, MANAGER_ID, DEPARTMENT_ID)
 VALUES
   (198, 'Donald', 'OConnell', 'DOCONNEL', '650.507.9833', 
    TO_DATE('06/21/2007 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SH_CLERK', 2600, 124, 50);
COMMIT;

UPDATE EMP_TABLE
   SET phone_number = '650.508.9833',
       salary = 2650
 WHERE FIRST_NAME = 'Donald';

DELETE FROM EMP_TABLE
WHERE FIRST_NAME = 'Donald';

DROP TABLE EMP_TABLE;

/*
* Hide names & surnames other than the first two letters for privacy concerns
*/

SELECT  SUBSTR(FIRST_NAME, 1, 2) || SUBSTR(LPAD(FIRST_NAME, 2*(LENGTH(FIRST_NAME)), '*'), 1, LENGTH(FIRST_NAME)-2) || ' ' ||
        SUBSTR(LAST_NAME, 1, 2) || SUBSTR(LPAD(LAST_NAME, 2*(LENGTH(LAST_NAME)), '*'), 1, LENGTH(LAST_NAME)-2)
AS CUSTOMERNAME 
FROM hr.employees 
ORDER BY FIRST_NAME;


