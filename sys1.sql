SELECT employee_id, first_name ,department_name
  FROM hr.employees e
       JOIN hr.departments d ON d.department_id = e.department_id;

