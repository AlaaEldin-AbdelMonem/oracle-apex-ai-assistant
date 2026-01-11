--------------------------------------------------------
--  DDL for View HR_VW_MANAGER_TEAM
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HR_VW_MANAGER_TEAM" ("EMPLOYEE_ID", "FULL_NAME", "EMAIL", "JOB_TITLE", "HIRE_DATE", "MANAGER_ID", "DEPARTMENT", "LEAVE_TYPE", "LEAVE_BALANCE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
    e.employee_id,
    e.full_name,
    e.email,
    e.job_title,
    e.hire_date,
    e.manager_id,
    e.department,
    l.leave_type,
    l.leave_balance
FROM hcm_employee e
LEFT JOIN hcm_leave_balance l ON e.employee_id = l.employee_id
;
