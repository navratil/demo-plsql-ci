-- University Skills Passport - Schema installation

@@define_sql.sql

spool install.log

prompt &&line_separator
prompt ##  University Skills Passport - Installation
prompt ##
prompt ##  Schema: &&run_schema
prompt ##  Date:   &&run_date
prompt &&line_separator
prompt

-- Tables
@@db/tables/app_parameters.sql 
@@db/tables/app_parameter_tags.sql

-- Package Specifications
@@db/packages/app_util.pls
@@db/packages/app_parameter.pls

-- Package Bodies
@@db/packages/app_util.plb
@@db/packages/app_parameter.plb

-- Final Schema Validation
set linesize 80
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

