-- Set SQL environment for installation scripts

set serveroutput on size unlimited format truncated
whenever oserror continue

set heading off
set linesize 1000
set pagesize 0

set verify off
set define on

set termout on
set timing off
set feedback off

column line_separator new_value line_separator noprint
select '######################################################################' as line_separator from dual;

column run_date new_value run_date noprint
select to_char(sysdate, 'DD-MM-YYYY HH24:MI:SS') as run_date from dual;

column run_date_ymd new_value run_date_ymd noprint
select to_char(sysdate, 'YYYYMMDD-HH24:MI:SS') as run_date_ymd from dual;


column run_schema new_value run_schema noprint
select  SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') as run_schema from dual;

set feedback on
