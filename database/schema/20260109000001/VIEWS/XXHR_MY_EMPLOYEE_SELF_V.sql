--------------------------------------------------------
--  DDL for View XXHR_MY_EMPLOYEE_SELF_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXHR_MY_EMPLOYEE_SELF_V" ("EMPLOYEE_ID", "FULL_NAME", "EMAIL", "HIRE_DATE", "JOB_TITLE", "MANAGER_ID", "DEPARTMENT", "LEAVE_TYPE", "LEAVE_BALANCE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
    e.employee_id,
    e.full_name,
    e.email,
    e.hire_date,
    e.job_title,
    e.manager_id,
    e.department,
    l.leave_type,
    l.leave_balance
FROM hcm_employee e
LEFT JOIN hcm_leave_balance l ON e.employee_id = l.employee_id
WHERE e.employee_id = SYS_CONTEXT('APEX$SESSION', 'APP_USER_ID')
;
