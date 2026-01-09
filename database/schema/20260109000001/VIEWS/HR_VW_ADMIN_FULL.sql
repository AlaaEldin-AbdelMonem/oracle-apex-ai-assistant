--------------------------------------------------------
--  DDL for View HR_VW_ADMIN_FULL
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "AI8P"."HR_VW_ADMIN_FULL" ("EMPLOYEE_ID", "EMPLOYEE_NAME", "EMAIL", "JOB_TITLE", "HIRE_DATE", "MANAGER_ID", "DEPARTMENT", "GRADE", "LOCATION", "BASIC_SALARY", "CURRENCY", "LEAVE_TYPE", "LEAVE_BALANCE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
    e.employee_id,
    e.full_name AS employee_name,
    e.email,
    e.job_title,
    e.hire_date,
    e.manager_id,
    e.department,
    a.grade,
    a.location,
    s.basic_salary,
    s.currency,
    l.leave_type,
    l.leave_balance
FROM hcm_employee e
LEFT JOIN hcm_assignment a ON e.employee_id = a.employee_id
LEFT JOIN (
    SELECT s1.employee_id, s1.basic_salary, s1.currency, s1.effective_date
    FROM hcm_salary s1
    WHERE s1.effective_date = (
        SELECT MAX(s2.effective_date)
        FROM hcm_salary s2
        WHERE s2.employee_id = s1.employee_id
    )
) s ON e.employee_id = s.employee_id
LEFT JOIN hcm_leave_balance l ON e.employee_id = l.employee_id
;
