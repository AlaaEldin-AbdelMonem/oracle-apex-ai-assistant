--------------------------------------------------------
--  DDL for View HR_VW_PAYROLL_DEPT
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HR_VW_PAYROLL_DEPT" ("EMPLOYEE_ID", "EMPLOYEE_NAME", "JOB_TITLE", "DEPARTMENT", "GRADE", "LOCATION", "BASIC_SALARY", "CURRENCY", "EFFECTIVE_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
    e.employee_id,
    e.full_name AS employee_name,
    e.job_title,
    e.department,
    a.grade,
    a.location,
    s.basic_salary,
    s.currency,
    s.effective_date
FROM hcm_employee e
LEFT JOIN hcm_assignment a ON e.employee_id = a.employee_id
LEFT JOIN hcm_salary s ON e.employee_id = s.employee_id
WHERE s.effective_date = (
    SELECT MAX(s2.effective_date)
    FROM hcm_salary s2
    WHERE s2.employee_id = e.employee_id
) OR s.effective_date IS NULL
;
