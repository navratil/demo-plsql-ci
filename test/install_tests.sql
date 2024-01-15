-- University Skills Passport - Unit tests installation

@@define_sql.sql

spool install_tests.log

prompt &&line_separator
prompt ##  University Skills Passport - Unit Tests Installation
prompt ##
prompt ##  Schema: &&run_schema
prompt ##  Date:   &&run_date
prompt &&line_separator
prompt

-- Package Specifications
@@db/packages/test_app_util.pls
@@db/packages/test_app_parameter.pls
@@db/packages/test_db_schema.pls

-- Package Bodies
@@db/packages/test_app_util.plb
@@db/packages/test_app_parameter.plb
@@db/packages/test_db_schema.plb

-- Final Schema Validation
set linesize 80
set pagesize 100
set define on
set heading on
column object_name format a30
column object_type format a15
column status format a10

prompt &&line_separator
prompt ##  List of invalid objects in schema &run_schema
select object_name, object_type, to_char(last_ddl_time, 'DD-MM-YYYY HH24:MI') as last_ddl_time, status 
from user_objects where status != 'VALID'
order by object_name
/

-- End

spool off 

